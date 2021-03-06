#!/bin/bash

# bootstrappr.sh
# A script to install packages found in a packages folder in the same directory
# as this script to a selected volume

if [[ $EUID != 0 ]] ; then
    echo "bootstrappr: Please run this as root, or via sudo."
    exit -1
fi

INDEX=0
OLDIFS=$IFS
IFS=$'\n'

echo "*** Welcome to bootstrappr! ***"
echo "Available volumes:"
for VOL in $(/bin/ls -1 /Volumes) ; do
    if [[ "${VOL}" != "OS X Base System" ]] ; then
        let INDEX=${INDEX}+1
        VOLUMES[${INDEX}]=${VOL}
        echo "    ${INDEX}  ${VOL}"
    fi
done
read -p "Install to volume # (1-${INDEX}): " SELECTEDINDEX

SELECTEDVOLUME=${VOLUMES[${SELECTEDINDEX}]}

if [[ "${SELECTEDVOLUME}" == "" ]]; then
    exit 0
fi

echo "Installing packages to /Volumes/${SELECTEDVOLUME}..."

# dirname and basename not available in Recovery boot
# so we get to use Bash pattern matching
BASENAME=${0##*/}
THISDIR=${0%$BASENAME}
PACKAGESDIR="${THISDIR}packages"

for PKG in $(/bin/ls -1 "${PACKAGESDIR}"/*.pkg) ; do
    /usr/sbin/installer -pkg "${PKG}" -target "/Volumes/${SELECTEDVOLUME}"
done