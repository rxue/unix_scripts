import xml.etree.ElementTree as ET
import re
import sys
namespace_key = 'n'
def _get_namespace(tree:ET)->str:
  root_tag = tree.findall(".")[0].tag
  return re.search("(?<={).*(?=})", root_tag).group(0)

def _update_java_version(tree:ET, namespaces:dict):
  global namespace_key
  java_version = '1.8'
  tree.findall('./'+namespace_key+':properties/'+namespace_key+':maven.compiler.source', namespaces)[0].text = java_version
  tree.findall('./'+namespace_key+':properties/'+namespace_key+':maven.compiler.target', namespaces)[0].text = java_version

def _remove_junit_dependency(tree:ET, namespaces:dict): 
  global namespace_key
  xpath_dependencies = './'+namespace_key+':dependencies'
  dependencies = tree.findall(xpath_dependencies, namespaces)[0]
  junit_dependency = tree.findall(xpath_dependencies+'/'+namespace_key+':dependency', namespaces)[0]
  dependencies.remove(junit_dependency)

def update_maven_pom(pom_xml_path:str):
  global namespace_key
  tree = ET.parse(pom_xml_path)
  namespace = _get_namespace(tree) 
  namespaces = {namespace_key: namespace}
  _update_java_version(tree, namespaces)
  _remove_junit_dependency(tree, namespaces)
  ET.register_namespace('',namespace)
  tree.write(pom_xml_path) 

if __name__ == "__main__":
  update_maven_pom(sys.argv[1])
