# Raven Linux

Build entry point for FRDM-IMX95 development. NXP BSP 6.18.20-2.0.0,
Yocto Wrynose, ROS 2 Jazzy. Use a Linux filesystem for the workspace.

```sh
git clone -b develop https://github.com/Swamy-BV/raven-linux.git
./raven-linux/scripts/sync.sh /home/dev/raven/linux
# Read /home/dev/raven/linux/sources/meta-imx/LICENSE.txt before accepting.
ACCEPT_FSL_EULA=1 ./raven-linux/scripts/build.sh /home/dev/raven/linux
```

The main project pins the manifest commit in `release.env`. `raven-frdm.xml`
includes the untouched NXP release XML, pins meta-ros, and follows only
meta-raven's develop branch. Each build writes `resolved-manifest.xml` to
record the exact revisions; use that file for a reproducible release.

Image: `raven-image-ros`; machine: `raven-frdm-imx95`.
The image includes ROS base, C++ talker/listener demos and SSH, without a
desktop. NXP's development configuration allows an empty root password.
Boot firmware and peripheral ownership still use the stock FRDM baseline.
Raven SM, PX4 loading and shared memory are not integrated in this image yet.
Compiling this image does not flash the board.
