import sys
import re
def get_str(content:str,regex:str,split_by:str,print_result=True)->str:
  for splitted in content.split(split_by):
    if re.search(regex,splitted):
      if print_result:
        print(splitted)
      return splitted

def _replace(content:str, replacement_list:dict):
  result = None
  for key in replacement_list:
    if result == None:
      result = content.replace(key, replacement_list[key])
    else:
      result = result.replace(key, replacement_list[key])
  return result

def replace(from_file:str, to_file:str, replacement_list:dict):
  output = []
  with open(from_file) as inp:
    for inp_line in inp:
      output.append(_replace(inp_line, replacement_list))
        
  with open(to_file, 'w') as outp:
    for e in output:
      outp.write(e)

if __name__ == "__main__":
  eval(sys.argv[1] + '("' + sys.argv[2] + '", "' + sys.argv[3] + '", "' + sys.argv[4] + '")')
