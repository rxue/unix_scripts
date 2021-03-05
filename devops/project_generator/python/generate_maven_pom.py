import sys
import os
import utils
replacement_dict = {}
replacement_dict["#{groupId}"]="rx"
replacement_dict["#{name}"]="algorithms"
replacement_dict["#{version}"]="0.1"
my_directory = os.path.dirname(os.path.abspath(__file__))
new_project_dir=sys.argv[1]
utils.replace(my_directory+"/../templates/pom.xml.template", new_project_dir + "/pom.xml", replacement_dict)
