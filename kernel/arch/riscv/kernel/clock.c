// clock.c
#include "sbi.h"

unsigned long TIMECLOCK = 10000000;

unsigned long get_cycles() {
    unsigned long cycle_num;
    __asm__ volatile(
    "rdtime %[time]\n"
    :[time] "=r" (cycle_num)
    :: "memory"
    );
    return cycle_num;
}

void clock_set_next_event() {
    unsigned long next_t = get_cycles() + TIMECLOCK;
    sbi_set_timer(next_t);
}