#!/bin/bash
# $1  mount file system type, i.e. ext2, ext3, ext4, 
#     xfs (common for big data processing) 
#     Ref: http://linoxide.com/file-system/create-mount-extend-xfs-filesystem/
# $2 used disk space limit in percentage
function monitor_disk_partition_space {
  type="${1}"
  python_code=`cat <<-EOF
import sys;
data = sys.stdin.readlines();
data = filter(lambda x : "${type}" in x, data); 
print data;
EOF`
  df -T |python -c "$python_code"
}

