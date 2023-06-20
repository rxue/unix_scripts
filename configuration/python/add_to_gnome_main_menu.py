import utils
import sys
def add_to_gnome_main_menu(name:str,executable_file_path:str,icon_path:str):
  replacement_list={"${program_name}":name, "${executable_file_path}":executable_file_path, "${icon_path}":icon_path}
  utils.replace("sudoer/templates/app.desktop.template", "/usr/share/applications/" + name + ".desktop",replacement_list) 
if __name__ == "__main__":
  add_to_gnome_main_menu(sys.argv[1], sys.argv[2], sys.argv[3])
