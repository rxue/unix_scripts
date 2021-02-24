import sys
import re
def get_str(content:str,regex:str,split_by:str,print_result=True)->str:
  for splitted in content.split(split_by):
    if re.search(regex,splitted):
      if print_result:
        print(splitted)
      return splitted

if __name__ == "__main__":
  eval(sys.argv[1] + '("' + sys.argv[2] + '", "' + sys.argv[3] + '", "' + sys.argv[4] + '")')
