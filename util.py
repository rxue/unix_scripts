import sys
from ast import literal_eval
customSettingsRawValue = sys.argv[1]
customSettings = []
if customSettingsRawValue != "@as []":
  customSettings = literal_eval(customSettingsRawValue)
customName = sys.argv[2]
newCustomSetting="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/" + customName
customSettings.append(newCustomSetting)
print(customSettings)
