# Repository Guidelines

## Project Structure & Module Organization
This repo is a small set of build and utility scripts for the Renesas R-Car Starter Kit Premier H3e.
- `build.sh` clones Yocto layers (`poky`, `meta-openembedded`, `meta-renesas`), configures the build, and runs `bitbake`.
- `prerequisite.sh` installs host dependencies using `apt` and prepares `proprietary/` for required ZIPs.
- `serial.sh` opens a minicom session and saves logs under `log/`.
- `proprietary/` contains Renesas evaluation ZIPs required by the build.
- `build_<board>/` (e.g., `build_h3ulcb/`) is generated output and should be treated as build artifacts.

## Build, Test, and Development Commands
- `sudo ./prerequisite.sh` installs all build prerequisites and creates `proprietary/`.
- `./build.sh h3ulcb -m` builds the full multimedia image (default). Use `-g` for gfx-only or `-b` for BSP.
- `./serial.sh -d /dev/ttyUSB0 -b 115200` starts a serial console and logs to `log/`.

## Coding Style & Naming Conventions
Scripts are bash with `#!/usr/bin/env bash`. Keep indentation consistent (2–4 spaces), avoid tabs, and keep filenames lowercase with `.sh`. When adding new scripts, follow the existing pattern of clear variable names and `usage()` helpers.

## Testing Guidelines
No automated test framework is defined. Validate changes by running the relevant script end-to-end. For example, verify `build.sh` completes `bitbake core-image-weston` for the target board.

## Environment Assumptions
The build environment assumes Ubuntu 22.04 (per elinux.org guidance). Plan for at least 100 GB of free disk space for Yocto/BSP builds. An active internet connection is required for `prerequisite.sh` and `build.sh` because they clone git repositories. Build-only workflows are supported; only `serial.sh` requires the H3e hardware and a serial device.

## Commit & Pull Request Guidelines
The current history uses short, sentence-case subjects (e.g., "created script for easy serial connection"). Keep commits concise and action-oriented. PRs should include a brief description, verification steps (commands plus expected results), and logs or screenshots for build or serial workflow changes.

## Security & Configuration Tips
`prerequisite.sh` runs with `sudo` and installs packages system-wide; review it before running on shared hosts. The required Renesas ZIPs are already committed under `proprietary/` and should be kept with the exact filenames referenced in `build.sh`.
