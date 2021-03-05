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
  
  xpath_dependencies = './'+namespace_key+':dependencies'
  dependencies = tree.findall(xpath_dependencies, namespaces)[0]

  def _remove_junit_dependency(): 
    junit_dependency = tree.findall(xpath_dependencies+'/'+namespace_key+':dependency', namespaces)[0]
    dependencies.remove(junit_dependency)

  _update_java_version()
  _remove_junit_dependency()
  indent = '  '
  dependency_element = ET.Element('dependency')
  dependency_element.text = '\n' + indent*3
  dependency_element.tail = '\n' + indent
  groupid_element = ET.Element('groupId')
  groupid_element.text = 'org.junit.jupiter'
  groupid_element.tail = '\n' + indent*3
  dependency_element.append(groupid_element)
  artifactid_element = ET.Element('artifactId')
  artifactid_element.text = 'org.junit.jupiter-api'
  artifactid_element.tail = '\n' + indent*3
  dependency_element.append(artifactid_element)
  version_element = ET.Element('version')
  version_element.text = '1.1'
  version_element.tail = '\n'
  dependency_element.append(version_element)
  dependencies.append(dependency_element)
  ET.register_namespace('',namespace)
  tree.write(pom_xml_path, xml_declaration=True) 

if __name__ == "__main__":
  update_maven_pom(sys.argv[1])
