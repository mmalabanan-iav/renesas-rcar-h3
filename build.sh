#!/usr/bin/env bash

BOARD_LIST=("h3ulcb")
TARGET_BOARD=$1
PROPRIETARY_DIR=`pwd`/proprietary
WORK=`pwd`/build_${TARGET_BOARD}
BUILD_TYPE=mmp

POKY_COMMIT=fb91a49387cfb0c8d48303bb3354325ba2a05587
META_OE_COMMIT=a72010b414ee3d73888ac9cb4e310e8f05e13aea
META_RENESAS_COMMIT=5f67430b39b1e3db55433782c9f690b1a7b133a7

GFX_MMP_LIB=R-Car_Gen3_Series_Evaluation_Software_Package_for_Linux-20241223.zip
GFX_MMP_DRIVER=R-Car_Gen3_Series_Evaluation_Software_Package_of_Linux_Drivers-20241223.zip

Usage () {
    echo "Usage: $0 \${TARGET_BOARD_NAME} <build type option>"
    echo "BOARD_NAME list: "
    for i in ${BOARD_LIST[@]}; do echo "  - $i"; done
    echo "build type option"
    echo "  -m: mmp(default)"
    echo "  -g: gfx-only"
    echo "  -b: bsp"
    exit
}

# Check Param.
if ! `IFS=$'\n'; echo "${BOARD_LIST[*]}" | grep -qx "${TARGET_BOARD}"`; then
    Usage
fi
for arg in $@; do
    if [[ "${arg}" == "-m" ]]; then
        BUILD_TYPE=mmp
    elif [[ "${arg}" == "-g" ]]; then
        BUILD_TYPE=gfx-only
    elif [[ "${arg}" == "-b" ]]; then
        BUILD_TYPE=bsp
    fi
done

mkdir -p ${WORK}
cd ${WORK}

# Clone basic Yocto layers in parallel
git clone git://git.yoctoproject.org/poky &
git clone git://git.openembedded.org/meta-openembedded &
git clone https://github.com/renesas-rcar/meta-renesas &

# Wait for all clone operations
wait

# Switch to proper branches/commits
cd ${WORK}/poky
git checkout -b tmp ${POKY_COMMIT}
cd ${WORK}/meta-openembedded
git checkout -b tmp ${META_OE_COMMIT}
cd ${WORK}/meta-renesas
git checkout -b tmp ${META_RENESAS_COMMIT}

# Populate meta-renesas with proprietary software packages
WORK_PROP_DIR=${WORK}/proprietary
mkdir -p ${WORK_PROP_DIR}
unzip -qo ${PROPRIETARY_DIR}/${GFX_MMP_LIB} -d ${WORK_PROP_DIR}
unzip -qo ${PROPRIETARY_DIR}/${GFX_MMP_DRIVER} -d ${WORK_PROP_DIR}
cd ${WORK}/meta-renesas
sh meta-rcar-gen3/docs/sample/copyscript/copy_proprietary_softwares.sh -f ${WORK_PROP_DIR}

cd ${WORK}
source poky/oe-init-build-env ${WORK}/build_${BUILD_TYPE}
cp ${WORK}/meta-renesas/meta-rcar-gen3/docs/sample/conf/${TARGET_BOARD}/poky-gcc/${BUILD_TYPE}/*.conf ./conf/
cp conf/local-wayland.conf conf/local.conf
echo 'IMAGE_INSTALL:append = " kernel-devicetree"' >> conf/local.conf

bitbake core-image-weston