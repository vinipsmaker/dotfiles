CHROOT_DIR="$(dirname $0)"

if [ ! -e "${CHROOT_DIR}/proc/cpuinfo" ]; then
    echo "Mounting..."
    mount -o bind /proc "${CHROOT_DIR}/proc"

    # /dev/shm
    # required for chromium and other programs
    mkdir "${CHROOT_DIR}/dev/shm"
    mount -t tmpfs none "${CHROOT_DIR}/dev/shm"

    # tty and pts
    # required for xterm and alike
    > "${CHROOT_DIR}/dev/ptmx"
    mount -o bind /dev/ptmx "${CHROOT_DIR}/dev/ptmx"
    mkdir "${CHROOT_DIR}/dev/pts"
    mount -t devpts none "${CHROOT_DIR}/dev/pts"

    # /dev/{null,zero,random,urandom}
    > "${CHROOT_DIR}/dev/null"
    mount -o bind /dev/null "${CHROOT_DIR}/dev/null"
    > "${CHROOT_DIR}/dev/zero"
    mount -o bind /dev/zero "${CHROOT_DIR}/dev/zero"
    > "${CHROOT_DIR}/dev/random"
    mount -o bind /dev/random "${CHROOT_DIR}/dev/random"
    > "${CHROOT_DIR}/dev/urandom"
    mount -o bind /dev/urandom "${CHROOT_DIR}/dev/urandom"

    mount -o bind /sys "${CHROOT_DIR}/sys"
    mount -o nosuid,nodev -t tmpfs none "${CHROOT_DIR}/tmp"
fi

echo "Chrooting..."
chroot "${CHROOT_DIR}"
