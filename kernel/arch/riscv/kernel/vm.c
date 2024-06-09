// arch/riscv/kernel/vm.c
#include "defs.h"
#include "string.h"
#include "mm.h"
#include "vm.h"
#include "printk.h"

/* early_pgtbl: 用于 setup_vm 进行 1GB 的 映射。 */
unsigned long early_pgtbl[512] __attribute__((__aligned__(0x1000)));
/* swapper_pg_dir: kernel pagetable 根目录， 在 setup_vm_final 进行映射。 */
unsigned long  swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

extern char _stext[];
extern char _srodata[];
extern char _sdata[];
extern char _sbss[];

void setup_vm(void){
    // 1. 由于是进行 1GB 的映射 这里不需要使用多级页表
    // 2. 将 va 的 64bit 作为如下划分： | high bit | 9 bit | 30 bit |
    //     high bit 可以忽略
    //     中间9 bit 作为 early_pgtbl 的 index
    //     低 30 bit 作为 页内偏移 这里注意到 30 = 9 + 9 + 12， 即我们只使用根页表， 根页表的每个 entry 都对应 1GB 的区域。
    // 3. Page Table Entry 的权限 V | R | W | X 位设置为 1

    // printk("in setup_vm\n");// DEBUG
    memset(early_pgtbl, 0x0, PGSIZE);
    int index = ((uint64)(PHY_START) >> 30) & 0x1ff;
    early_pgtbl[index] = (((PHY_START >> 30) & 0x3ffffff) << 28) | 1 | 2 | 4 | 8;
    index = (((uint64)(VM_START) >> 30) & 0x1ff);
    early_pgtbl[index] = (((PHY_START >> 30) & 0x3ffffff) << 28) | 1 | 2 | 4 | 8;
    // printk("setup_vm done.\n");// DEBUG
    // printk("flag3\n");
    // __asm__ volatile (
    //     "li a0, 0xffffffdf80000000\n"
    //     "add sp, sp, a0\n"
    //     : : : "a0", "sp", "memory"
    // );
}

void setup_vm_final(void) {
    memset(swapper_pg_dir, 0x0, PGSIZE);

    // No OpenSBI mapping required

    // mapping kernel text X|-|R|V
    uint64 va = VM_START + OPENSBI_SIZE;
    uint64 pa = PHY_START + OPENSBI_SIZE;
    uint64 size = _srodata - _stext;
    create_mapping(swapper_pg_dir, va, pa, size, 8 | 2 | 1);

    // mapping kernel rodata -|-|R|V
    va += size;
    pa += size;
    size = _sdata - _srodata;
    create_mapping(swapper_pg_dir, va, pa, size, 2 | 1);
  
    // mapping other memory -|W|R|V
    va += size;
    pa += size;
    size = PHY_SIZE - (_sdata - _stext);
    create_mapping(swapper_pg_dir, va, pa, size, 4 | 2 | 1);

    // set satp with swapper_pg_dir
    uint64 _satp = (((uint64)(swapper_pg_dir) - PA2VA_OFFSET) >> 12) | (8L << 60);
    csr_write(satp, _satp);

    // flush TLB
    asm volatile("sfence.vma zero, zero");

    // flush icache
    asm volatile("fence.i");
    return;
}


/* 创建多级页表映射关系 */
void create_mapping(uint64 *pgtbl, uint64 va, uint64 pa, uint64 sz, uint64 perm) {
    /*
    pgtbl 为根页表的基地址
    va, pa 为需要映射的虚拟地址、物理地址
    sz 为映射的大小
    perm 为映射的读写权限

    将给定的一段虚拟内存映射到物理内存上
    物理内存需要分页
    创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
    可以使用 V bit 来判断页表项是否存在
    */
    int i = sz / PGSIZE + 1;  // 计算需要多少页表项来覆盖 sz 大小的内存空间
    uint64 *level2, *level3;  // 二级页表指针、三级页表指针
    uint64 *p_level2, *p_level3;  // 二级页表物理地址指针、三级页表物理地址指针

    while (i--) {
        int vpn2 = (va >> 30) & 0x1ff;  // 计算虚拟地址的 VPN2
        int vpn1 = (va >> 21) & 0x1ff;  // 计算虚拟地址的 VPN1
        int vpn0 = (va >> 12) & 0x1ff;  // 计算虚拟地址的 VPN0

        // 处理顶层页表
        if (pgtbl[vpn2] & 1)
            level2 = (uint64 *)((((uint64)pgtbl[vpn2] >> 10) << 12));  // 获取二级页表地址
        else {
            level2 = (uint64 *)kalloc();  // 申请一块内存空间作为新的二级页表
            p_level2 = (uint64)level2-PA2VA_OFFSET;  // 获取二级页表的物理地址
            pgtbl[vpn2] = ((((uint64)level2 - PA2VA_OFFSET) >> 12) << 10) | 0x1;  // 更新顶层页表项内容
        }

        // 处理二级页表
        if (p_level2[vpn1] & 1)
            level3 = (uint64 *)((((uint64)p_level2[vpn1] >> 10) << 12));  // 获取三级页表地址
        else {
            level3 = (uint64 *)kalloc();  // 申请一块内存空间作为新的三级页表
            p_level3 = (uint64)level3-PA2VA_OFFSET;  // 获取三级页表的物理地址
            p_level2[vpn1] = ((((uint64)level3 - PA2VA_OFFSET) >> 12) << 10) | 0x1;  // 更新二级页表项内容
        }

        // 处理三级页表
        if (!(p_level3[vpn0] & 1))
            p_level3[vpn0] = ((pa >> 12) << 10) | perm;  // 存储物理地址及权限信息到三级页表项

        // 处理下一页
        va += PGSIZE;
        pa += PGSIZE;
    }
}
