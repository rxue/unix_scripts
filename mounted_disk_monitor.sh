#!/bin/bash
# $1  mount file system type, i.e. ext2, ext3, ext4, 
#     xfs (common for big data processing) 
#     Ref: http://linoxide.com/file-system/create-mount-extend-xfs-filesystem/
# $2  used disk space limit in percentage
# return 
function monitor_disk_partition_space {
  type="${1}"
  if [ -n "${2}" ]; then
    limit="${2}"
  else 
    limit=30
  fi

  python_code=`cat <<-EOF
import sys;
filtered = filter(lambda x : "${type}" in x, sys.stdin.readlines());
if not filtered: print 2;
elif not filter(lambda x : int(x.split()[5].strip('%')) > ${limit}, filtered):
  print 0;
else: print 1;
EOF`
#else if not filter(lambda x : int(x.split()[5].strip('%')) > ${limit}, list):
#  print 0;
  df -T |python -c "$python_code"
}

