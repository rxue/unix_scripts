import re


def replace(from_file:str, to_file:str, replacement_dict:dict):
  def _read()->str:
    result = []
    with open(from_file) as inp:
      for inp_line in inp:
        result.append(inp_line)
    return result
  input = _read()

  def _replace_regex(content:str):
    result = None
    for key in replacement_dict:
      if result == None:
        result = re.sub(key, replacement_dict[key], content)
      else:
        result = re.sub(key, replacement_dict[key], result)
    return result 

  with open(to_file, 'w') as outp:
    for line in input:
      outp.write(_replace_regex(line))
