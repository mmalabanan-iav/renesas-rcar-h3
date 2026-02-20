#!/usr/bin/env bash

# Configuration
LOG_DIR="log"
BASENAME_LOG="RTP8J779M1ASKB0SK0SA003_log"
DEVICE=""
BAUD="115200"

usage() {
	echo "Usage: $0 -d <device> [-b <baud>]"
	echo "-d	Path to serial device (REQUIRED, e.g. /dev/ttyUSB0)"
	echo "-b	Baud rate (default: 115200)"
	exit 1
}


while getopts "d:b:h" opt; do
	case $opt in
		d) DEVICE="$OPTARG" ;;
		b) BAUD="$OPTARG" ;;
		h) usage ;;
		*) usage ;;
	esac
done


if [ ! -d "$LOG_DIR" ]; then
	echo "Creating '$LOG_DIR' directory..."
	mkdir -p "$LOG_DIR"
fi


LAST_NUM=$(ls "$LOG_DIR"/${BASENAME_LOG}_*.log 2>/dev/null | grep -oP '(?<=_)\d+(?=\.log)' | sort -n | tail -1)

if [ -z "$LAST_NUM" ]; then
	NEXT_NUM=1
else
	NEXT_NUM=$(($LAST_NUM + 1))
fi

NEW_LOG="$LOG_DIR/${BASENAME_LOG}_${NEXT_NUM}.log"


if [ ! -e "$DEVICE" ]; then
	echo "ERROR: Device '$DEVICE' not found on this machine."
	exit 1
fi

echo "--- Serial Session Started ---"
echo "Target:  $DEVICE"
echo "Baud:    $BAUD"
echo "Logging: $NEW_LOG"
echo "------------------------------"


minicom --baudrate="$BAUD" --device="$DEVICE" --capturefile="$NEW_LOG"

