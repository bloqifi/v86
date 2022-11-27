set -ve

OUTFILE=/tmp/disk
CONTAINER_NAME=alpine-blockchain

dd if=/dev/zero of=$OUTFILE bs=1k count=1M

(
echo o # Create a new empty DOS partition table
echo n # Add a new partition
echo p # Primary partition
echo 1 # Partition number
echo 2048 # First sector
echo   # Last sector (Accept default: varies)
echo a # make bootable
echo w # Write changes
echo q # quit
) | fdisk $OUTFILE

# 1048576 is 2048 (first sector) * 512 (sector size)
mkfs.ext4 -F -E offset=1048576 $OUTFILE

kpartx -a -v $OUTFILE
function finish_kpartx {
    kpartx -d $OUTFILE
}
trap finish_kpartx EXIT

# XXX: Assumes loop0

mount /dev/mapper/loop17p1 /mnt
function finish_mount {
    umount /mnt
    finish_kpartx
}
trap finish_mount EXIT

docker export $CONTAINER_NAME | tar -xvC /mnt/

grub-install --recheck --target=i386-pc --locales= --themes= --fonts= --root-directory /mnt/ /dev/loop0 --skip-fs-probe

cat > /mnt/boot/grub/grub.cfg << 'EOF'
set root='hd0' # XXX: I believe this has no significance, but is required to exist by grub

set timeout_style=menu
set timeout=0

menuentry 'Linux' {
    set root='hd0,msdos1'
    echo      'Loading Linux linux ...'
    linux    /boot/vmlinuz nosplash debug verbose rw root=/dev/sda1 rootfstype=ext4
    echo      'Loading initial ramdisk ...'
    initrd   /boot/initramfs-vanilla
}
EOF

# sync should only necessary if the disk is left mounted, but we'll leave it
# here in case something goes wrong
sync