CHROOT_DIR="$(dirname $0)"

if [ ! -e "${CHROOT_DIR}/proc/cpuinfo" ]; then
    echo "Mounting..."
    mount -o bind /proc "${CHROOT_DIR}/proc"
    mount -o bind /dev "${CHROOT_DIR}/dev"
    mount -o bind /dev/pts "${CHROOT_DIR}/dev/pts"
    mount -o bind /dev/shm "${CHROOT_DIR}/dev/shm"
    mount -o bind /sys "${CHROOT_DIR}/sys"
fi

echo "Chrooting..."
chroot "${CHROOT_DIR}"
