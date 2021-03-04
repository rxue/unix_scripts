import sys
import utils
replacement_dict = {}
replacement_dict["#{groupId}"]="rx"
replacement_dict["#{name}"]="algorithms"
replacement_dict["#{version}"]="0.1"
utils.replace(sys.argv[1], sys.argv[2], replacement_dict)
