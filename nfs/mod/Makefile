obj-m += hello.o


all: modules

modules:
	make -C $(KERNEL_DIR) M=$$PWD modules

clean:
	rm -rf *.o  .*.cmd  *.ko *.mod.c .tmp_versions  modules.order Module.symvers  *.tmp *.log
	