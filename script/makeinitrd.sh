#!/bin/sh 

#set -e

ROOR_DIR=`pwd`


rm -f $ROOR_DIR/ramdisk.img
rm -f $ROOR_DIR/ramdisk.img.uboot

umount -f /mnt/initrd

RDSIZE=4096
BLKSIZE=1024
ROOTFS=/home/teddy/work/mylinuxlab/rootfs

dd if=/dev/zero of=$ROOR_DIR/ramdisk.img bs=${BLKSIZE} count=$RDSIZE

mke2fs -F -m 0 -b $BLKSIZE $ROOR_DIR/ramdisk.img $RDSIZE

mount $ROOR_DIR/ramdisk.img /mnt/initrd -t ext2 -o loop

cd /mnt/initrd;cp -rf $ROOTFS/* ./; chmod 666 ./dev/ram0; chmod 777 ./bin/*; chmod 777 ./init; cd -

read tmp

cd /mnt/initrd
find . | cpio -o -H newc | gzip -c > $ROOR_DIR/ramdisk.img
cd -
# Finish up...
umount /mnt/initrd

#gzip -9 $ROOR_DIR/ramdisk.img

