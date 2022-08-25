#!/usr/bin/sh

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

BLUEZ_PATH=/org/bluez/hci0/dev_A8_91_3D_1E_94_D1
BLUEZ_PATH=/org/bluez/hci0/dev_A8_91_3D_1E_94_D1/sep2/fd2
METHOD=org.bluez.MediaControl1.VolumeUp
METHOD=org.freedesktop.DBus.Properties.Get
dbus-send \
	--print-reply \
	--system \
	--dest=org.bluez \
	$BLUEZ_PATH \
	$METHOD \
	string:org.bluez.MediaTransport1 string:Volume
METHOD=org.freedesktop.DBus.Properties.Set
dbus-send \
	--print-reply \
	--system \
	--dest=org.bluez \
	$BLUEZ_PATH \
	$METHOD \
	string:org.bluez.MediaTransport1 string:Volume variant:uint16:65
