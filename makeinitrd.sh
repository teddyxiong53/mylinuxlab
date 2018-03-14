#!/bin/sh 

set -e

ROOR_DIR=`pwd`


rm -f $ROOR_DIR/ramdisk.img.gz
rm -f $ROOR_DIR/ramdisk.img.uboot


RDSIZE=4096
BLKSIZE=1024
BUSYBOX=/home/teddy/work/mylinuxlab/rootfs/bin/busybox

dd if=/dev/zero of=$ROOR_DIR/ramdisk.img bs=${BLKSIZE} count=$RDSIZE

mke2fs -F -m 0 -b $BLKSIZE $ROOR_DIR/ramdisk.img $RDSIZE

mount $ROOR_DIR/ramdisk.img /mnt/initrd -t ext2 -o loop

mkdir /mnt/initrd/bin 
mkdir /mnt/initrd/sys 
mkdir /mnt/initrd/dev 
mkdir /mnt/initrd/proc

cd /mnt/initrd/bin

cp $BUSYBOX ./
ln -s busybox ash
ln -s busybox mount
ln -s busybox echo
ln -s busybox ls
ln -s busybox cat
ln -s busybox ps
cd -

cp -a /dev/console /mnt/initrd/dev
#cp -a /dev/ramdisk /mnt/initrd/dev
cp -a /dev/null /mnt/initrd/dev
mknod -m 660 /mnt/initrd/dev/ram0 b 1 1
ln -s /mnt/initrd/dev/ram0 /mnt/initrd/dev/ramdisk

cp -a /dev/tty1 /mnt/initrd/dev
cp -a /dev/tty2 /mnt/initrd/dev


cd  /mnt/initrd
ln -s bin sbin
cd -

# Create the init file
cat >> /mnt/initrd/linuxrc << EOF
#!/bin/ash
echo
echo "Simple initrd is active"
echo
mount -t proc /proc /proc
mount -t sysfs none /sys
/bin/ash --login
EOF

chmod +x /mnt/initrd/linuxrc



cd /mnt/initrd
find . | cpio -o -H newc | gzip -c > $ROOR_DIR/ramdisk.img
cd -
# Finish up...
umount /mnt/initrd

gzip -9 $ROOR_DIR/ramdisk.img

