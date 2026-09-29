#!/usr/bin/env bash
set -eo pipefail
project=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
source "$project/release.env"
workspace=${1:?Usage: build.sh /absolute/path/to/workspace [bitbake arguments]}
shift
cd "$workspace"
if [[ ${ACCEPT_FSL_EULA:-} != 1 ]]; then
    echo "Read sources/meta-imx/LICENSE.txt and explicitly set ACCEPT_FSL_EULA=1 to build."
    exit 1
fi
# NXP scripts expect unset variables; enable nounset only after sourcing them.
EULA=1 MACHINE=imx95-15x15-lpddr4x-frdm DISTRO="$DISTRO" source ./imx-setup-release.sh -b build-raven
cat >> conf/bblayers.conf <<'EOF'
BBLAYERS += "${BSPDIR}/sources/meta-ros/meta-ros-common"
BBLAYERS += "${BSPDIR}/sources/meta-ros/meta-ros2"
BBLAYERS += "${BSPDIR}/sources/meta-ros/meta-ros2-jazzy"
BBLAYERS += "${BSPDIR}/sources/meta-raven"
EOF
cat >> conf/local.conf <<EOF
MACHINE = "$MACHINE"
BB_NUMBER_THREADS = "8"
PARALLEL_MAKE = "-j 8"
EOF
set -u
# Freeze every source revision, including the current meta-raven develop head.
repo manifest -r -o "$PWD/resolved-manifest.xml"
if (( $# )); then
    bitbake "$@"
else
    bitbake "$IMAGE"
fi
