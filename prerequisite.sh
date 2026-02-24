#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run with sudo: \"sudo $0\""
   exit 1
fi

apps=(
    "gawk"
    "wget"
    "git-core"
    "diffstat"
    "unzip"
    "texinfo"
    "gcc-multilib"
    "build-essential"
    "chrpath"
    "socat"
    "cpio"
    "python3"
    "python3-pip"
    "python3-pexpect"
    "xz-utils"
    "debianutils"
    "iputils-ping"
    "python3-git"
    "python3-jinja2"
    "libegl1-mesa"
    "libsdl1.2-dev"
    "pylint"
    "xterm"
    "zstd"
    "liblz4-tool"
    "minicom"
    "bmaptool"
)

PKG_MANAGER="apt"
INSTALL_CMD="sudo apt-get install -y"

# Iterate through the array
for app in "${apps[@]}"; do
    # Check if the binary exists in the system PATH
    if command -v "$app" &> /dev/null; then
        echo "[SKIP] '$app' is already installed."
    else
        echo "[INSTALLING] '$app'..."
        # Execute the install command
        $INSTALL_CMD "$app"
    fi
done

echo
echo "Creating proprietary directory..."
mkdir -p "$(pwd)/proprietary"

# downloading required packages as per: https://elinux.org/R-Car/Boards/Yocto-Gen3/v5.9.7
echo
echo "To complete the prerequisites, you need to download the following packages from the Renesas website:"
echo "Download evaluation version of proprietary graphics and multimedia drivers from Renesas."
echo "To download Multimedia and Graphics library and related Linux drivers, please use the following link:"
echo "https://www.renesas.com/en/products/automotive-products/automotive-system-chips-socs/r-car-h3-m3-documents-software"
echo "Download two files:"
echo "    R-Car_Gen3_Series_Evaluation_Software_Package_for_Linux-20241223.zip"
echo "    R-Car_Gen3_Series_Evaluation_Software_Package_of_Linux_Drivers-20241223.zip"
echo

echo "--- Installation complete ---"

