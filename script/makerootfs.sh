#!/bin/sh 

#set -e

ROOR_DIR=`pwd`
SD_IMG=$ROOT_DIR/sd.img

if [ ! -f $ROOT_DIR/sd.img ]; then 
    dd if=/dev/zero of=$ROOT_DIR/sd.img bs=1M count=64
    mkfs.ext2 $SD_IMG
fi

if [ ! -d /mymnt/rootfs ]; then
    mkdir -p /mymnt/rootfs
fi

mount -t ext2 $SD_IMG /mymnt/rootfs
cp $ROOR_DIR/rootfs/* /mymnt/rootfs -rf
umount /mymnt/rootfs



