# io-node-os

The Linux image for IO-Node, a small remote I/O module built on a BeagleBone Black. Instead of flashing a stock Debian SD card, this repo builds a minimal image from source, first with Buildroot and then with Yocto, the way an industrial device vendor would.

Part of [embedded-linux-industrial](https://github.com/R0n1z3/embedded-linux-industrial), a hands-on move from industrial controls engineering into embedded Linux. The [roadmap](https://github.com/R0n1z3/embedded-linux-industrial/blob/main/embedded-linux-roadmap.md) there has the full plan.

## What the image will do

- Boot on the BeagleBone Black, and in QEMU for testing without hardware
- Set its own hostname
- Start the IO-Node services at boot with systemd
- Allow SSH login with keys only, no passwords
- Run with a read-only root filesystem, so losing power can't corrupt it. Industrial devices lose power without warning all the time.
- Later, run a PREEMPT_RT kernel for the real-time latency measurements

The image has no application code of its own. It pulls in the other repos as packages, each pinned to a tagged release: the IO-Node kernel driver and Modbus slave daemon from `io-node`, and the Modbus library they use.

## Status

| Milestone | Status |
|---|---|
| Stock Buildroot image boots in QEMU | Next |
| Stock Buildroot image boots on the BeagleBone Black | Waiting on hardware |
| External tree with custom defconfigs: hostname, SSH keys only, read-only rootfs | Planned |
| Own binary packaged and started by systemd | Planned |
| The same image rebuilt with Yocto | Planned |
| Image size, boot time, and each customization documented here | Planned |
| PREEMPT_RT kernel | Planned |

## Planned layout

```
io-node-os/
├── buildroot-external/     BR2_EXTERNAL tree
│   ├── external.desc       names the tree
│   ├── external.mk         pulls in the package .mk files
│   ├── Config.in           adds the packages to menuconfig
│   ├── configs/            io_node_qemu_defconfig, io_node_bbb_defconfig
│   ├── board/io-node/      rootfs overlay, post-build scripts, systemd units
│   └── package/            one package per repo (driver, Modbus slave, ...)
└── meta-io-node/           Yocto layer, once the Buildroot image works
```

Buildroot's own source isn't in this repo. A `BR2_EXTERNAL` tree keeps every customization outside Buildroot's source, so upgrading Buildroot doesn't mean re-applying edits to its files.

## Building

- **Host:** x86-64 Ubuntu
- **Buildroot:** 2026.02.x (long-term support branch)

Buildroot and the build output sit next to this repo, not inside it:

```
<workspace>/
├── io-node-os/        this repo
├── buildroot/         Buildroot source
└── br-output/qemu/    build output (make O=...)
```

The first milestone is a stock QEMU image with no customizations. Run this from `<workspace>`:

```sh
git clone https://gitlab.com/buildroot.org/buildroot.git
cd buildroot
git checkout 2026.02.x
make O=../br-output/qemu qemu_arm_vexpress_defconfig
make O=../br-output/qemu
../br-output/qemu/images/start-qemu.sh
```

Log in as `root` with no password. The QEMU command is also in `buildroot/board/qemu/arm-vexpress/readme.txt`.

Once the external tree exists, the stock defconfig is replaced by this repo's own:

```sh
make O=../br-output/qemu BR2_EXTERNAL=../io-node-os/buildroot-external io_node_qemu_defconfig
```

## About this project

The code and configs here are written by hand to learn how an embedded Linux image is put together. [CLAUDE.md](CLAUDE.md) holds the instructions for the AI mentor used alongside it, which reviews and explains but doesn't write the project's code.
