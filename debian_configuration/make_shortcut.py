import sys
# Reference: https://valadoc.org/glib-2.0/GLib.Variant.html
from gi.repository import Gio
from gi.repository import GLib
#from ast import literal_eval
media_keys_schema = 'org.gnome.settings-daemon.plugins.media-keys' 
custom_keybinding_schema = media_keys_schema + '.custom-keybinding'
def _get_new_custom_keybinding_path(name:str):
  custom_name = name.replace(' ', '').lower()
  return "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/" + custom_name + '/'

def _add_new_custom_keybinding_path(new_custom_keybinding_path:str):
  global media_keys_schema
  media_keys_settings = Gio.Settings.new(media_keys_schema)
  keyCustomKeyBindings = 'custom-keybindings'
  customKeyBindings = media_keys_settings.get_value(keyCustomKeyBindings)
  paths = customKeyBindings.get_strv()
  paths.append(new_custom_keybinding_path)
  media_keys_settings.set_value(keyCustomKeyBindings, GLib.Variant.new_strv(paths))
  
def make_shortcut(name:str,command:str,shortcut:str):
  global media_keys_schema 
  new_custom_keybinding_path = _get_new_custom_keybinding_path(name)
  _add_new_custom_keybinding_path(new_custom_keybinding_path)
  global custom_keybinding_schema
  custom_keybinding_settings = Gio.Settings.new_with_path(custom_keybinding_schema, new_custom_keybinding_path)
  custom_keybinding_settings.set_string('name', name)
  custom_keybinding_settings.set_string('command', command)
  custom_keybinding_settings.set_string('binding', shortcut)
  custom_keybinding_settings.apply()
  Gio.Settings.sync()
  

new_operation_name = sys.argv[1]
command = sys.argv[2]
shortcut = sys.argv[3]
make_shortcut(new_operation_name, command, shortcut)
