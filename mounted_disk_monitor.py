#!/usr/bin/python
import sys
import subprocess
def __check_used_disk_space(fsType, limit):
  cmdOutput = subprocess.getoutput(["df -T"])
  filtered = list(filter(lambda x : fsType in x, cmdOutput.split('\n')))
  print(filtered)
  if not filtered:
    return None
  else:
    return filter(lambda x : int(x.split()[5].strip('%')) > limit, filtered)  
re = __check_used_disk_space("ext4", 30)
if re != None:
  print(list(re))
#print(sys.argv)
