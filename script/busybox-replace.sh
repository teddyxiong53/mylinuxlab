#!/bin/sh

SD_IMG=$ROOT_DIR/sd.img
echo $ROOT_DIR
mount -t ext2 $SD_IMG /mymnt/rootfs
cp $BUSYBOX_DIR/busybox /mymnt/rootfs/bin -f
umount /mymnt/rootfs