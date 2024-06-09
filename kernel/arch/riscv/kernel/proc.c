#include "proc.h"
#include "defs.h"
#include "mm.h"
#include "rand.h"
#include "printk.h"
#include "math.h"

extern void __dummy();

struct task_struct* idle;
struct task_struct* current;
struct task_struct* task[NR_TASKS];

void task_init() {
    idle = (struct task_struct*)kalloc();
    idle->state = TASK_RUNNING;
    idle->counter = 0;
    idle->priority = 0;
    idle->pid = 0;
    current = idle;
    task[0] = idle;

    int i;
    for(i=1;i<NR_TASKS;i++){
        task[i] = (struct task_struct*)kalloc();
        task[i]->state = TASK_RUNNING;
        task[i]->counter = 0;
        task[i]->priority = (uint64)rand() % (PRIORITY_MAX - PRIORITY_MIN + 1) + PRIORITY_MIN;
        task[i]->pid = i;
        task[i]->thread.ra = (uint64)__dummy;
        task[i]->thread.sp = (uint64)task[i] + PGSIZE;
    }

    printk("...proc_init done!\n");
}

void dummy() {
    uint64 MOD = 1000000007;
    uint64 auto_inc_local_var = 0;
    int last_counter = -1; // 记录上一个counter
    int last_last_counter = -1; // 记录上上个counter
    while(1) {
        if (last_counter == -1 || current->counter != last_counter) {
            last_last_counter = last_counter;
            last_counter = current->counter;
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
            printk("[PID = %d] is running.",current->pid);
        } else if((last_last_counter == 0 || last_last_counter == -1) && last_counter == 1) { // counter恒为1的情况
            last_counter = 0; 
            current->counter = 0;
        }
    }
}

extern void __switch_to(struct task_struct* prev, struct task_struct* next);

void switch_to(struct task_struct* next) {
    if (next != current) {
        printk("switch to [PID = %d]\n", next->pid);
        struct task_struct* prev = current;
        current = next;
        __switch_to(prev, current);
    }
}

void do_timer(void) {
    if(current->counter == 0){
        schedule();
        return;
    }
    current->counter--;
    if(current->counter > 0) return;
    schedule();
}


void schedule(void) {
    int i,next;
    struct task_struct *p = idle;
    uint64 c=0xffffffffffffffff;
    next = 0;
    while (1) {
        i=1;
        while(i<NR_TASKS){
            p = task[i];
            if(!(p->counter)) {
                i++;
                continue;
            }
            if(p->state == TASK_RUNNING && p->counter < c){
				c = p->counter;
                next = i;
            }
            i++;
		}
		if (task[next]!=idle) break;
		for(int i = 1; i < NR_TASKS; i++){
            if(i==1) printk("\n");
            task[i]->counter = task[i]->priority;
            printk("[PID = %d COUNTER = %d]\n", task[i]->pid, task[i]->counter);
        }
    }
    switch_to(task[next]);
}