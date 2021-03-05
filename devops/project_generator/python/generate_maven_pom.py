import sys
import os
import utils
my_directory = os.path.dirname(os.path.abspath(__file__))
project_name=sys.argv[2]
replacement_dict = {}
replacement_dict["#{groupId}"]=sys.argv[1]
replacement_dict["#{name}"]=project_name
replacement_dict["#{version}"]="1.0"
utils.replace(my_directory+"/../templates/pom.xml.template", project_name + "/pom.xml", replacement_dict)
