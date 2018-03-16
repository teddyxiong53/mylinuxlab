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

