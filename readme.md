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

