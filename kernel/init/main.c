#include "printk.h"
#include "sbi.h"

extern void test();

int start_kernel(int year) {
    printk("%d", year);
    printk(" ZJU Computer System III\n");

    test(); // DO NOT DELETE !!!

	return 0;
}
