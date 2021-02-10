import sys
# Reference: https://valadoc.org/glib-2.0/GLib.Variant.html
from gi.repository import Gio
from gi.repository import GLib
#from ast import literal_eval
def _get_custom_path(name:str):
  custom_name = name.replace(' ', '')
  return "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/" + custom_name

def make_shortcut(name:str):
  mediaKeys = Gio.Settings.new('org.gnome.settings-daemon.plugins.media-keys')
  keyCustomKeyBindings = 'custom-keybindings'
  customKeyBindings = mediaKeys.get_value(keyCustomKeyBindings)
  paths = customKeyBindings.get_strv()
  newCustomSettingPath = _get_custom_path(name)
  paths.append(newCustomSettingPath)
  print("DEBUG:",paths)
  mediaKeys.set_value(keyCustomKeyBindings, GLib.Variant.new_strv(paths))

new_operation_name = sys.argv[1]
make_shortcut(new_operation_name)
