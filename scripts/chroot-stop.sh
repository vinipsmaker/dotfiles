#!/usr/bin/env bash

#CHROOT_DIR="$(dirname $0)"
CHROOT_DIR="$1"

if [ -e "${CHROOT_DIR}/proc/cpuinfo" ]; then
    echo "Unmounting..."
    umount "${CHROOT_DIR}/proc"

    # /dev/shm
    # required for chromium and other programs
    umount -l "${CHROOT_DIR}/dev/shm"

    # /dev/dri
    # required for libgl
    umount -l "${CHROOT_DIR}/dev/dri"

    # tty and pts
    # required for xterm and alike
    umount -l "${CHROOT_DIR}/dev/ptmx"
    umount -l "${CHROOT_DIR}/dev/pts"

    # /dev/{null,zero,random,urandom}
    umount -l "${CHROOT_DIR}/dev/null"
    umount -l "${CHROOT_DIR}/dev/zero"
    umount -l "${CHROOT_DIR}/dev/random"
    umount -l "${CHROOT_DIR}/dev/urandom"

    umount -l "${CHROOT_DIR}/dev"

    umount "${CHROOT_DIR}/sys"
    umount "${CHROOT_DIR}/tmp"
fi
