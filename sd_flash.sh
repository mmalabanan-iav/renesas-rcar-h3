#!/usr/bin/env bash

set -euo pipefail

DEFAULT_IMAGE="build_h3ulcb/build_mmp/tmp/deploy/images/h3ulcb/core-image-weston-h3ulcb.wic.xz"
BMAP_FILE="build_h3ulcb/build_mmp/tmp/deploy/images/h3ulcb/core-image-weston-h3ulcb.wic.bmap"
DEVICE=""

usage() {
  local code="${1:-1}"
  cat <<EOF
Usage: sudo $0 -d <device>

Flash default image using bmaptool:
  ${DEFAULT_IMAGE}

Options:
  -d   Target whole-disk device (required), e.g. /dev/sda
  -h   Show this help message
EOF
  exit "${code}"
}

while getopts ":d:h" opt; do
  case "${opt}" in
    d) DEVICE="${OPTARG}" ;;
    h) usage 0 ;;
    *) usage 1 ;;
  esac
done

if [[ -z "${DEVICE}" ]]; then
  echo "ERROR: -d <device> is required."
  usage 1
fi

if [[ "${EUID}" -ne 0 ]]; then
  echo "ERROR: This script must be run with sudo/root."
  exit 1
fi

if [[ ! -b "${DEVICE}" ]]; then
  echo "ERROR: Device '${DEVICE}' does not exist or is not a block device."
  exit 1
fi

# Reject partition devices; require a whole disk (e.g. /dev/sda, /dev/mmcblk0).
if lsblk -ndo TYPE "${DEVICE}" 2>/dev/null | grep -qx "part"; then
  echo "ERROR: '${DEVICE}' is a partition. Provide a whole-disk device (e.g. /dev/sda)."
  exit 1
fi

if [[ ! -f "${DEFAULT_IMAGE}" ]]; then
  echo "ERROR: Image file not found: ${DEFAULT_IMAGE}"
  exit 1
fi

if [[ ! -f "${BMAP_FILE}" ]]; then
  echo "ERROR: Bmap file not found: ${BMAP_FILE}"
  exit 1
fi

echo "Flashing image:"
echo "  Image:  ${DEFAULT_IMAGE}"
echo "  Bmap:   ${BMAP_FILE}"
echo "  Device: ${DEVICE}"

bmaptool copy "${DEFAULT_IMAGE}" "${DEVICE}"

echo "Flash complete."
