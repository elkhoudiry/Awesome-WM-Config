#!/bin/sh
# shellcheck disable=SC3043
# shellcheck disable=SC2155

get_device_info() {
    local STATUS="$(nmcli device show "$1" | awk '/STATE/{print $2}')"

    if [ -n "$STATUS" ] && [ "$STATUS" -eq "100" ]; then
        local RX="$(cat /sys/class/net/"$1"/statistics/rx_bytes)"
        local TX="$(cat /sys/class/net/"$1"/statistics/tx_bytes)"
        echo "connected $RX $TX"
    else
        echo "disconnected"
    fi

    echo " || "
}

if [ $# = 0 ]; then
    echo "Please pass argumensts -d \"<device1> <device2>...\" -f \"<device1> <device2>..\""
    exit 2
fi

while getopts ":d:" opt; do
    case $opt in
    d)
        DEVICES=$OPTARG
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    esac
done

for DEVICE in $DEVICES; do
    get_device_info "$DEVICE"
done
