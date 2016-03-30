#!/bin/sh
print_usage() {
	echo "Usage: ${SCRIPT_NAME} -f <path of the file to watch> -s <shell scrip to execute>"
	exit 1
}
FILE=~/test.csv
while getopts ":f:s:" opt; do
  case $opt in
    f)
      FILE=$OPTARG
      ;;  
		s)
			SCRIPT_CMD=$OPTARG
			SCRIPT_CMD=${SCRIPT_CMD/#~/$(echo ~)}
			;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      print_usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      print_usage
      ;;
  esac
done
FILE=${FILE/#~/$(echo ~)}
DIR="$(dirname "$FILE")"
if [ ! -d $DIR ]; then 
	print_usage
fi
while true; do
	if [ ! -f $FILE ] && inotifywait --format '%e %f : %w' $DIR; then #NOTE! I am not sure if the two boolean operations connected by && is atomic or not, if not this is a bug
		[ -f $FILE ] && /bin/bash $SCRIPT_CMD
	elif [ -f $FILE ] && inotifywait -e modify,delete_self,move_self --format '%e %f : %w' $FILE; then
		[ -f $FILE ] && /bin/bash $SCRIPT_CMD
	fi
done
