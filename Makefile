.PHONY: help uboot uboot-menuconfig uboot-defconfig \
	kernel kernel-menuconfig kernel-defconfig \
	busybox  boot clean  boot-uboot \
	ramfs busybox-install kernel-debug kernel-modules \
	user-modules user-modules-clean

ARCH=arm
CROSS_COMPILE=arm-linux-gnueabihf-
#define ram addr
KRN_ADDR=0x60003000

#define dir
ROOT_DIR:=$(shell pwd)
KERNEL_DIR:=$(ROOT_DIR)/kernel/linux-stable
UBOOT_DIR:=$(ROOT_DIR)/uboot/u-boot
BUSYBOX_DIR:=$(ROOT_DIR)/busybox/busybox-1.27.2
USER_MODULE_DIR:=$(ROOT_DIR)/nfs/mod

export ARCH CROSS_COMPILE ROOT_DIR KERNEL_DIR USER_MODULE_DIR

default: help

help:
	cat help.txt
	@echo ""
    
uboot-menuconfig:
	make -C $(UBOOT_DIR) menuconfig

uboot-defconfig:
	make -C $(UBOOT_DIR)  vexpress_ca9x4_defconfig
uboot:
	make -C $(UBOOT_DIR)  -j4


kernel-menuconfig:
	make -C $(KERNEL_DIR) menuconfig
kernel-defconfig:
	make -C $(KERNEL_DIR) vexpress_defconfig
kernel:
	make -C $(KERNEL_DIR) uImage LOADADDR=$(KRN_ADDR) -j4

kernel-debug:
	qemu-system-arm -M vexpress-a9  -s -S \
	-smp 1 -kernel $(KERNEL_DIR)/arch/arm/boot/zImage  \
	-nographic  -initrd $(ROOT_DIR)/ramfs.gz -dtb $(KERNEL_DIR)/arch/arm/boot/dts/vexpress-v2p-ca9.dtb 

kernel-modules:
	make -C $(KERNEL_DIR) modules -j4

user-modules:
	make -C $(USER_MODULE_DIR) modules
user-modules-clean:
	make -C $(USER_MODULE_DIR) clean
busybox-menuconfig:
	make -C $(BUSYBOX_DIR) menuconfig

busybox-defconfig:
	make -C $(BUSYBOX_DIR) defconfig
busybox:
	make -C $(BUSYBOX_DIR) -j4
busybox-install:
	make -C $(BUSYBOX_DIR) install CONFIG_PREFIX=$(ROOT_DIR)/ramfs

	
ramfs:
	cd $(KERNEL_DIR); ./scripts/gen_initramfs_list.sh -o $(ROOT_DIR)/ramfs.gz $(ROOT_DIR)/ramfs;cd -



boot-uboot:
	qemu-system-arm -M vexpress-a9 -m 128M -net nic,model=lan9118 -net tap \
	-smp 1 -kernel $(UBOOT_DIR)/u-boot -no-reboot \
	-nographic 


boot:
	$(ROOT_DIR)/ifconfig_tap0.sh &
	qemu-system-arm -M vexpress-a9 -net nic,model=lan9118 -net tap \
	-smp 1 -kernel $(KERNEL_DIR)/arch/arm/boot/zImage  \
	-nographic  -initrd $(ROOT_DIR)/ramfs.gz -dtb $(KERNEL_DIR)/arch/arm/boot/dts/vexpress-v2p-ca9.dtb 
	



clean:
	@echo "clean"