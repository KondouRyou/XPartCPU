#include "printk.h"
#include "sbi.h"

extern void test();

int start_kernel() {
    int n=2023;
    printk("ZJU Computer System II %d\n",n);

    test();

	return 0;
}
