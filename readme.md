# Renesas R-Car Starter Kit Premier

This repository will contain scripts that will help building and running Yocto on the Renesas R-Car Starter Kit Premier H3e WS3.0 (H3e-2G, RTP8J779M1ASKB0SK0SA003).

## Scripts

| **Filename** | **Description** |
| --- | --- |
| `prerequisite.sh` | Installs host dependencies using `apt` and prepares `proprietary/` for required ZIPs. |
| `build.sh` | Clones Yocto layers (`poky`, `meta-openembedded`, `meta-renesas`), configures the build, and runs `bitbake`. |
| `serial.sh` | Opens a minicom session and saves logs under `log/`. |

## Links

- [https://elinux.org/R-Car/Boards/Yocto-Gen3/v5.9.7](https://elinux.org/R-Car/Boards/Yocto-Gen3/v5.9.7)
- [https://elinux.org/R-Car/Boards/H3SK](https://elinux.org/R-Car/Boards/H3SK)
- [https://elinux.org/R-Car/Boards/H3SK#Hardware](https://elinux.org/R-Car/Boards/H3SK#Hardware)
- [https://elinux.org/R-Car/Boards/H3SK#H3SK_with_SINGLE_RANKED_DDR](https://elinux.org/R-Car/Boards/H3SK#H3SK_with_SINGLE_RANKED_DDR)

**Note**: The last link is not necessarily needed since a newer Yocto (>3.x.x) is used.
