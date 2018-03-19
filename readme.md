# 目录结构

```
├── busybox
│   └── busybox-1.27.2
├── kernel
│   └── linux-stable
├── ramfs
├── si：放source insight工程的。
└── uboot
    └── u-boot
```



# 使用方法

1、编译kernel

```
make kernel-defconfig
make kernel
```

内核还需要编译dtb文件。

```
make kernel-dtb
```



2、编译busybox。

```
make busybox-defconfig
make busybox
```

3、编译得到rootfs

```
make rootfs
```

4、运行。

默认是从SD卡启动的。

```
make boot
```

也可以从initramfs来中转一下。

```
make boot-ramfs
```



# 使用uboot

默认没有进行uboot编译。

如果要编译使用：

```
make uboot-defconfig
make uboot
make boot-uboot
```



# 调试内核的方法

1、启动板端的调试。

```
make kernel-debug
```

然后会卡住。

2、另外开一个shell窗口。

```
arm-none-eabi-gdb ./kernel/linux-stable/vmlinux
```

然后在gdb的提示符下。执行：

```
source .gdbinit 
```

.gdbinit是我放在mylinuxlab根目录下的几条gdb命令。可以自己改。

3、然后就可以在第二个shell窗口里进行单步执行调试内核了。

# 模块编译

1、编译。

```
make user-modules 
make user-modules-clean 
```

2、验证。

```
/mnt # cd mod/
/mnt/mod # ls
Makefile        hello.c         hello.mod.c     hello.o
Module.symvers  hello.ko        hello.mod.o     modules.order
/mnt/mod # insmod ./hello.ko
hello: loading out-of-tree module taints kernel.
hello module init
```

# 编译kernel的samples

1、编译。

```
make kernel-samples
```

编译后，会自动拷贝到./nfs目录下。

2、启动qemu，然后挂载nfs目录到/mnt目录下，就可以使用了。

