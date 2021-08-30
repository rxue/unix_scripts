# Generate a clean maven project with Java 8, JUnit 5
SCRIPT_DIR=$(dirname ${BASH_SOURCE[0]})
export PYTHONPATH="./${SCRIPT_DIR}/../../python"
function generate_maven {
  group_id=$1
  name=$2
  mvn archetype:generate -DgroupId=${group_id} -DartifactId=${name} -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false
  python3 ${SCRIPT_DIR}/python/generate_maven_pom.py ${group_id} ${name}
  # remove automatically generated java class files
  package_dir=$(python3 -c "print('${group_id}'.replace('.','/'))")
  rm ${name}/src/main/java/${package_dir}/*.java
  rm ${name}/src/test/java/${package_dir}/*.java
}
