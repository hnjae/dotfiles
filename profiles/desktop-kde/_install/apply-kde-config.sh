#!/bin/sh

set -eu

if ! command -v kwriteconfig6 >/dev/null 2>&1 ||
    ! command -v kreadconfig6 >/dev/null 2>&1; then
    echo "ERR: kwriteconfig6 and kreadconfig6 are required to apply KDE config keys" >&2
    exit 1
fi

# Every `kwriteconfig6` call rewrites the file, which wakes up every watcher
# and makes an unchanged run look like a change. Read the effective value
# first, then write only when it differs.

set_key() {
    _current="$(kreadconfig6 --file "$1" --group "$2" --key "$3" 2>/dev/null || true)"
    if [ "$_current" = "$4" ]; then
        return 0
    fi
    kwriteconfig6 --file "$1" --group "$2" --key "$3" "$4"
}

del_key() {
    _current="$(kreadconfig6 --file "$1" --group "$2" --key "$3" 2>/dev/null || true)"
    if [ "$_current" = "" ]; then
        return 0
    fi
    kwriteconfig6 --file "$1" --group "$2" --key "$3" --delete
}

set_key "bluedevilglobalrc" "General" "launchState" "enable"

del_key "konsolerc" "Notification Messages" "CloseAllEmptyTabs"
del_key "konsolerc" "Notification Messages" "CloseAllTabs"
del_key "konsolerc" "Notification Messages" "CloseSingleTab"

set_key "kdeglobals" "General" "fixed" "ui-monospace,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
set_key "kdeglobals" "General" "font" "system-ui,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
set_key "kdeglobals" "General" "menuFont" "system-ui,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
set_key "kdeglobals" "General" "smallestReadableFont" "system-ui,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
set_key "kdeglobals" "General" "toolBarFont" "system-ui,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

set_key "kdeglobals" "WM" "activeFont" "system-ui,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

set_key "dolphinrc" "CompactMode" "UseSystemFont" "false"
set_key "dolphinrc" "CompactMode" "ViewFont" "system-ui,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

set_key "dolphinrc" "DetailsMode" "PreviewSize" "16"
set_key "dolphinrc" "DetailsMode" "UseSystemFont" "false"
set_key "dolphinrc" "DetailsMode" "ViewFont" "ui-monospace,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

set_key "dolphinrc" "IconsMode" "UseSystemFont" "false"
set_key "dolphinrc" "IconsMode" "ViewFont" "system-ui,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

set_key "dolphinrc" "General" "FilterBar" "true"
set_key "dolphinrc" "General" "ShowFullPath" "true"
set_key "dolphinrc" "General" "ShowStatusBar" "FullWidth"

set_key "dolphinrc" "ContentDisplay" "UseShortRelativeDates" "false"
set_key "dolphinrc" "InformationPanel" "dateFormat" "ShortFormat"

set_key "plasmaparc" "General" "AudioFeedback" "false"
set_key "plasmaparc" "General" "VolumeStep" "4"

# Feedback
set_key "PlasmaUserFeedback" "Global" "FeedbackLevel" "64"
