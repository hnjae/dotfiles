#!/bin/sh

set -eu

if ! command -v kwriteconfig6 >/dev/null 2>&1; then
    echo "ERR: kwriteconfig6 is required to apply KDE config keys" >&2
    exit 1
fi

kwriteconfig6 --file "bluedevilglobalrc" --group "General" --key "launchState" "enable"

kwriteconfig6 --file "dolphinrc" --group "CompactMode" --key "UseSystemFont" "false"
kwriteconfig6 --file "dolphinrc" --group "CompactMode" --key "ViewFont" "Monospace,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

kwriteconfig6 --file "dolphinrc" --group "ContentDisplay" --key "UseShortRelativeDates" "false"

kwriteconfig6 --file "dolphinrc" --group "DetailsMode" --key "PreviewSize" "16"
kwriteconfig6 --file "dolphinrc" --group "DetailsMode" --key "UseSystemFont" "false"
kwriteconfig6 --file "dolphinrc" --group "DetailsMode" --key "ViewFont" "Monospace,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

kwriteconfig6 --file "dolphinrc" --group "General" --key "FilterBar" "true"
kwriteconfig6 --file "dolphinrc" --group "General" --key "ShowFullPath" "true"
kwriteconfig6 --file "dolphinrc" --group "General" --key "ShowStatusBar" "FullWidth"

kwriteconfig6 --file "dolphinrc" --group "IconsMode" --key "UseSystemFont" "false"
kwriteconfig6 --file "dolphinrc" --group "IconsMode" --key "ViewFont" "Monospace,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

kwriteconfig6 --file "dolphinrc" --group "InformationPanel" --key "dateFormat" "ShortFormat"

kwriteconfig6 --file "plasmaparc" --group "General" --key "AudioFeedback" "false"
kwriteconfig6 --file "plasmaparc" --group "General" --key "VolumeStep" "4"
