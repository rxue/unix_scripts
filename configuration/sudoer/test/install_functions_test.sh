source install_functions.sh
set +x
log_prefix="::"
echo ${log_prefix}"Test _basename_without_extension"
file_link=https://dlcdn.apache.org/maven/maven-3/3.9.0/binaries/apache-maven-3.9.0-bin.tar.gz
result=`_basename_without_extension ${file_link}`
if [ ${result} == 'apache-maven-3.9.0-bin' ]; then
  echo ${log_prefix}"    PASSED :)"
else
  echo ${log_prefix}"    FAILED :("
fi

echo ${log_prefix}"Test _extract_software_2"
_extract_software_2 ${file_link} test/
package_name=`_basename_without_extension ${file_link}`
ls test/${package_name%-bin}
if [ $? -eq 0 ]; then
  echo ${log_prefix}"    PASSED :)"
  rm -r test/${package_name%-bin}
else
  echo ${log_prefix}"    FAILED :("
fi
