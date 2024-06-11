// trap.c 
#include "printk.h"
#include "clock.h"
#include "proc.h"

void trap_handler(unsigned long scause, unsigned long sepc) {
    if (scause >> 63)
    {
        if ((scause & 0x7fffffffffffffff) == 5)
        {
            //printk("[S] Supervisor Mode Timer Interrupt\n");
            clock_set_next_event();
            do_timer();
            return;
        }
    }
    
}