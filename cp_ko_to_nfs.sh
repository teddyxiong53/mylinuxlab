#!/bin/sh 

#set -e

ROOR_DIR=`pwd`
cd $ROOR_DIR/kernel/linux-stable/samples
#find -name "*.ko"
find -name "*.ko" -exec cp {} $ROOR_DIR/nfs \;
cd -




