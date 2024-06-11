// arch/riscv/kernel/vm.c
extern char _stext[];
extern char _srodata[];
extern char _sdata[];

#include "defs.h"
#include "printk.h"
#include "types.h"
#include "vm.h"

/* early_pgtbl: 用于 setup_vm 进行 1GB 的 映射。 */
unsigned long early_pgtbl[512] __attribute__((__aligned__(0x1000)));
/* swapper_pg_dir: kernel pagetable 根目录， 在 setup_vm_final 进行映射。 */
unsigned long swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

void setup_vm(void)
{
    //printk("hello!\n");
    memset(early_pgtbl, 0x0, PGSIZE); //initialization
    uint64 pa = PHY_START, va = PHY_START;

    early_pgtbl[(va >> 30) & 0x1ff] = (((pa >> 30) & 0x3ffffff) << 28) | 0x6f;
    va += PA2VA_OFFSET;
    early_pgtbl[(va >> 30) & 0x1ff] = (((pa >> 30) & 0x3ffffff) << 28) | 0x6f;
}

void setup_vm_final(void) {
    memset(swapper_pg_dir, 0x0, PGSIZE);

    // No OpenSBI mapping required
    uint64 va, pa, size, perm, addr[3];

    va = VM_START + OPENSBI_SIZE;
    pa = PHY_START + OPENSBI_SIZE;
    addr[0] = (uint64)_stext;
    addr[1] = (uint64)_srodata;
    addr[2] = (uint64)_sdata;

    // mapping kernel text X|-|R|V
    size = addr[1] - addr[0];
    perm = 0x6b;
    //printk("text: %lx -> %lx\n", va, va + size);
    create_mapping(swapper_pg_dir, va, pa, size, perm);

    // mapping kernel rodata -|-|R|V
    va += size;
    pa += size;
    size = addr[2] - addr[1];
    perm = 0x63;
    //printk("rodata: %lx -> %lx\n", va, va + size);
    create_mapping(swapper_pg_dir, va, pa, size, perm);
  
    // mapping other memory -|W|R|V
    va += size;
    pa += size;
    size = PHY_SIZE - (addr[2] - addr[0]);
    perm = 0x67;
    //printk("other memory: %lx -> %lx\n", va, va + size);
    create_mapping(swapper_pg_dir, va, pa, size, perm);
  
    // set satp with swapper_pg_dir
    unsigned long pg_addr = (unsigned long)swapper_pg_dir - PA2VA_OFFSET;
    asm volatile(
    "li t0, 8\n"
    "slli t0, t0, 60\n"
    "mv t1, %[pg_addr]\n"
    "srli t1, t1, 12\n"
    "or t0, t0, t1\n"
    "csrw satp, t0"
    :
    :[pg_addr]"r"(pg_addr)
    :"memory"
    );

    // flush TLB
    asm volatile("sfence.vma zero, zero");

    // flush icache
    asm volatile("fence.i");
    return;
}


/* 创建多级页表映射关系 */
void create_mapping(uint64 *pgtbl, uint64 va, uint64 pa, uint64 sz, uint64 perm) {
    uint64 vpn[3], *cur_pgtbl;
    uint64 addr, va_bound = va + sz, cnt = 1;

    while (va != va_bound)
    {
        cur_pgtbl = pgtbl;
        vpn[2] = (va >> 30) & 0x1ff;
        if (!(cur_pgtbl[vpn[2]] & 0x1))
        {
            addr = (uint64)kalloc() - PA2VA_OFFSET;
            cur_pgtbl[vpn[2]] = ((addr >> 12) << 10) | 0x1;
        }

        cur_pgtbl = (uint64 *)((cur_pgtbl[vpn[2]] >> 10) << 12 + PA2VA_OFFSET);
        vpn[1] = (va >> 21) & 0x1ff;
        if (!(cur_pgtbl[vpn[1]] & 0x1))
        {
            addr = (uint64)kalloc() - PA2VA_OFFSET;
            cur_pgtbl[vpn[1]] = ((addr >> 12) << 10) | 0x1;
        }

        cur_pgtbl = (uint64 *)((cur_pgtbl[vpn[1]] >> 10) << 12 + PA2VA_OFFSET);
        vpn[0] = (va >> 12) & 0x1ff;
        //addr = (uint64)kalloc() - PA2VA_OFFSET;
        cur_pgtbl[vpn[0]] = ((pa >> 12) << 10) | (perm /*& 0xf*/) | 0x1;

        /*if (cnt)
        {
            printk("\t%lx -> %lx\n", va, cur_pgtbl[vpn[0]]);
            cnt--;
        }
        */
        
        va += PGSIZE;
        pa += PGSIZE;
    }
}
