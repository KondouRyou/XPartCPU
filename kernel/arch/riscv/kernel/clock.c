// clock.c
#include "sbi.h"

//unsigned long TIMECLOCK = 10000000;
unsigned long TIMECLOCK = 0x50000;
unsigned long get_cycles() {
    unsigned long time;
    __asm__ volatile (
        "rdtime a0\n"
        "mv %[time], a0"
        : [time] "=r" (time)
        : : "a0", "memory"
    );
    return time;
}

void clock_set_next_event() {
    unsigned long next = get_cycles() + TIMECLOCK;
    sbi_ecall(0x00,0,next,0,0,0,0,0);
} 