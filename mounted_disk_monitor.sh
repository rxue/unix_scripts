#!/bin/bash
# Logics:
# 1.  Tail the last line of log,
#       - if the last log is WARNING, send mail in case there is parition exceeded the limit  
# 2.  Check whether any partition exceeded the given limit with command - df
# 3.  Send mail if there are partitions exceeded the limit and the last log LEVEL is INFO 
# 4.  Take snapshot of the disk space state
script_name=$(basename ${BASH_SOURCE})
function print_usage {
  echo "usage: ${script_name} -f <file system type> -q <used disk space quota in percentage> \
-e <target email address>"
  echo "NOTE! File system tmpfs and NFS are ignored"
  if [ ! ${1} -eq 0 ]; then 
    exit ${1}
  fi
}
while getopts ":e:f:q:" opt; do
  case ${opt} in
  e)
    email=${OPTARG}
    ;;
  f)
    fs_type=${OPTARG}
    ;;
  q)
    quota=${OPTARG}
    ;; 
  \?)
    echo "Unknown option: -${OPTARG}" >&2
    print_usage 1
    ;;
  :)
    echo "Option -${OPTARG} requires an argument." >&2
    exit 1
    ;;
  esac
done

if [ -z "${email}" ]; then
  echo "target email address not given" >&2
  print_usage 1
fi
if [ -z "${fs_type}" ]; then
  echo "target email address not given" >&2
  print_usage 1
fi
if [ -z "${quota}" ]; then
  echo "disk quota in percentage (1-100) not given" >&2
  print_usage 1
fi
log_file="/var/log/${script_name/.sh/.log}"
last_log="$(tail -n 1 ${log_file} 2>/dev/null)"
last_log_level="INFO"
if grep "WARN" <<<"${last_log}"; then
  last_log_level="WARN"
fi
# Monitor the disk partitions space state
# $1  mount file system type, i.e. ext2, ext3, ext4, 
#     xfs (common for big data processing) 
#     Ref: http://linoxide.com/file-system/create-mount-extend-xfs-filesystem/
# $2  used disk space limit in percentage
# @return
#     0 no error 
#     1 there are partitions exceeded limit 
#     2 no partitions found with the given file system type
function monitor_disk_partition_space {
  local _fs_type="${1}"
  local _limit=${2}
  local _ret=0
  local _looped=false
  while read _line; do
    _looped=true
    local _arr=(${_line})
    local _partition=${_arr[0]}
    local _used=${_arr[4]}
    local _mounted=${_arr[5]}
    #Deletes shortest match of "%" from back of $used
    #Ref: http://tldp.org/LDP/abs/html/string-manipulation.html
    if [ ! ${_used%\%} -lt ${_limit} ]; then
      logger -t "${script_name}" \
        "WARN: Partition ${_partition} mounted to ${_mounted} has ${_used} (>${_limit}%) used"
      _ret=1
    fi
  #http://tldp.org/LDP/abs/html/process-sub.html
  done < <(df --block-size=1024 --type=${_fs_type} 2>/dev/null |sed 1d)
  if ${_looped} && [ ${_ret} -eq 0 ]; then 
    logger -t "${script_name}" "INFO: So far so good"
  elif ! ${_looped}; then 
    _ret=2
  fi
  return ${_ret}
}
# $1 quota of used disk space
# $2 file system type
# $3 email address
function send_mail {
  local _fs_type=${1}
  local _limit=${2}
  local _email=${3}
  local _subject="WARNING! Some of the disk partitions used space exceeded the limit - ${_limit}% - in ${HOSTNAME}"
  echo "
${_subject}. Refer to the following snapshot of command - df:

$(df --block-size=1024 --type=${_fs_type} -h)" |mail -s "${_subject}" ${_email}
}
monitor_disk_partition_space ${fs_type} ${quota}
if [ $? -eq 1 -a "${last_log_level}" == "INFO" ]; then
  send_mail ${fs_type} ${quota} ${email}
fi
