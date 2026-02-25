# Renesas R-Car Starter Kit Premier

This repository will contain scripts that will help building and running Yocto on the Renesas R-Car Starter Kit Premier H3e WS3.0 (H3e-2G, RTP8J779M1ASKB0SK0SA003).

## Scripts

| **Filename** | **Description** |
| --- | --- |
| `prerequisite.sh` | Installs host dependencies using `apt` and prepares `proprietary/` for required ZIPs. |
| `build.sh` | Clones Yocto layers (`poky`, `meta-openembedded`, `meta-renesas`), configures the build, and runs `bitbake`. |
| `serial.sh` | Opens a minicom session and saves logs under `log/`. |

## U-Boot command

When booting the R-Car, it will prompt the user to interrupt the boot sequence by pressing any key. There's a 3 second count down. To get into the U-boot terminal, you must interrupt the boot process.

Below are set of commands to set up U-Boot to boot from SD card.

- `setenv bootargs_sd0 'rw root=/dev/mmcblk1p1 rootwait console=ttySC0,115200'`
- `setenv bootcmd_sd0 'setenv bootargs ${bootargs_sd0}; ext2load mmc 0:1 0x48080000 /boot/Image; ext2load mmc 0:1 0x48000000 /boot/r8a779m1-ulcb.dtb; booti 0x48080000 - 0x48000000'`
- `setenv bootcmd 'run bootcmd_sd0'`
- `saveenv`
- optional: `printenv` - to verify the variables
- `boot`

**NOTE**: Use `printenv` to check the env variables.

## Login Info

| **username** | **password** |
| --- | --- |
| root | |

## Links

- [https://elinux.org/R-Car/Boards/Yocto-Gen3/v5.9.7](https://elinux.org/R-Car/Boards/Yocto-Gen3/v5.9.7)
- [https://elinux.org/R-Car/Boards/H3SK](https://elinux.org/R-Car/Boards/H3SK)
- [https://elinux.org/R-Car/Boards/H3SK#Hardware](https://elinux.org/R-Car/Boards/H3SK#Hardware)
- [https://elinux.org/R-Car/Boards/H3SK#H3SK_with_SINGLE_RANKED_DDR](https://elinux.org/R-Car/Boards/H3SK#H3SK_with_SINGLE_RANKED_DDR)

**Note**: The last link is not necessarily needed since a newer Yocto (>3.x.x) is used.

**Note**: It took over 6 hours to compile the BSP on a Mini PC with Intel N97 at 3.6GHz with 12 GB of RAM.
