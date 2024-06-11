//arch/riscv/kernel/proc.c
#include "proc.h"
#include "mm.h"
#include "defs.h"
#include "printk.h"
#include "rand.h"

extern void __dummy();
extern void __switch_to(struct task_struct* prev, struct task_struct* next);

struct task_struct* idle;           // idle process
struct task_struct* current;        // 指向当前运行线程的 `task_struct`
struct task_struct* task[NR_TASKS]; // 线程数组，所有的线程都保存在此

void task_init() {
	int i;

	idle = (struct task_struct*)kalloc(); //space allocation(page)
	idle->state = TASK_RUNNING;
	idle->counter = 0;
	idle->priority = 0; //initialization
	idle->pid = 0; //set pid
	
	task[0] = idle;
    current = idle;
    for (i = 1; i < NR_TASKS; i++)
    {
    	task[i] = (struct task_struct*)kalloc();
    	task[i]->state = TASK_RUNNING; //same as idle
    	task[i]->counter = 0;
    	task[i]->priority = rand()%(PRIORITY_MAX - PRIORITY_MIN + 1) + PRIORITY_MIN; //generated randomly within range of min~max
    	task[i]->pid = i; //set pid in order
    		
    	task[i]->thread.ra = (uint64)__dummy;
    	task[i]->thread.sp = (uint64)(task[i]) + PGSIZE; //stack pointer(from the "bottom" of the page)
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
            		printk("[PID = %d] is running. auto_inc_local_var = %d. ", current->pid, auto_inc_local_var);
					printk("Thread space begin at %lx\n", current);
        	} else if((last_last_counter == 0 || last_last_counter == -1) && last_counter == 1) { // counter恒为1的情况
            		last_counter = 0; 
            		current->counter = 0;
        	}
	}
}

void switch_to(struct task_struct* next){
	if(current != next){
		printk("\n");
		printk("switch to [PID = %d PRIORITY = %d COUNTER = %d]\n", next->pid, next->priority, next->counter);
		
		struct task_struct* prev = current; //save previous state
		current = next;
		__switch_to(prev, next);
	}
}

void do_timer(){
	if(current == idle || current->counter == 0){
		schedule();
	}else{
		current->counter--;
		if(current->counter > 0){
			return;
		}else{
			schedule();
		}
	}
}

void schedule(){
    struct task_struct* next;
    int i;
    uint64 min = PRIORITY_MAX + 1;

    while(1) {
        for (i = 1; i < NR_TASKS; i++)
        {
            if(task[i]->counter == 0||task[i]->state != TASK_RUNNING){
                continue;
            }
            if(task[i]->counter < min){ //update
                min = task[i]->counter;
                next = task[i];
            }
        }

        if (min != PRIORITY_MAX + 1)
        {
            break;
        }

        for (i = 1; i < NR_TASKS; i++)
        {
            task[i]->counter = (task[i]->counter >> 1) + task[i]->priority;
            printk("SET [PID = %d PRIORITY = %d COUNTER = %d]\n", task[i]->pid, task[i]->priority, task[i]->counter);
        }
    }

    switch_to(next);
}