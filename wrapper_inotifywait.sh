#!/bin/bash
print_usage() {
	echo "Usage: ${BASH_SOURCE}	-f <path of the file to watch> -c <command or script with arguments to execute> [-l loop or not ] [-s the command is a script name ] [-t <seconds> sleep time in seconds after a successful execution ]"
	exit 1
}
sec=1
while getopts ":f:c:el:ost:" opt; do
	case ${opt} in
		f)
			file="${OPTARG}"
			;;  
		c)
			script_cmd="${OPTARG}"
			;;
		e)
			loop=true
			;;
		l)
			log_file="${OPTARG}"
			;;
		o)
			overwrite=true
			;;
		s)
			script=true
			;;
		t)
			sec=${OPTARG}
			;;
		\?)
			echo "Invalid option: -${OPTARG}" >&2
			print_usage
			;;
		:)
			echo "Option -${OPTARG} requires an argument." >&2
			print_usage
			;;
		esac
done

validate() {
	if [ -z "${file}" ]; then
		echo "File to watch not given" >&2
		print_usage
	fi
	DIR="$(dirname "${file}")"
	if [ ! -d "${DIR}" ]; then
		echo "Directory of the given file path does not exist" >&2
		print_usage
	fi
	if [ -z "${script_cmd}" ]; then
		echo "The command is not given" >&2
		print_usage
	fi
}
if [ "${overwrite}" = true ]; then
	> ${log_file}
fi
# predetermined var for logger function: log_file file to log to
# predetermined var for logger function: overwrite or append (default)
#
# $1 log level - INFO ERROR DEBUG
# $2 log message
# $3 shell line number
logger() {
	echo "$(date) $1 [${BASH_SOURCE}:$3] $2" >> $log_file
}
validate
eval file="$file"
#NOTE! I am not sure if the two boolean operations connected by && is atomic or not, if not this is a bug
while true; do
  # watch and wait
	if [ ! -f $file ] && inotifywait --format '%e %f : %w' $DIR; then
		EXEC=true 
	#elif [ -f $file ] && inotifywait -e modify,delete_self,move_self --format '%e %f : %w' $file; then
	elif [ -f $file ] && inotifywait --format '%e %f : %w' $file; then
		EXEC=true
	fi
	sleep ${sec}
	# execute
	if [ "$EXEC" = true -a -f $file ]; then 
		if [ "$script" = true ]; then			
			/bin/bash ${script_cmd}
			EXIT_CODE=$?
			LINE_NO=$(expr ${LINENO} - 2)
		else
			eval "${script_cmd}"
			EXIT_CODE=$?
			LINE_NO=$(expr ${LINENO} - 2)
		fi
		if [ $EXIT_CODE -eq 0 ]; then
			logger INFO "COMMAND or script - ${script_cmd} - execution succeeded :)" $LINE_NO
		else
			logger ERROR "COMMAND or script - ${script_cmd} - execution failed :<" $LINE_NO
		fi
	fi
	if [ "$loop" != true ]; then #This true is /bin/true
		exit $EXIT_CODE
	elif [ "$EXEC" = true ]; then
		EXEC=false
	fi
done
