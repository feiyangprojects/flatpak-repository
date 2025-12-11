#!/usr/bin/bash -e
trap 'test "$ADB_SERVER_STATUS" != "" && adb kill-server' EXIT
ADB_SERVER_STATUS="$(adb start-server 2>&1)"
ADB_DEVICE_STATUS="$(timeout 5 adb wait-for-device 2>&1)" || ADB_DEVICE_EXITCODE="$?"
if [ "$ADB_DEVICE_STATUS" == 'error: more than one device/emulator' ]; then
    if [[ ! "$@" =~ (^| )-(s|d|e) && ! "$@" =~ --(serial|select-usb|select-tcpip) ]]; then
      zenity --error --text "More than one Android device detected!\nSelect a device via -s (--serial), -d (--select-usb) or -e (--select-tcpip)."; exit 1
    fi
elif [ "$ADB_DEVICE_EXITCODE" != '' ]; then
    zenity --error --text "No Android device detected!\nHave you connected your device and enabled USB debugging?"
    exit 1
fi
scrcpy $@
