#include <linux/init.h>
#include <linux/module.h>


int hello_init(void)
{
    printk("hello module init\n");
    return 0;
}

void hello_exit(void)
{
    printk("hello module exit\n");
}


module_init(hello_init);
module_exit(hello_exit);
MODULE_AUTHOR("teddyxiong53 <1073167306@qq.com>");
MODULE_LICENSE("Dual BSD/GPL");
