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

2、编译busybox。

```
make busybox-defconfig
make busybox
```

3、编译得到ramfs.gz

```
make ramfs
```

4、运行。

```
make boot
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

