CHROOT_DIR="$(dirname $0)"

if [ -e "${CHROOT_DIR}/proc/cpuinfo" ]; then
    echo "Unmounting..."
    umount "${CHROOT_DIR}/proc"
    umount "${CHROOT_DIR}/dev/pts"
    umount "${CHROOT_DIR}/dev/shm"
    umount "${CHROOT_DIR}/dev"
    umount "${CHROOT_DIR}/sys"
fi
