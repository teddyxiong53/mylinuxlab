.PHONY: help uboot uboot-menuconfig uboot-defconfig \
	kernel kernel-menuconfig kernel-defconfig \
	busybox rootfs boot clean pflash initrd boot-kernel


ARCH=arm
CROSS_COMPILE=arm-linux-gnueabihf-
#define ram addr
KRN_ADDR=0x60003000

#define dir
ROOT_DIR:=$(shell pwd)

export ARCH CROSS_COMPILE

default: help

help:
	cat readme.txt
	@echo ""
    
uboot-menuconfig:
	make -C uboot/u-boot menuconfig

uboot-defconfig:
	make -C uboot/u-boot vexpress_ca9x4_defconfig
uboot:
	make -C uboot/u-boot -j4


kernel-menuconfig:
	make -C kernel/linux-stable menuconfig
kernel-defconfig:
	make -C kernel/linux-stable vexpress_defconfig
kernel:
	make -C kernel/linux-stable uImage LOADADDR=$(KRN_ADDR) -j4


busybox-menuconfig:
	make -C busybox/busybox-1.27.2 menuconfig

busybox-defconfig:
	make -C busybox/busybox-1.27.2 defconfig
busybox:
	make -C busybox/busybox-1.27.2 -j4

rootfs:
	#make -C busybox/busybox-1.27.2 install CONFIG_PREFIX=$(ROOT_DIR)/rootfs
	sudo cp $(ROOT_DIR)/rootfs_origin/* $(ROOT_DIR)/rootfs -rf

KERNEL_IMAGE=$(ROOT_DIR)/kernel/linux-stable/arch/arm/boot/uImage
PFLASH_IMG=$(ROOT_DIR)/pflash.img
PFLASH_BS=512
PFLASH_BASE = 0x40000000
PFLASH_SIZE = 64
PFLASH_SEC_COUNT:=128
ROOT_IMAGE=$(ROOT_DIR)/ramdisk.img.uboot
DTB_IMAGE=$(ROOT_DIR)/kernel/linux-stable/arch/arm/boot/dts/vexpress-v2p-ca9.dtb
pflash:
	rm -rf $(PFLASH_IMG)
	dd if=/dev/zero of=$(PFLASH_IMG) status=none bs=${PFLASH_BS}K count=$(PFLASH_SEC_COUNT)
	dd if=$(KERNEL_IMAGE) of=$(PFLASH_IMG) status=none conv=notrunc bs=${PFLASH_BS}K
	#seek=$((KRN_SIZE * 1024 / PFLASH_BS))=5*1024/512=10
	dd if=$(ROOT_IMAGE) of=$(PFLASH_IMG) status=none conv=notrunc seek=10 bs=${PFLASH_BS}K
	#seek=$(((KRN_SIZE+RDK_SIZE) * 1024 / PFLASH_BS))=(5+4)*1024/512=18
	dd if=$(DTB_IMAGE) of=$(PFLASH_IMG) status=none conv=notrunc seek=18 bs=${PFLASH_BS}K

initrd:
	#cd $(ROOT_DIR)/kernel/linux-stable; \
	#$(ROOT_DIR)/kernel/linux-stable/scripts/gen_initramfs_list.sh -o $(ROOT_DIR)/ramdisk.img.gz $(ROOT_DIR)/rootfs; \
	#cd -
	$(ROOT_DIR)/makeinitrd.sh 
	mkimage -A arm -T ramdisk -C none -n 'Test Ramdisk Image' -d $(ROOT_DIR)/ramdisk.img.gz $(ROOT_DIR)/ramdisk.img.uboot
boot:
	qemu-system-arm -M vexpress-a9 -m 128M -net nic,model=lan9118 -net tap \
	-smp 1 -kernel ./uboot/u-boot/u-boot -no-reboot \
	-pflash ./pflash.img -nographic 

boot-kernel:
	qemu-system-arm -M vexpress-a9 -m 128M -net nic,model=lan9118 -net tap \
	-smp 1 -kernel $(ROOT_DIR)/kernel/linux-stable/arch/arm/boot/zImage -no-reboot \
	 -nographic  -initrd $(ROOT_DIR)/ramdisk.img.gz

clean:
	@echo "clean"