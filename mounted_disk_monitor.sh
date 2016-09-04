#!/bin/bash
# Logics:
# 1.  Tail the last line of log,
#       - if the last log is WARNING, send mail in case there is parition exceeded the limit  
# 2.  Check whether any partition exceeded the given limit with command - df
# 3.  Send mail if there are partitions exceeded the limit and the last log LEVEL is INFO 
# 4.  Take snapshot of the disk space state
script_name=$(basename ${BASH_SOURCE})
log_file="/var/log${script_name/.sh/.log}"
last_log="$(tail -n 1 ${log_file} 2>/dev/null)"
last_log_level="INFO"
if grep "WARN" <<<"$last_log"; then
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
  local limit=30
  if [ -n "${2}" ]; then
    limit="${2}"
  fi
  local ret=0
  local looped=false
  while read line; do
    looped=true
    arr=(${line})
    partition=${arr[0]}
    used=${arr[4]}
    mounted=${arr[5]}
    #Deletes shortest match of "%" from back of $used
    #Ref: http://tldp.org/LDP/abs/html/string-manipulation.html
    if [ ! ${used%\%} -lt $limit ]; then
      logger -t "${script_name}" \
        "WARN: Partition $partition mounted to $mounted has $used (>${limit}%) used"
      ret=1
    fi
  #http://tldp.org/LDP/abs/html/process-sub.html
  done < <(df --block-size=1024 --type=${_fs_type} 2>/dev/null)
  if $looped; then 
    return $ret
  else 
    return 2
  fi
}
fs_type=ext4
# $1 email address
send_mail() {
  subject="Some of the disk partitions exceeded the limit - $quota - in ${HOSTNAME}"

  echo "
${subject}. Refer to the following snapshot of command - df:

$(df --block-size=1024 --type=${fs_type} -h)" |mail -s "$subject" $1
}
monitor_disk_partition_space xfs


