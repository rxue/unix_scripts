import xml.etree.ElementTree as ET
import re
import sys

def update_maven_pom(pom_xml_path:str):
  namespace_key = 'n'
  tree = ET.parse(pom_xml_path)

  def _get_namespace()->str:
    root_tag = tree.findall(".")[0].tag
    return re.search("(?<={).*(?=})", root_tag).group(0)

  namespace = _get_namespace() 
  namespaces = {namespace_key: namespace}

  def _update_java_version():
    java_version = '1.8'
    tree.findall('./'+namespace_key+':properties/'+namespace_key+':maven.compiler.source', namespaces)[0].text = java_version
    tree.findall('./'+namespace_key+':properties/'+namespace_key+':maven.compiler.target', namespaces)[0].text = java_version

  def _remove_junit_dependency(): 
    xpath_dependencies = './'+namespace_key+':dependencies'
    dependencies = tree.findall(xpath_dependencies, namespaces)[0]
    junit_dependency = tree.findall(xpath_dependencies+'/'+namespace_key+':dependency', namespaces)[0]
    dependencies.remove(junit_dependency)

  _update_java_version()
  _remove_junit_dependency()
  ET.register_namespace('',namespace)
  tree.write(pom_xml_path) 

if __name__ == "__main__":
  update_maven_pom(sys.argv[1])
