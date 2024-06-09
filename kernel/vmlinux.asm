
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_start>:

.section .text.init
.globl _start,_ekernel
_start:

  li a0, 0x20
    80200000:	02000513          	li	a0,32
  csrs sie, a0
    80200004:	10452073          	csrs	sie,a0

  li a2, 0x50000
    80200008:	00050637          	lui	a2,0x50
  addi a0, zero, 0
    8020000c:	00000513          	li	a0,0
  addi a1, zero, 0
    80200010:	00000593          	li	a1,0
  addi a3, zero, 0
    80200014:	00000693          	li	a3,0
  addi a4, zero, 0
    80200018:	00000713          	li	a4,0
  addi a5, zero, 0
    8020001c:	00000793          	li	a5,0
  addi a6, zero, 0
    80200020:	00000813          	li	a6,0
  addi a7, zero, 0
    80200024:	00000893          	li	a7,0
  la sp, stack_top
    80200028:	00003117          	auipc	sp,0x3
    8020002c:	ff813103          	ld	sp,-8(sp) # 80203020 <_GLOBAL_OFFSET_TABLE_+0x18>
  call sbi_ecall
    80200030:	195000ef          	jal	ra,802009c4 <sbi_ecall>

  la a0, _traps
    80200034:	00003517          	auipc	a0,0x3
    80200038:	ffc53503          	ld	a0,-4(a0) # 80203030 <_GLOBAL_OFFSET_TABLE_+0x28>
  csrw stvec, a0
    8020003c:	10551073          	csrw	stvec,a0

  li t0, 0xa2
    80200040:	0a200293          	li	t0,162
  csrw sstatus, t0
    80200044:	10029073          	csrw	sstatus,t0

  call mm_init
    80200048:	35c000ef          	jal	ra,802003a4 <mm_init>

  call task_init
    8020004c:	39c000ef          	jal	ra,802003e8 <task_init>
  
  j start_kernel
    80200050:	2bd0006f          	j	80200b0c <start_kernel>

0000000080200054 <_traps>:

    # YOUR CODE HERE
    # -----------

        # 1. save 32 registers and sepc to stack
    sd sp, -0x8(sp)
    80200054:	fe213c23          	sd	sp,-8(sp)
    sd ra, -0x10(sp)
    80200058:	fe113823          	sd	ra,-16(sp)
    sd gp, -0x18(sp)
    8020005c:	fe313423          	sd	gp,-24(sp)
    sd tp, -0x20(sp)
    80200060:	fe413023          	sd	tp,-32(sp)
    sd t0, -0x28(sp)
    80200064:	fc513c23          	sd	t0,-40(sp)
    sd t1, -0x30(sp)
    80200068:	fc613823          	sd	t1,-48(sp)
    sd t2, -0x38(sp)
    8020006c:	fc713423          	sd	t2,-56(sp)
    sd t3, -0x40(sp)
    80200070:	fdc13023          	sd	t3,-64(sp)
    sd t4, -0x48(sp)
    80200074:	fbd13c23          	sd	t4,-72(sp)
    sd t5, -0x50(sp)
    80200078:	fbe13823          	sd	t5,-80(sp)
    sd t6, -0x58(sp)
    8020007c:	fbf13423          	sd	t6,-88(sp)
    sd a0, -0x60(sp)
    80200080:	faa13023          	sd	a0,-96(sp)
    sd a1, -0x68(sp)
    80200084:	f8b13c23          	sd	a1,-104(sp)
    sd a2, -0x70(sp)
    80200088:	f8c13823          	sd	a2,-112(sp)
    sd a3, -0x78(sp)
    8020008c:	f8d13423          	sd	a3,-120(sp)
    sd a4, -0x80(sp)
    80200090:	f8e13023          	sd	a4,-128(sp)
    sd a5, -0x88(sp)
    80200094:	f6f13c23          	sd	a5,-136(sp)
    sd a6, -0x90(sp)
    80200098:	f7013823          	sd	a6,-144(sp)
    sd a7, -0x98(sp)
    8020009c:	f7113423          	sd	a7,-152(sp)
    sd s0, -0xa0(sp)
    802000a0:	f6813023          	sd	s0,-160(sp)
    sd s1, -0xa8(sp)
    802000a4:	f4913c23          	sd	s1,-168(sp)
    sd s2, -0xb0(sp)
    802000a8:	f5213823          	sd	s2,-176(sp)
    sd s3, -0xb8(sp)
    802000ac:	f5313423          	sd	s3,-184(sp)
    sd s4, -0xc0(sp)
    802000b0:	f5413023          	sd	s4,-192(sp)
    sd s5, -0xc8(sp)
    802000b4:	f3513c23          	sd	s5,-200(sp)
    sd s6, -0xd0(sp)
    802000b8:	f3613823          	sd	s6,-208(sp)
    sd s7, -0xd8(sp)
    802000bc:	f3713423          	sd	s7,-216(sp)
    sd s8, -0xe0(sp)
    802000c0:	f3813023          	sd	s8,-224(sp)
    sd s9, -0xe8(sp)
    802000c4:	f1913c23          	sd	s9,-232(sp)
    sd s10, -0xf0(sp)
    802000c8:	f1a13823          	sd	s10,-240(sp)
    sd s11, -0xf8(sp)
    802000cc:	f1b13423          	sd	s11,-248(sp)
    csrr a1,sepc
    802000d0:	141025f3          	csrr	a1,sepc
    sd a1, -0x100(sp)
    802000d4:	f0b13023          	sd	a1,-256(sp)
    addi sp, sp, -0x100
    802000d8:	f0010113          	addi	sp,sp,-256

    # -----------

        # 2. call trap_handler
    csrr a0, scause
    802000dc:	14202573          	csrr	a0,scause
    call trap_handler
    802000e0:	1d9000ef          	jal	ra,80200ab8 <trap_handler>

    # -----------

        # 3. restore sepc and 32 registers (x2(sp) should be restore last) from stack
    ld a1, 0x0(sp)
    802000e4:	00013583          	ld	a1,0(sp)
    csrw sepc, a1
    802000e8:	14159073          	csrw	sepc,a1
    addi sp, sp, 0x8
    802000ec:	00810113          	addi	sp,sp,8
    ld s11, 0x0(sp)
    802000f0:	00013d83          	ld	s11,0(sp)
    ld s10, 0x8(sp)
    802000f4:	00813d03          	ld	s10,8(sp)
    ld s9, 0x10(sp)
    802000f8:	01013c83          	ld	s9,16(sp)
    ld s8, 0x18(sp)
    802000fc:	01813c03          	ld	s8,24(sp)
    ld s7, 0x20(sp)
    80200100:	02013b83          	ld	s7,32(sp)
    ld s6, 0x28(sp)
    80200104:	02813b03          	ld	s6,40(sp)
    ld s5, 0x30(sp)
    80200108:	03013a83          	ld	s5,48(sp)
    ld s4, 0x38(sp)
    8020010c:	03813a03          	ld	s4,56(sp)
    ld s3, 0x40(sp)
    80200110:	04013983          	ld	s3,64(sp)
    ld s2, 0x48(sp)
    80200114:	04813903          	ld	s2,72(sp)
    ld s1, 0x50(sp)
    80200118:	05013483          	ld	s1,80(sp)
    ld s0, 0x58(sp)
    8020011c:	05813403          	ld	s0,88(sp)
    ld a7, 0x60(sp)
    80200120:	06013883          	ld	a7,96(sp)
    ld a6, 0x68(sp)
    80200124:	06813803          	ld	a6,104(sp)
    ld a5, 0x70(sp)
    80200128:	07013783          	ld	a5,112(sp)
    ld a4, 0x78(sp)
    8020012c:	07813703          	ld	a4,120(sp)
    ld a3, 0x80(sp)
    80200130:	08013683          	ld	a3,128(sp)
    ld a2, 0x88(sp)
    80200134:	08813603          	ld	a2,136(sp)
    ld a1, 0x90(sp)
    80200138:	09013583          	ld	a1,144(sp)
    ld a0, 0x98(sp)
    8020013c:	09813503          	ld	a0,152(sp)
    ld t6, 0xa0(sp)
    80200140:	0a013f83          	ld	t6,160(sp)
    ld t5, 0xa8(sp)
    80200144:	0a813f03          	ld	t5,168(sp)
    ld t4, 0xb0(sp)
    80200148:	0b013e83          	ld	t4,176(sp)
    ld t3, 0xb8(sp)
    8020014c:	0b813e03          	ld	t3,184(sp)
    ld t2, 0xc0(sp)
    80200150:	0c013383          	ld	t2,192(sp)
    ld t1, 0xc8(sp)
    80200154:	0c813303          	ld	t1,200(sp)
    ld t0, 0xd0(sp)
    80200158:	0d013283          	ld	t0,208(sp)
    ld tp, 0xd8(sp)
    8020015c:	0d813203          	ld	tp,216(sp)
    ld gp, 0xe0(sp)
    80200160:	0e013183          	ld	gp,224(sp)
    ld ra, 0xe8(sp)
    80200164:	0e813083          	ld	ra,232(sp)
    ld sp, 0xf0(sp)
    80200168:	0f013103          	ld	sp,240(sp)

    # -----------

        # 4. return from trap
    sret
    8020016c:	10200073          	sret

0000000080200170 <__dummy>:

    # -----------

__dummy:
    la a0, dummy
    80200170:	00003517          	auipc	a0,0x3
    80200174:	eb853503          	ld	a0,-328(a0) # 80203028 <_GLOBAL_OFFSET_TABLE_+0x20>
    csrw sepc, a0
    80200178:	14151073          	csrw	sepc,a0
    sret
    8020017c:	10200073          	sret

0000000080200180 <__switch_to>:

__switch_to:
    # save state to prev process
    # YOUR CODE HERE
    sd ra,40(a0)
    80200180:	02153423          	sd	ra,40(a0)
    sd sp,48(a0)
    80200184:	02253823          	sd	sp,48(a0)
    sd s0,56(a0)
    80200188:	02853c23          	sd	s0,56(a0)
    sd s1,64(a0)
    8020018c:	04953023          	sd	s1,64(a0)
    sd s2,72(a0)
    80200190:	05253423          	sd	s2,72(a0)
    sd s3,80(a0)
    80200194:	05353823          	sd	s3,80(a0)
    sd s4,88(a0)
    80200198:	05453c23          	sd	s4,88(a0)
    sd s5,96(a0)
    8020019c:	07553023          	sd	s5,96(a0)
    sd s6,104(a0)
    802001a0:	07653423          	sd	s6,104(a0)
    sd s7,112(a0)
    802001a4:	07753823          	sd	s7,112(a0)
    sd s8,120(a0)
    802001a8:	07853c23          	sd	s8,120(a0)
    sd s9,128(a0)
    802001ac:	09953023          	sd	s9,128(a0)
    sd s10,136(a0)
    802001b0:	09a53423          	sd	s10,136(a0)
    sd s11,144(a0)
    802001b4:	09b53823          	sd	s11,144(a0)

    # restore state from next process
    # YOUR CODE HERE
    ld s11,144(a1)
    802001b8:	0905bd83          	ld	s11,144(a1)
    ld s10,136(a1)
    802001bc:	0885bd03          	ld	s10,136(a1)
    ld s9,128(a1)
    802001c0:	0805bc83          	ld	s9,128(a1)
    ld s8,120(a1)
    802001c4:	0785bc03          	ld	s8,120(a1)
    ld s7,112(a1)
    802001c8:	0705bb83          	ld	s7,112(a1)
    ld s6,104(a1)
    802001cc:	0685bb03          	ld	s6,104(a1)
    ld s5,96(a1)
    802001d0:	0605ba83          	ld	s5,96(a1)
    ld s4,88(a1)
    802001d4:	0585ba03          	ld	s4,88(a1)
    ld s3,80(a1)
    802001d8:	0505b983          	ld	s3,80(a1)
    ld s2,72(a1)
    802001dc:	0485b903          	ld	s2,72(a1)
    ld s1,64(a1)
    802001e0:	0405b483          	ld	s1,64(a1)
    ld s0,56(a1)
    802001e4:	0385b403          	ld	s0,56(a1)
    ld sp,48(a1)
    802001e8:	0305b103          	ld	sp,48(a1)
    ld ra,40(a1)
    802001ec:	0285b083          	ld	ra,40(a1)

    802001f0:	00008067          	ret

00000000802001f4 <get_cycles>:
// clock.c
#include "sbi.h"

//unsigned long TIMECLOCK = 10000000;
unsigned long TIMECLOCK = 0x50000;
unsigned long get_cycles() {
    802001f4:	fe010113          	addi	sp,sp,-32
    802001f8:	00813c23          	sd	s0,24(sp)
    802001fc:	02010413          	addi	s0,sp,32
    unsigned long time;
    __asm__ volatile (
    80200200:	c0102573          	rdtime	a0
    80200204:	00050793          	mv	a5,a0
    80200208:	fef43423          	sd	a5,-24(s0)
        "rdtime a0\n"
        "mv %[time], a0"
        : [time] "=r" (time)
        : : "a0", "memory"
    );
    return time;
    8020020c:	fe843783          	ld	a5,-24(s0)
}
    80200210:	00078513          	mv	a0,a5
    80200214:	01813403          	ld	s0,24(sp)
    80200218:	02010113          	addi	sp,sp,32
    8020021c:	00008067          	ret

0000000080200220 <clock_set_next_event>:

void clock_set_next_event() {
    80200220:	fe010113          	addi	sp,sp,-32
    80200224:	00113c23          	sd	ra,24(sp)
    80200228:	00813823          	sd	s0,16(sp)
    8020022c:	02010413          	addi	s0,sp,32
    unsigned long next = get_cycles() + TIMECLOCK;
    80200230:	fc5ff0ef          	jal	ra,802001f4 <get_cycles>
    80200234:	00050713          	mv	a4,a0
    80200238:	00003797          	auipc	a5,0x3
    8020023c:	dc878793          	addi	a5,a5,-568 # 80203000 <TIMECLOCK>
    80200240:	0007b783          	ld	a5,0(a5)
    80200244:	00f707b3          	add	a5,a4,a5
    80200248:	fef43423          	sd	a5,-24(s0)
    sbi_ecall(0x00,0,next,0,0,0,0,0);
    8020024c:	00000893          	li	a7,0
    80200250:	00000813          	li	a6,0
    80200254:	00000793          	li	a5,0
    80200258:	00000713          	li	a4,0
    8020025c:	00000693          	li	a3,0
    80200260:	fe843603          	ld	a2,-24(s0)
    80200264:	00000593          	li	a1,0
    80200268:	00000513          	li	a0,0
    8020026c:	758000ef          	jal	ra,802009c4 <sbi_ecall>
    80200270:	00000013          	nop
    80200274:	01813083          	ld	ra,24(sp)
    80200278:	01013403          	ld	s0,16(sp)
    8020027c:	02010113          	addi	sp,sp,32
    80200280:	00008067          	ret

0000000080200284 <kalloc>:

struct {
    struct run *freelist;
} kmem;

uint64 kalloc() {
    80200284:	fe010113          	addi	sp,sp,-32
    80200288:	00813c23          	sd	s0,24(sp)
    8020028c:	02010413          	addi	s0,sp,32
    //printk("\nin kalloc\n");
    struct run *r;

    //printk("\n1\n");
    r = kmem.freelist;
    80200290:	00004797          	auipc	a5,0x4
    80200294:	d7078793          	addi	a5,a5,-656 # 80204000 <kmem>
    80200298:	0007b783          	ld	a5,0(a5)
    8020029c:	fef43423          	sd	a5,-24(s0)
    kmem.freelist = r->next;
    802002a0:	fe843783          	ld	a5,-24(s0)
    802002a4:	0007b703          	ld	a4,0(a5)
    802002a8:	00004797          	auipc	a5,0x4
    802002ac:	d5878793          	addi	a5,a5,-680 # 80204000 <kmem>
    802002b0:	00e7b023          	sd	a4,0(a5)
    
    //printk("\nto memset\n");
    //memset((void *)r, 0x0, PGSIZE);
    //printk("\nmemset done\n\nkalloc done\n");
    return (uint64) r;
    802002b4:	fe843783          	ld	a5,-24(s0)
}
    802002b8:	00078513          	mv	a0,a5
    802002bc:	01813403          	ld	s0,24(sp)
    802002c0:	02010113          	addi	sp,sp,32
    802002c4:	00008067          	ret

00000000802002c8 <kfree>:

void kfree(uint64 addr) {
    802002c8:	fd010113          	addi	sp,sp,-48
    802002cc:	02813423          	sd	s0,40(sp)
    802002d0:	03010413          	addi	s0,sp,48
    802002d4:	fca43c23          	sd	a0,-40(s0)
    struct run *r;

    // PGSIZE align 
    addr = addr & ~(PGSIZE - 1);
    802002d8:	fd843703          	ld	a4,-40(s0)
    802002dc:	fffff7b7          	lui	a5,0xfffff
    802002e0:	00f777b3          	and	a5,a4,a5
    802002e4:	fcf43c23          	sd	a5,-40(s0)

    //memset((void *)addr, 0x0, (uint64)PGSIZE);

    r = (struct run *)addr;
    802002e8:	fd843783          	ld	a5,-40(s0)
    802002ec:	fef43423          	sd	a5,-24(s0)
    r->next = kmem.freelist;
    802002f0:	00004797          	auipc	a5,0x4
    802002f4:	d1078793          	addi	a5,a5,-752 # 80204000 <kmem>
    802002f8:	0007b703          	ld	a4,0(a5)
    802002fc:	fe843783          	ld	a5,-24(s0)
    80200300:	00e7b023          	sd	a4,0(a5)
    kmem.freelist = r;
    80200304:	00004797          	auipc	a5,0x4
    80200308:	cfc78793          	addi	a5,a5,-772 # 80204000 <kmem>
    8020030c:	fe843703          	ld	a4,-24(s0)
    80200310:	00e7b023          	sd	a4,0(a5)

    return ;
    80200314:	00000013          	nop
}
    80200318:	02813403          	ld	s0,40(sp)
    8020031c:	03010113          	addi	sp,sp,48
    80200320:	00008067          	ret

0000000080200324 <kfreerange>:

void kfreerange(char *start, char *end) {
    80200324:	fd010113          	addi	sp,sp,-48
    80200328:	02113423          	sd	ra,40(sp)
    8020032c:	02813023          	sd	s0,32(sp)
    80200330:	03010413          	addi	s0,sp,48
    80200334:	fca43c23          	sd	a0,-40(s0)
    80200338:	fcb43823          	sd	a1,-48(s0)
    char *addr = (char *)PGROUNDUP((uint64)start);
    8020033c:	fd843703          	ld	a4,-40(s0)
    80200340:	000017b7          	lui	a5,0x1
    80200344:	fff78793          	addi	a5,a5,-1 # fff <_start-0x801ff001>
    80200348:	00f70733          	add	a4,a4,a5
    8020034c:	fffff7b7          	lui	a5,0xfffff
    80200350:	00f777b3          	and	a5,a4,a5
    80200354:	fef43423          	sd	a5,-24(s0)
    for (; (uint64)(addr) + PGSIZE <= (uint64)end; addr += PGSIZE) {
    80200358:	0200006f          	j	80200378 <kfreerange+0x54>
        kfree((uint64)addr);
    8020035c:	fe843783          	ld	a5,-24(s0)
    80200360:	00078513          	mv	a0,a5
    80200364:	f65ff0ef          	jal	ra,802002c8 <kfree>
    for (; (uint64)(addr) + PGSIZE <= (uint64)end; addr += PGSIZE) {
    80200368:	fe843703          	ld	a4,-24(s0)
    8020036c:	000017b7          	lui	a5,0x1
    80200370:	00f707b3          	add	a5,a4,a5
    80200374:	fef43423          	sd	a5,-24(s0)
    80200378:	fe843703          	ld	a4,-24(s0)
    8020037c:	000017b7          	lui	a5,0x1
    80200380:	00f70733          	add	a4,a4,a5
    80200384:	fd043783          	ld	a5,-48(s0)
    80200388:	fce7fae3          	bgeu	a5,a4,8020035c <kfreerange+0x38>
    }
}
    8020038c:	00000013          	nop
    80200390:	00000013          	nop
    80200394:	02813083          	ld	ra,40(sp)
    80200398:	02013403          	ld	s0,32(sp)
    8020039c:	03010113          	addi	sp,sp,48
    802003a0:	00008067          	ret

00000000802003a4 <mm_init>:

void mm_init(void) {
    802003a4:	ff010113          	addi	sp,sp,-16
    802003a8:	00113423          	sd	ra,8(sp)
    802003ac:	00813023          	sd	s0,0(sp)
    802003b0:	01010413          	addi	s0,sp,16
    //printk("\nin mm_init\n");
    kfreerange(_ekernel, (char *)PHY_END);
    802003b4:	080217b7          	lui	a5,0x8021
    802003b8:	00479593          	slli	a1,a5,0x4
    802003bc:	00003517          	auipc	a0,0x3
    802003c0:	c5453503          	ld	a0,-940(a0) # 80203010 <_GLOBAL_OFFSET_TABLE_+0x8>
    802003c4:	f61ff0ef          	jal	ra,80200324 <kfreerange>
    printk("...mm_init done!\n");
    802003c8:	00002517          	auipc	a0,0x2
    802003cc:	c3850513          	addi	a0,a0,-968 # 80202000 <_srodata>
    802003d0:	7dd000ef          	jal	ra,802013ac <printk>
}
    802003d4:	00000013          	nop
    802003d8:	00813083          	ld	ra,8(sp)
    802003dc:	00013403          	ld	s0,0(sp)
    802003e0:	01010113          	addi	sp,sp,16
    802003e4:	00008067          	ret

00000000802003e8 <task_init>:

struct task_struct* idle;
struct task_struct* current;
struct task_struct* task[NR_TASKS];

void task_init() {
    802003e8:	fe010113          	addi	sp,sp,-32
    802003ec:	00113c23          	sd	ra,24(sp)
    802003f0:	00813823          	sd	s0,16(sp)
    802003f4:	02010413          	addi	s0,sp,32
    idle = (struct task_struct*)kalloc();
    802003f8:	e8dff0ef          	jal	ra,80200284 <kalloc>
    802003fc:	00050793          	mv	a5,a0
    80200400:	00078713          	mv	a4,a5
    80200404:	00004797          	auipc	a5,0x4
    80200408:	c0478793          	addi	a5,a5,-1020 # 80204008 <idle>
    8020040c:	00e7b023          	sd	a4,0(a5)
    idle->state = TASK_RUNNING;
    80200410:	00004797          	auipc	a5,0x4
    80200414:	bf878793          	addi	a5,a5,-1032 # 80204008 <idle>
    80200418:	0007b783          	ld	a5,0(a5)
    8020041c:	0007b423          	sd	zero,8(a5)
    idle->counter = 0;
    80200420:	00004797          	auipc	a5,0x4
    80200424:	be878793          	addi	a5,a5,-1048 # 80204008 <idle>
    80200428:	0007b783          	ld	a5,0(a5)
    8020042c:	0007b823          	sd	zero,16(a5)
    idle->priority = 0;
    80200430:	00004797          	auipc	a5,0x4
    80200434:	bd878793          	addi	a5,a5,-1064 # 80204008 <idle>
    80200438:	0007b783          	ld	a5,0(a5)
    8020043c:	0007bc23          	sd	zero,24(a5)
    idle->pid = 0;
    80200440:	00004797          	auipc	a5,0x4
    80200444:	bc878793          	addi	a5,a5,-1080 # 80204008 <idle>
    80200448:	0007b783          	ld	a5,0(a5)
    8020044c:	0207b023          	sd	zero,32(a5)
    current = idle;
    80200450:	00004797          	auipc	a5,0x4
    80200454:	bb878793          	addi	a5,a5,-1096 # 80204008 <idle>
    80200458:	0007b703          	ld	a4,0(a5)
    8020045c:	00004797          	auipc	a5,0x4
    80200460:	bb478793          	addi	a5,a5,-1100 # 80204010 <current>
    80200464:	00e7b023          	sd	a4,0(a5)
    task[0] = idle;
    80200468:	00004797          	auipc	a5,0x4
    8020046c:	ba078793          	addi	a5,a5,-1120 # 80204008 <idle>
    80200470:	0007b703          	ld	a4,0(a5)
    80200474:	00004797          	auipc	a5,0x4
    80200478:	ba478793          	addi	a5,a5,-1116 # 80204018 <task>
    8020047c:	00e7b023          	sd	a4,0(a5)

    int i;
    for(i=1;i<NR_TASKS;i++){
    80200480:	00100793          	li	a5,1
    80200484:	fef42623          	sw	a5,-20(s0)
    80200488:	12c0006f          	j	802005b4 <task_init+0x1cc>
        task[i] = (struct task_struct*)kalloc();
    8020048c:	df9ff0ef          	jal	ra,80200284 <kalloc>
    80200490:	00050793          	mv	a5,a0
    80200494:	00078693          	mv	a3,a5
    80200498:	00004717          	auipc	a4,0x4
    8020049c:	b8070713          	addi	a4,a4,-1152 # 80204018 <task>
    802004a0:	fec42783          	lw	a5,-20(s0)
    802004a4:	00379793          	slli	a5,a5,0x3
    802004a8:	00f707b3          	add	a5,a4,a5
    802004ac:	00d7b023          	sd	a3,0(a5)
        task[i]->state = TASK_RUNNING;
    802004b0:	00004717          	auipc	a4,0x4
    802004b4:	b6870713          	addi	a4,a4,-1176 # 80204018 <task>
    802004b8:	fec42783          	lw	a5,-20(s0)
    802004bc:	00379793          	slli	a5,a5,0x3
    802004c0:	00f707b3          	add	a5,a4,a5
    802004c4:	0007b783          	ld	a5,0(a5)
    802004c8:	0007b423          	sd	zero,8(a5)
        task[i]->counter = 0;
    802004cc:	00004717          	auipc	a4,0x4
    802004d0:	b4c70713          	addi	a4,a4,-1204 # 80204018 <task>
    802004d4:	fec42783          	lw	a5,-20(s0)
    802004d8:	00379793          	slli	a5,a5,0x3
    802004dc:	00f707b3          	add	a5,a4,a5
    802004e0:	0007b783          	ld	a5,0(a5)
    802004e4:	0007b823          	sd	zero,16(a5)
        task[i]->priority = (uint64)rand() % (PRIORITY_MAX - PRIORITY_MIN + 1) + PRIORITY_MIN;
    802004e8:	745000ef          	jal	ra,8020142c <rand>
    802004ec:	00050793          	mv	a5,a0
    802004f0:	00500593          	li	a1,5
    802004f4:	00078513          	mv	a0,a5
    802004f8:	700000ef          	jal	ra,80200bf8 <__umoddi3>
    802004fc:	00050793          	mv	a5,a0
    80200500:	00078693          	mv	a3,a5
    80200504:	00004717          	auipc	a4,0x4
    80200508:	b1470713          	addi	a4,a4,-1260 # 80204018 <task>
    8020050c:	fec42783          	lw	a5,-20(s0)
    80200510:	00379793          	slli	a5,a5,0x3
    80200514:	00f707b3          	add	a5,a4,a5
    80200518:	0007b783          	ld	a5,0(a5)
    8020051c:	00168713          	addi	a4,a3,1
    80200520:	00e7bc23          	sd	a4,24(a5)
        task[i]->pid = i;
    80200524:	00004717          	auipc	a4,0x4
    80200528:	af470713          	addi	a4,a4,-1292 # 80204018 <task>
    8020052c:	fec42783          	lw	a5,-20(s0)
    80200530:	00379793          	slli	a5,a5,0x3
    80200534:	00f707b3          	add	a5,a4,a5
    80200538:	0007b783          	ld	a5,0(a5)
    8020053c:	fec42703          	lw	a4,-20(s0)
    80200540:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.ra = (uint64)__dummy;
    80200544:	00004717          	auipc	a4,0x4
    80200548:	ad470713          	addi	a4,a4,-1324 # 80204018 <task>
    8020054c:	fec42783          	lw	a5,-20(s0)
    80200550:	00379793          	slli	a5,a5,0x3
    80200554:	00f707b3          	add	a5,a4,a5
    80200558:	0007b783          	ld	a5,0(a5)
    8020055c:	00003717          	auipc	a4,0x3
    80200560:	abc73703          	ld	a4,-1348(a4) # 80203018 <_GLOBAL_OFFSET_TABLE_+0x10>
    80200564:	02e7b423          	sd	a4,40(a5)
        task[i]->thread.sp = (uint64)task[i] + PGSIZE;
    80200568:	00004717          	auipc	a4,0x4
    8020056c:	ab070713          	addi	a4,a4,-1360 # 80204018 <task>
    80200570:	fec42783          	lw	a5,-20(s0)
    80200574:	00379793          	slli	a5,a5,0x3
    80200578:	00f707b3          	add	a5,a4,a5
    8020057c:	0007b783          	ld	a5,0(a5)
    80200580:	00078693          	mv	a3,a5
    80200584:	00004717          	auipc	a4,0x4
    80200588:	a9470713          	addi	a4,a4,-1388 # 80204018 <task>
    8020058c:	fec42783          	lw	a5,-20(s0)
    80200590:	00379793          	slli	a5,a5,0x3
    80200594:	00f707b3          	add	a5,a4,a5
    80200598:	0007b783          	ld	a5,0(a5)
    8020059c:	00001737          	lui	a4,0x1
    802005a0:	00e68733          	add	a4,a3,a4
    802005a4:	02e7b823          	sd	a4,48(a5)
    for(i=1;i<NR_TASKS;i++){
    802005a8:	fec42783          	lw	a5,-20(s0)
    802005ac:	0017879b          	addiw	a5,a5,1
    802005b0:	fef42623          	sw	a5,-20(s0)
    802005b4:	fec42783          	lw	a5,-20(s0)
    802005b8:	0007871b          	sext.w	a4,a5
    802005bc:	00300793          	li	a5,3
    802005c0:	ece7d6e3          	bge	a5,a4,8020048c <task_init+0xa4>
    }

    printk("...proc_init done!\n");
    802005c4:	00002517          	auipc	a0,0x2
    802005c8:	a5450513          	addi	a0,a0,-1452 # 80202018 <_srodata+0x18>
    802005cc:	5e1000ef          	jal	ra,802013ac <printk>
}
    802005d0:	00000013          	nop
    802005d4:	01813083          	ld	ra,24(sp)
    802005d8:	01013403          	ld	s0,16(sp)
    802005dc:	02010113          	addi	sp,sp,32
    802005e0:	00008067          	ret

00000000802005e4 <dummy>:

void dummy() {
    802005e4:	fd010113          	addi	sp,sp,-48
    802005e8:	02113423          	sd	ra,40(sp)
    802005ec:	02813023          	sd	s0,32(sp)
    802005f0:	03010413          	addi	s0,sp,48
    uint64 MOD = 1000000007;
    802005f4:	3b9ad7b7          	lui	a5,0x3b9ad
    802005f8:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <_start-0x448535f9>
    802005fc:	fcf43c23          	sd	a5,-40(s0)
    uint64 auto_inc_local_var = 0;
    80200600:	fe043423          	sd	zero,-24(s0)
    int last_counter = -1; // 记录上一个counter
    80200604:	fff00793          	li	a5,-1
    80200608:	fef42223          	sw	a5,-28(s0)
    int last_last_counter = -1; // 记录上上个counter
    8020060c:	fff00793          	li	a5,-1
    80200610:	fef42023          	sw	a5,-32(s0)
    while(1) {
        if (last_counter == -1 || current->counter != last_counter) {
    80200614:	fe442783          	lw	a5,-28(s0)
    80200618:	0007871b          	sext.w	a4,a5
    8020061c:	fff00793          	li	a5,-1
    80200620:	00f70e63          	beq	a4,a5,8020063c <dummy+0x58>
    80200624:	00004797          	auipc	a5,0x4
    80200628:	9ec78793          	addi	a5,a5,-1556 # 80204010 <current>
    8020062c:	0007b783          	ld	a5,0(a5)
    80200630:	0107b703          	ld	a4,16(a5)
    80200634:	fe442783          	lw	a5,-28(s0)
    80200638:	06f70063          	beq	a4,a5,80200698 <dummy+0xb4>
            last_last_counter = last_counter;
    8020063c:	fe442783          	lw	a5,-28(s0)
    80200640:	fef42023          	sw	a5,-32(s0)
            last_counter = current->counter;
    80200644:	00004797          	auipc	a5,0x4
    80200648:	9cc78793          	addi	a5,a5,-1588 # 80204010 <current>
    8020064c:	0007b783          	ld	a5,0(a5)
    80200650:	0107b783          	ld	a5,16(a5)
    80200654:	fef42223          	sw	a5,-28(s0)
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
    80200658:	fe843783          	ld	a5,-24(s0)
    8020065c:	00178793          	addi	a5,a5,1
    80200660:	fd843583          	ld	a1,-40(s0)
    80200664:	00078513          	mv	a0,a5
    80200668:	590000ef          	jal	ra,80200bf8 <__umoddi3>
    8020066c:	00050793          	mv	a5,a0
    80200670:	fef43423          	sd	a5,-24(s0)
            printk("[PID = %d] is running.",current->pid);
    80200674:	00004797          	auipc	a5,0x4
    80200678:	99c78793          	addi	a5,a5,-1636 # 80204010 <current>
    8020067c:	0007b783          	ld	a5,0(a5)
    80200680:	0207b783          	ld	a5,32(a5)
    80200684:	00078593          	mv	a1,a5
    80200688:	00002517          	auipc	a0,0x2
    8020068c:	9a850513          	addi	a0,a0,-1624 # 80202030 <_srodata+0x30>
    80200690:	51d000ef          	jal	ra,802013ac <printk>
    80200694:	0440006f          	j	802006d8 <dummy+0xf4>
        } else if((last_last_counter == 0 || last_last_counter == -1) && last_counter == 1) { // counter恒为1的情况
    80200698:	fe042783          	lw	a5,-32(s0)
    8020069c:	0007879b          	sext.w	a5,a5
    802006a0:	00078a63          	beqz	a5,802006b4 <dummy+0xd0>
    802006a4:	fe042783          	lw	a5,-32(s0)
    802006a8:	0007871b          	sext.w	a4,a5
    802006ac:	fff00793          	li	a5,-1
    802006b0:	f6f712e3          	bne	a4,a5,80200614 <dummy+0x30>
    802006b4:	fe442783          	lw	a5,-28(s0)
    802006b8:	0007871b          	sext.w	a4,a5
    802006bc:	00100793          	li	a5,1
    802006c0:	f4f71ae3          	bne	a4,a5,80200614 <dummy+0x30>
            last_counter = 0; 
    802006c4:	fe042223          	sw	zero,-28(s0)
            current->counter = 0;
    802006c8:	00004797          	auipc	a5,0x4
    802006cc:	94878793          	addi	a5,a5,-1720 # 80204010 <current>
    802006d0:	0007b783          	ld	a5,0(a5)
    802006d4:	0007b823          	sd	zero,16(a5)
        if (last_counter == -1 || current->counter != last_counter) {
    802006d8:	f3dff06f          	j	80200614 <dummy+0x30>

00000000802006dc <switch_to>:
    }
}

extern void __switch_to(struct task_struct* prev, struct task_struct* next);

void switch_to(struct task_struct* next) {
    802006dc:	fd010113          	addi	sp,sp,-48
    802006e0:	02113423          	sd	ra,40(sp)
    802006e4:	02813023          	sd	s0,32(sp)
    802006e8:	03010413          	addi	s0,sp,48
    802006ec:	fca43c23          	sd	a0,-40(s0)
    if (next != current) {
    802006f0:	00004797          	auipc	a5,0x4
    802006f4:	92078793          	addi	a5,a5,-1760 # 80204010 <current>
    802006f8:	0007b783          	ld	a5,0(a5)
    802006fc:	fd843703          	ld	a4,-40(s0)
    80200700:	04f70a63          	beq	a4,a5,80200754 <switch_to+0x78>
        printk("switch to [PID = %d]\n", next->pid);
    80200704:	fd843783          	ld	a5,-40(s0)
    80200708:	0207b783          	ld	a5,32(a5)
    8020070c:	00078593          	mv	a1,a5
    80200710:	00002517          	auipc	a0,0x2
    80200714:	93850513          	addi	a0,a0,-1736 # 80202048 <_srodata+0x48>
    80200718:	495000ef          	jal	ra,802013ac <printk>
        struct task_struct* prev = current;
    8020071c:	00004797          	auipc	a5,0x4
    80200720:	8f478793          	addi	a5,a5,-1804 # 80204010 <current>
    80200724:	0007b783          	ld	a5,0(a5)
    80200728:	fef43423          	sd	a5,-24(s0)
        current = next;
    8020072c:	00004797          	auipc	a5,0x4
    80200730:	8e478793          	addi	a5,a5,-1820 # 80204010 <current>
    80200734:	fd843703          	ld	a4,-40(s0)
    80200738:	00e7b023          	sd	a4,0(a5)
        __switch_to(prev, current);
    8020073c:	00004797          	auipc	a5,0x4
    80200740:	8d478793          	addi	a5,a5,-1836 # 80204010 <current>
    80200744:	0007b783          	ld	a5,0(a5)
    80200748:	00078593          	mv	a1,a5
    8020074c:	fe843503          	ld	a0,-24(s0)
    80200750:	a31ff0ef          	jal	ra,80200180 <__switch_to>
    }
}
    80200754:	00000013          	nop
    80200758:	02813083          	ld	ra,40(sp)
    8020075c:	02013403          	ld	s0,32(sp)
    80200760:	03010113          	addi	sp,sp,48
    80200764:	00008067          	ret

0000000080200768 <do_timer>:

void do_timer(void) {
    80200768:	ff010113          	addi	sp,sp,-16
    8020076c:	00113423          	sd	ra,8(sp)
    80200770:	00813023          	sd	s0,0(sp)
    80200774:	01010413          	addi	s0,sp,16
    if(current->counter == 0){
    80200778:	00004797          	auipc	a5,0x4
    8020077c:	89878793          	addi	a5,a5,-1896 # 80204010 <current>
    80200780:	0007b783          	ld	a5,0(a5)
    80200784:	0107b783          	ld	a5,16(a5)
    80200788:	00079663          	bnez	a5,80200794 <do_timer+0x2c>
        schedule();
    8020078c:	050000ef          	jal	ra,802007dc <schedule>
        return;
    80200790:	03c0006f          	j	802007cc <do_timer+0x64>
    }
    current->counter--;
    80200794:	00004797          	auipc	a5,0x4
    80200798:	87c78793          	addi	a5,a5,-1924 # 80204010 <current>
    8020079c:	0007b783          	ld	a5,0(a5)
    802007a0:	0107b703          	ld	a4,16(a5)
    802007a4:	fff70713          	addi	a4,a4,-1 # fff <_start-0x801ff001>
    802007a8:	00e7b823          	sd	a4,16(a5)
    if(current->counter > 0) return;
    802007ac:	00004797          	auipc	a5,0x4
    802007b0:	86478793          	addi	a5,a5,-1948 # 80204010 <current>
    802007b4:	0007b783          	ld	a5,0(a5)
    802007b8:	0107b783          	ld	a5,16(a5)
    802007bc:	00079663          	bnez	a5,802007c8 <do_timer+0x60>
    schedule();
    802007c0:	01c000ef          	jal	ra,802007dc <schedule>
    802007c4:	0080006f          	j	802007cc <do_timer+0x64>
    if(current->counter > 0) return;
    802007c8:	00000013          	nop
}
    802007cc:	00813083          	ld	ra,8(sp)
    802007d0:	00013403          	ld	s0,0(sp)
    802007d4:	01010113          	addi	sp,sp,16
    802007d8:	00008067          	ret

00000000802007dc <schedule>:


void schedule(void) {
    802007dc:	fd010113          	addi	sp,sp,-48
    802007e0:	02113423          	sd	ra,40(sp)
    802007e4:	02813023          	sd	s0,32(sp)
    802007e8:	03010413          	addi	s0,sp,48
    int i,next;
    struct task_struct *p = idle;
    802007ec:	00004797          	auipc	a5,0x4
    802007f0:	81c78793          	addi	a5,a5,-2020 # 80204008 <idle>
    802007f4:	0007b783          	ld	a5,0(a5)
    802007f8:	fcf43823          	sd	a5,-48(s0)
    uint64 c=0xffffffffffffffff;
    802007fc:	fff00793          	li	a5,-1
    80200800:	fef43023          	sd	a5,-32(s0)
    next = 0;
    80200804:	fe042423          	sw	zero,-24(s0)
    while (1) {
        i=1;
    80200808:	00100793          	li	a5,1
    8020080c:	fef42623          	sw	a5,-20(s0)
        while(i<NR_TASKS){
    80200810:	0780006f          	j	80200888 <schedule+0xac>
            p = task[i];
    80200814:	00004717          	auipc	a4,0x4
    80200818:	80470713          	addi	a4,a4,-2044 # 80204018 <task>
    8020081c:	fec42783          	lw	a5,-20(s0)
    80200820:	00379793          	slli	a5,a5,0x3
    80200824:	00f707b3          	add	a5,a4,a5
    80200828:	0007b783          	ld	a5,0(a5)
    8020082c:	fcf43823          	sd	a5,-48(s0)
            if(!(p->counter)) {
    80200830:	fd043783          	ld	a5,-48(s0)
    80200834:	0107b783          	ld	a5,16(a5)
    80200838:	00079a63          	bnez	a5,8020084c <schedule+0x70>
                i++;
    8020083c:	fec42783          	lw	a5,-20(s0)
    80200840:	0017879b          	addiw	a5,a5,1
    80200844:	fef42623          	sw	a5,-20(s0)
                continue;
    80200848:	0400006f          	j	80200888 <schedule+0xac>
            }
            if(p->state == TASK_RUNNING && p->counter < c){
    8020084c:	fd043783          	ld	a5,-48(s0)
    80200850:	0087b783          	ld	a5,8(a5)
    80200854:	02079463          	bnez	a5,8020087c <schedule+0xa0>
    80200858:	fd043783          	ld	a5,-48(s0)
    8020085c:	0107b783          	ld	a5,16(a5)
    80200860:	fe043703          	ld	a4,-32(s0)
    80200864:	00e7fc63          	bgeu	a5,a4,8020087c <schedule+0xa0>
				c = p->counter;
    80200868:	fd043783          	ld	a5,-48(s0)
    8020086c:	0107b783          	ld	a5,16(a5)
    80200870:	fef43023          	sd	a5,-32(s0)
                next = i;
    80200874:	fec42783          	lw	a5,-20(s0)
    80200878:	fef42423          	sw	a5,-24(s0)
            }
            i++;
    8020087c:	fec42783          	lw	a5,-20(s0)
    80200880:	0017879b          	addiw	a5,a5,1
    80200884:	fef42623          	sw	a5,-20(s0)
        while(i<NR_TASKS){
    80200888:	fec42783          	lw	a5,-20(s0)
    8020088c:	0007871b          	sext.w	a4,a5
    80200890:	00300793          	li	a5,3
    80200894:	f8e7d0e3          	bge	a5,a4,80200814 <schedule+0x38>
		}
		if (task[next]!=idle) break;
    80200898:	00003717          	auipc	a4,0x3
    8020089c:	78070713          	addi	a4,a4,1920 # 80204018 <task>
    802008a0:	fe842783          	lw	a5,-24(s0)
    802008a4:	00379793          	slli	a5,a5,0x3
    802008a8:	00f707b3          	add	a5,a4,a5
    802008ac:	0007b703          	ld	a4,0(a5)
    802008b0:	00003797          	auipc	a5,0x3
    802008b4:	75878793          	addi	a5,a5,1880 # 80204008 <idle>
    802008b8:	0007b783          	ld	a5,0(a5)
    802008bc:	0cf71863          	bne	a4,a5,8020098c <schedule+0x1b0>
		for(int i = 1; i < NR_TASKS; i++){
    802008c0:	00100793          	li	a5,1
    802008c4:	fcf42e23          	sw	a5,-36(s0)
    802008c8:	0b00006f          	j	80200978 <schedule+0x19c>
            if(i==1) printk("\n");
    802008cc:	fdc42783          	lw	a5,-36(s0)
    802008d0:	0007871b          	sext.w	a4,a5
    802008d4:	00100793          	li	a5,1
    802008d8:	00f71863          	bne	a4,a5,802008e8 <schedule+0x10c>
    802008dc:	00001517          	auipc	a0,0x1
    802008e0:	78450513          	addi	a0,a0,1924 # 80202060 <_srodata+0x60>
    802008e4:	2c9000ef          	jal	ra,802013ac <printk>
            task[i]->counter = task[i]->priority;
    802008e8:	00003717          	auipc	a4,0x3
    802008ec:	73070713          	addi	a4,a4,1840 # 80204018 <task>
    802008f0:	fdc42783          	lw	a5,-36(s0)
    802008f4:	00379793          	slli	a5,a5,0x3
    802008f8:	00f707b3          	add	a5,a4,a5
    802008fc:	0007b703          	ld	a4,0(a5)
    80200900:	00003697          	auipc	a3,0x3
    80200904:	71868693          	addi	a3,a3,1816 # 80204018 <task>
    80200908:	fdc42783          	lw	a5,-36(s0)
    8020090c:	00379793          	slli	a5,a5,0x3
    80200910:	00f687b3          	add	a5,a3,a5
    80200914:	0007b783          	ld	a5,0(a5)
    80200918:	01873703          	ld	a4,24(a4)
    8020091c:	00e7b823          	sd	a4,16(a5)
            printk("[PID = %d COUNTER = %d]\n", task[i]->pid, task[i]->counter);
    80200920:	00003717          	auipc	a4,0x3
    80200924:	6f870713          	addi	a4,a4,1784 # 80204018 <task>
    80200928:	fdc42783          	lw	a5,-36(s0)
    8020092c:	00379793          	slli	a5,a5,0x3
    80200930:	00f707b3          	add	a5,a4,a5
    80200934:	0007b783          	ld	a5,0(a5)
    80200938:	0207b683          	ld	a3,32(a5)
    8020093c:	00003717          	auipc	a4,0x3
    80200940:	6dc70713          	addi	a4,a4,1756 # 80204018 <task>
    80200944:	fdc42783          	lw	a5,-36(s0)
    80200948:	00379793          	slli	a5,a5,0x3
    8020094c:	00f707b3          	add	a5,a4,a5
    80200950:	0007b783          	ld	a5,0(a5)
    80200954:	0107b783          	ld	a5,16(a5)
    80200958:	00078613          	mv	a2,a5
    8020095c:	00068593          	mv	a1,a3
    80200960:	00001517          	auipc	a0,0x1
    80200964:	70850513          	addi	a0,a0,1800 # 80202068 <_srodata+0x68>
    80200968:	245000ef          	jal	ra,802013ac <printk>
		for(int i = 1; i < NR_TASKS; i++){
    8020096c:	fdc42783          	lw	a5,-36(s0)
    80200970:	0017879b          	addiw	a5,a5,1
    80200974:	fcf42e23          	sw	a5,-36(s0)
    80200978:	fdc42783          	lw	a5,-36(s0)
    8020097c:	0007871b          	sext.w	a4,a5
    80200980:	00300793          	li	a5,3
    80200984:	f4e7d4e3          	bge	a5,a4,802008cc <schedule+0xf0>
        i=1;
    80200988:	e81ff06f          	j	80200808 <schedule+0x2c>
		if (task[next]!=idle) break;
    8020098c:	00000013          	nop
        }
    }
    switch_to(task[next]);
    80200990:	00003717          	auipc	a4,0x3
    80200994:	68870713          	addi	a4,a4,1672 # 80204018 <task>
    80200998:	fe842783          	lw	a5,-24(s0)
    8020099c:	00379793          	slli	a5,a5,0x3
    802009a0:	00f707b3          	add	a5,a4,a5
    802009a4:	0007b783          	ld	a5,0(a5)
    802009a8:	00078513          	mv	a0,a5
    802009ac:	d31ff0ef          	jal	ra,802006dc <switch_to>
    802009b0:	00000013          	nop
    802009b4:	02813083          	ld	ra,40(sp)
    802009b8:	02013403          	ld	s0,32(sp)
    802009bc:	03010113          	addi	sp,sp,48
    802009c0:	00008067          	ret

00000000802009c4 <sbi_ecall>:
#include "sbi.h"

struct sbiret sbi_ecall(int ext, int fid, uint64 arg0,
                        uint64 arg1, uint64 arg2,
                        uint64 arg3, uint64 arg4,
                        uint64 arg5){
    802009c4:	f7010113          	addi	sp,sp,-144
    802009c8:	08813423          	sd	s0,136(sp)
    802009cc:	08913023          	sd	s1,128(sp)
    802009d0:	07213c23          	sd	s2,120(sp)
    802009d4:	07313823          	sd	s3,112(sp)
    802009d8:	09010413          	addi	s0,sp,144
    802009dc:	fac43023          	sd	a2,-96(s0)
    802009e0:	f8d43c23          	sd	a3,-104(s0)
    802009e4:	f8e43823          	sd	a4,-112(s0)
    802009e8:	f8f43423          	sd	a5,-120(s0)
    802009ec:	f9043023          	sd	a6,-128(s0)
    802009f0:	f7143c23          	sd	a7,-136(s0)
    802009f4:	00050793          	mv	a5,a0
    802009f8:	faf42623          	sw	a5,-84(s0)
    802009fc:	00058793          	mv	a5,a1
    80200a00:	faf42423          	sw	a5,-88(s0)
  long error,value;
  __asm__ volatile (
    80200a04:	fac42783          	lw	a5,-84(s0)
    80200a08:	00078913          	mv	s2,a5
    80200a0c:	fa842783          	lw	a5,-88(s0)
    80200a10:	00078993          	mv	s3,a5
    80200a14:	fa043e03          	ld	t3,-96(s0)
    80200a18:	f9843e83          	ld	t4,-104(s0)
    80200a1c:	f9043f03          	ld	t5,-112(s0)
    80200a20:	f8843f83          	ld	t6,-120(s0)
    80200a24:	f8043283          	ld	t0,-128(s0)
    80200a28:	f7843483          	ld	s1,-136(s0)
    80200a2c:	000e0513          	mv	a0,t3
    80200a30:	000e8593          	mv	a1,t4
    80200a34:	000f0613          	mv	a2,t5
    80200a38:	000f8693          	mv	a3,t6
    80200a3c:	00028713          	mv	a4,t0
    80200a40:	00048793          	mv	a5,s1
    80200a44:	00098813          	mv	a6,s3
    80200a48:	00090893          	mv	a7,s2
    80200a4c:	00000073          	ecall
    80200a50:	00050e93          	mv	t4,a0
    80200a54:	00058e13          	mv	t3,a1
    80200a58:	fdd43c23          	sd	t4,-40(s0)
    80200a5c:	fdc43823          	sd	t3,-48(s0)
        : [ext] "r" (ext), [fid] "r" (fid), [arg0] "r" (arg0), [arg1] "r" (arg1), 
        [arg2] "r" (arg2), [arg3] "r" (arg3), [arg4] "r" (arg4), [arg5] "r" (arg5)
        : "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "memory"
    );
    struct sbiret ret;
    ret.error = error;
    80200a60:	fd843783          	ld	a5,-40(s0)
    80200a64:	faf43823          	sd	a5,-80(s0)
    ret.value = value;
    80200a68:	fd043783          	ld	a5,-48(s0)
    80200a6c:	faf43c23          	sd	a5,-72(s0)

    return ret;
    80200a70:	fb043783          	ld	a5,-80(s0)
    80200a74:	fcf43023          	sd	a5,-64(s0)
    80200a78:	fb843783          	ld	a5,-72(s0)
    80200a7c:	fcf43423          	sd	a5,-56(s0)
    80200a80:	fc043703          	ld	a4,-64(s0)
    80200a84:	fc843783          	ld	a5,-56(s0)
    80200a88:	00070313          	mv	t1,a4
    80200a8c:	00078393          	mv	t2,a5
    80200a90:	00030713          	mv	a4,t1
    80200a94:	00038793          	mv	a5,t2
}
    80200a98:	00070513          	mv	a0,a4
    80200a9c:	00078593          	mv	a1,a5
    80200aa0:	08813403          	ld	s0,136(sp)
    80200aa4:	08013483          	ld	s1,128(sp)
    80200aa8:	07813903          	ld	s2,120(sp)
    80200aac:	07013983          	ld	s3,112(sp)
    80200ab0:	09010113          	addi	sp,sp,144
    80200ab4:	00008067          	ret

0000000080200ab8 <trap_handler>:
// trap.c 
#include "printk.h"
#include "clock.h"
#include "proc.h"

void trap_handler(unsigned long scause, unsigned long sepc) {
    80200ab8:	fe010113          	addi	sp,sp,-32
    80200abc:	00113c23          	sd	ra,24(sp)
    80200ac0:	00813823          	sd	s0,16(sp)
    80200ac4:	02010413          	addi	s0,sp,32
    80200ac8:	fea43423          	sd	a0,-24(s0)
    80200acc:	feb43023          	sd	a1,-32(s0)
    if((scause>>63) && ((scause<<1)>>1) == 5){
    80200ad0:	fe843783          	ld	a5,-24(s0)
    80200ad4:	0207d263          	bgez	a5,80200af8 <trap_handler+0x40>
    80200ad8:	fe843703          	ld	a4,-24(s0)
    80200adc:	fff00793          	li	a5,-1
    80200ae0:	0017d793          	srli	a5,a5,0x1
    80200ae4:	00f77733          	and	a4,a4,a5
    80200ae8:	00500793          	li	a5,5
    80200aec:	00f71663          	bne	a4,a5,80200af8 <trap_handler+0x40>
        //printk("[S] Supervisor Mode Timer Interrupt\n");
        clock_set_next_event();
    80200af0:	f30ff0ef          	jal	ra,80200220 <clock_set_next_event>
        do_timer();
    80200af4:	c75ff0ef          	jal	ra,80200768 <do_timer>
    }
    80200af8:	00000013          	nop
    80200afc:	01813083          	ld	ra,24(sp)
    80200b00:	01013403          	ld	s0,16(sp)
    80200b04:	02010113          	addi	sp,sp,32
    80200b08:	00008067          	ret

0000000080200b0c <start_kernel>:
#include "printk.h"
#include "sbi.h"

extern void test();

int start_kernel() {
    80200b0c:	fe010113          	addi	sp,sp,-32
    80200b10:	00113c23          	sd	ra,24(sp)
    80200b14:	00813823          	sd	s0,16(sp)
    80200b18:	02010413          	addi	s0,sp,32
    int n=2023;
    80200b1c:	7e700793          	li	a5,2023
    80200b20:	fef42623          	sw	a5,-20(s0)
    printk("ZJU Computer System II %d\n",n);
    80200b24:	fec42783          	lw	a5,-20(s0)
    80200b28:	00078593          	mv	a1,a5
    80200b2c:	00001517          	auipc	a0,0x1
    80200b30:	55c50513          	addi	a0,a0,1372 # 80202088 <_srodata+0x88>
    80200b34:	079000ef          	jal	ra,802013ac <printk>

    test();
    80200b38:	01c000ef          	jal	ra,80200b54 <test>

	return 0;
    80200b3c:	00000793          	li	a5,0
}
    80200b40:	00078513          	mv	a0,a5
    80200b44:	01813083          	ld	ra,24(sp)
    80200b48:	01013403          	ld	s0,16(sp)
    80200b4c:	02010113          	addi	sp,sp,32
    80200b50:	00008067          	ret

0000000080200b54 <test>:
#include "printk.h"
#include "defs.h"

void test() {
    80200b54:	fe010113          	addi	sp,sp,-32
    80200b58:	00813c23          	sd	s0,24(sp)
    80200b5c:	02010413          	addi	s0,sp,32
    unsigned long record_time = 0; 
    80200b60:	fe043423          	sd	zero,-24(s0)
    while (1) {
    80200b64:	0000006f          	j	80200b64 <test+0x10>

0000000080200b68 <__udivsi3>:
# define __divdi3 __divsi3
# define __moddi3 __modsi3
#else
FUNC_BEGIN (__udivsi3)
  /* Compute __udivdi3(a0 << 32, a1 << 32); cast result to uint32_t.  */
  sll    a0, a0, 32
    80200b68:	02051513          	slli	a0,a0,0x20
  sll    a1, a1, 32
    80200b6c:	02059593          	slli	a1,a1,0x20
  move   t0, ra
    80200b70:	00008293          	mv	t0,ra
  jal    HIDDEN_JUMPTARGET(__udivdi3)
    80200b74:	03c000ef          	jal	ra,80200bb0 <__hidden___udivdi3>
  sext.w a0, a0
    80200b78:	0005051b          	sext.w	a0,a0
  jr     t0
    80200b7c:	00028067          	jr	t0

0000000080200b80 <__umodsi3>:
FUNC_END (__udivsi3)

FUNC_BEGIN (__umodsi3)
  /* Compute __udivdi3((uint32_t)a0, (uint32_t)a1); cast a1 to uint32_t.  */
  sll    a0, a0, 32
    80200b80:	02051513          	slli	a0,a0,0x20
  sll    a1, a1, 32
    80200b84:	02059593          	slli	a1,a1,0x20
  srl    a0, a0, 32
    80200b88:	02055513          	srli	a0,a0,0x20
  srl    a1, a1, 32
    80200b8c:	0205d593          	srli	a1,a1,0x20
  move   t0, ra
    80200b90:	00008293          	mv	t0,ra
  jal    HIDDEN_JUMPTARGET(__udivdi3)
    80200b94:	01c000ef          	jal	ra,80200bb0 <__hidden___udivdi3>
  sext.w a0, a1
    80200b98:	0005851b          	sext.w	a0,a1
  jr     t0
    80200b9c:	00028067          	jr	t0

0000000080200ba0 <__divsi3>:

FUNC_ALIAS (__modsi3, __moddi3)

FUNC_BEGIN( __divsi3)
  /* Check for special case of INT_MIN/-1. Otherwise, fall into __divdi3.  */
  li    t0, -1
    80200ba0:	fff00293          	li	t0,-1
  beq   a1, t0, .L20
    80200ba4:	0a558c63          	beq	a1,t0,80200c5c <__moddi3+0x30>

0000000080200ba8 <__divdi3>:
#endif

FUNC_BEGIN (__divdi3)
  bltz  a0, .L10
    80200ba8:	06054063          	bltz	a0,80200c08 <__umoddi3+0x10>
  bltz  a1, .L11
    80200bac:	0605c663          	bltz	a1,80200c18 <__umoddi3+0x20>

0000000080200bb0 <__hidden___udivdi3>:
  /* Since the quotient is positive, fall into __udivdi3.  */

FUNC_BEGIN (__udivdi3)
  mv    a2, a1
    80200bb0:	00058613          	mv	a2,a1
  mv    a1, a0
    80200bb4:	00050593          	mv	a1,a0
  li    a0, -1
    80200bb8:	fff00513          	li	a0,-1
  beqz  a2, .L5
    80200bbc:	02060c63          	beqz	a2,80200bf4 <__hidden___udivdi3+0x44>
  li    a3, 1
    80200bc0:	00100693          	li	a3,1
  bgeu  a2, a1, .L2
    80200bc4:	00b67a63          	bgeu	a2,a1,80200bd8 <__hidden___udivdi3+0x28>
.L1:
  blez  a2, .L2
    80200bc8:	00c05863          	blez	a2,80200bd8 <__hidden___udivdi3+0x28>
  slli  a2, a2, 1
    80200bcc:	00161613          	slli	a2,a2,0x1
  slli  a3, a3, 1
    80200bd0:	00169693          	slli	a3,a3,0x1
  bgtu  a1, a2, .L1
    80200bd4:	feb66ae3          	bltu	a2,a1,80200bc8 <__hidden___udivdi3+0x18>
.L2:
  li    a0, 0
    80200bd8:	00000513          	li	a0,0
.L3:
  bltu  a1, a2, .L4
    80200bdc:	00c5e663          	bltu	a1,a2,80200be8 <__hidden___udivdi3+0x38>
  sub   a1, a1, a2
    80200be0:	40c585b3          	sub	a1,a1,a2
  or    a0, a0, a3
    80200be4:	00d56533          	or	a0,a0,a3
.L4:
  srli  a3, a3, 1
    80200be8:	0016d693          	srli	a3,a3,0x1
  srli  a2, a2, 1
    80200bec:	00165613          	srli	a2,a2,0x1
  bnez  a3, .L3
    80200bf0:	fe0696e3          	bnez	a3,80200bdc <__hidden___udivdi3+0x2c>
.L5:
  ret
    80200bf4:	00008067          	ret

0000000080200bf8 <__umoddi3>:
FUNC_END (__udivdi3)
HIDDEN_DEF (__udivdi3)

FUNC_BEGIN (__umoddi3)
  /* Call __udivdi3(a0, a1), then return the remainder, which is in a1.  */
  move  t0, ra
    80200bf8:	00008293          	mv	t0,ra
  jal   HIDDEN_JUMPTARGET(__udivdi3)
    80200bfc:	fb5ff0ef          	jal	ra,80200bb0 <__hidden___udivdi3>
  move  a0, a1
    80200c00:	00058513          	mv	a0,a1
  jr    t0
    80200c04:	00028067          	jr	t0
FUNC_END (__umoddi3)

  /* Handle negative arguments to __divdi3.  */
.L10:
  neg   a0, a0
    80200c08:	40a00533          	neg	a0,a0
  /* Zero is handled as a negative so that the result will not be inverted.  */
  bgtz  a1, .L12     /* Compute __udivdi3(-a0, a1), then negate the result.  */
    80200c0c:	00b04863          	bgtz	a1,80200c1c <__umoddi3+0x24>

  neg   a1, a1
    80200c10:	40b005b3          	neg	a1,a1
  j     HIDDEN_JUMPTARGET(__udivdi3)     /* Compute __udivdi3(-a0, -a1).  */
    80200c14:	f9dff06f          	j	80200bb0 <__hidden___udivdi3>
.L11:                /* Compute __udivdi3(a0, -a1), then negate the result.  */
  neg   a1, a1
    80200c18:	40b005b3          	neg	a1,a1
.L12:
  move  t0, ra
    80200c1c:	00008293          	mv	t0,ra
  jal   HIDDEN_JUMPTARGET(__udivdi3)
    80200c20:	f91ff0ef          	jal	ra,80200bb0 <__hidden___udivdi3>
  neg   a0, a0
    80200c24:	40a00533          	neg	a0,a0
  jr    t0
    80200c28:	00028067          	jr	t0

0000000080200c2c <__moddi3>:
FUNC_END (__divdi3)

FUNC_BEGIN (__moddi3)
  move   t0, ra
    80200c2c:	00008293          	mv	t0,ra
  bltz   a1, .L31
    80200c30:	0005ca63          	bltz	a1,80200c44 <__moddi3+0x18>
  bltz   a0, .L32
    80200c34:	00054c63          	bltz	a0,80200c4c <__moddi3+0x20>
.L30:
  jal    HIDDEN_JUMPTARGET(__udivdi3)    /* The dividend is not negative.  */
    80200c38:	f79ff0ef          	jal	ra,80200bb0 <__hidden___udivdi3>
  move   a0, a1
    80200c3c:	00058513          	mv	a0,a1
  jr     t0
    80200c40:	00028067          	jr	t0
.L31:
  neg    a1, a1
    80200c44:	40b005b3          	neg	a1,a1
  bgez   a0, .L30
    80200c48:	fe0558e3          	bgez	a0,80200c38 <__moddi3+0xc>
.L32:
  neg    a0, a0
    80200c4c:	40a00533          	neg	a0,a0
  jal    HIDDEN_JUMPTARGET(__udivdi3)    /* The dividend is hella negative.  */
    80200c50:	f61ff0ef          	jal	ra,80200bb0 <__hidden___udivdi3>
  neg    a0, a1
    80200c54:	40b00533          	neg	a0,a1
  jr     t0
    80200c58:	00028067          	jr	t0
FUNC_END (__moddi3)

#if __riscv_xlen == 64
  /* continuation of __divsi3 */
.L20:
  sll   t0, t0, 31
    80200c5c:	01f29293          	slli	t0,t0,0x1f
  bne   a0, t0, __divdi3
    80200c60:	f45514e3          	bne	a0,t0,80200ba8 <__divdi3>
  ret
    80200c64:	00008067          	ret

0000000080200c68 <int_mod>:
#include"math.h"
int int_mod(unsigned int v1,unsigned int v2){
    80200c68:	fd010113          	addi	sp,sp,-48
    80200c6c:	02813423          	sd	s0,40(sp)
    80200c70:	03010413          	addi	s0,sp,48
    80200c74:	00050793          	mv	a5,a0
    80200c78:	00058713          	mv	a4,a1
    80200c7c:	fcf42e23          	sw	a5,-36(s0)
    80200c80:	00070793          	mv	a5,a4
    80200c84:	fcf42c23          	sw	a5,-40(s0)
    unsigned long long m1=v1;
    80200c88:	fdc46783          	lwu	a5,-36(s0)
    80200c8c:	fef43423          	sd	a5,-24(s0)
    unsigned long long m2=v2;
    80200c90:	fd846783          	lwu	a5,-40(s0)
    80200c94:	fef43023          	sd	a5,-32(s0)
    m2<<=31;
    80200c98:	fe043783          	ld	a5,-32(s0)
    80200c9c:	01f79793          	slli	a5,a5,0x1f
    80200ca0:	fef43023          	sd	a5,-32(s0)
    while(m1>=v2){
    80200ca4:	02c0006f          	j	80200cd0 <int_mod+0x68>
        if(m2<m1){
    80200ca8:	fe043703          	ld	a4,-32(s0)
    80200cac:	fe843783          	ld	a5,-24(s0)
    80200cb0:	00f77a63          	bgeu	a4,a5,80200cc4 <int_mod+0x5c>
            m1-=m2;
    80200cb4:	fe843703          	ld	a4,-24(s0)
    80200cb8:	fe043783          	ld	a5,-32(s0)
    80200cbc:	40f707b3          	sub	a5,a4,a5
    80200cc0:	fef43423          	sd	a5,-24(s0)
        }
        m2>>=1;
    80200cc4:	fe043783          	ld	a5,-32(s0)
    80200cc8:	0017d793          	srli	a5,a5,0x1
    80200ccc:	fef43023          	sd	a5,-32(s0)
    while(m1>=v2){
    80200cd0:	fd846783          	lwu	a5,-40(s0)
    80200cd4:	fe843703          	ld	a4,-24(s0)
    80200cd8:	fcf778e3          	bgeu	a4,a5,80200ca8 <int_mod+0x40>
    }
    return m1;
    80200cdc:	fe843783          	ld	a5,-24(s0)
    80200ce0:	0007879b          	sext.w	a5,a5
}
    80200ce4:	00078513          	mv	a0,a5
    80200ce8:	02813403          	ld	s0,40(sp)
    80200cec:	03010113          	addi	sp,sp,48
    80200cf0:	00008067          	ret

0000000080200cf4 <int_mul>:

int int_mul(unsigned int v1,unsigned int v2){
    80200cf4:	fd010113          	addi	sp,sp,-48
    80200cf8:	02813423          	sd	s0,40(sp)
    80200cfc:	03010413          	addi	s0,sp,48
    80200d00:	00050793          	mv	a5,a0
    80200d04:	00058713          	mv	a4,a1
    80200d08:	fcf42e23          	sw	a5,-36(s0)
    80200d0c:	00070793          	mv	a5,a4
    80200d10:	fcf42c23          	sw	a5,-40(s0)
    unsigned long long res=0;
    80200d14:	fe043423          	sd	zero,-24(s0)
    while(v2&&v1){
    80200d18:	03c0006f          	j	80200d54 <int_mul+0x60>
        if(v2&1){
    80200d1c:	fd842783          	lw	a5,-40(s0)
    80200d20:	0017f793          	andi	a5,a5,1
    80200d24:	0007879b          	sext.w	a5,a5
    80200d28:	00078a63          	beqz	a5,80200d3c <int_mul+0x48>
            res+=v1;
    80200d2c:	fdc46783          	lwu	a5,-36(s0)
    80200d30:	fe843703          	ld	a4,-24(s0)
    80200d34:	00f707b3          	add	a5,a4,a5
    80200d38:	fef43423          	sd	a5,-24(s0)
        }
        v2>>=1;
    80200d3c:	fd842783          	lw	a5,-40(s0)
    80200d40:	0017d79b          	srliw	a5,a5,0x1
    80200d44:	fcf42c23          	sw	a5,-40(s0)
        v1<<=1;
    80200d48:	fdc42783          	lw	a5,-36(s0)
    80200d4c:	0017979b          	slliw	a5,a5,0x1
    80200d50:	fcf42e23          	sw	a5,-36(s0)
    while(v2&&v1){
    80200d54:	fd842783          	lw	a5,-40(s0)
    80200d58:	0007879b          	sext.w	a5,a5
    80200d5c:	00078863          	beqz	a5,80200d6c <int_mul+0x78>
    80200d60:	fdc42783          	lw	a5,-36(s0)
    80200d64:	0007879b          	sext.w	a5,a5
    80200d68:	fa079ae3          	bnez	a5,80200d1c <int_mul+0x28>
    }
    return res;
    80200d6c:	fe843783          	ld	a5,-24(s0)
    80200d70:	0007879b          	sext.w	a5,a5
}
    80200d74:	00078513          	mv	a0,a5
    80200d78:	02813403          	ld	s0,40(sp)
    80200d7c:	03010113          	addi	sp,sp,48
    80200d80:	00008067          	ret

0000000080200d84 <int_div>:

int int_div(unsigned int v1,unsigned int v2){
    80200d84:	fc010113          	addi	sp,sp,-64
    80200d88:	02813c23          	sd	s0,56(sp)
    80200d8c:	04010413          	addi	s0,sp,64
    80200d90:	00050793          	mv	a5,a0
    80200d94:	00058713          	mv	a4,a1
    80200d98:	fcf42623          	sw	a5,-52(s0)
    80200d9c:	00070793          	mv	a5,a4
    80200da0:	fcf42423          	sw	a5,-56(s0)
    unsigned long long m1=v1;
    80200da4:	fcc46783          	lwu	a5,-52(s0)
    80200da8:	fef43423          	sd	a5,-24(s0)
    unsigned long long m2=v2;
    80200dac:	fc846783          	lwu	a5,-56(s0)
    80200db0:	fef43023          	sd	a5,-32(s0)
    unsigned long long mask=(unsigned int)1<<31;
    80200db4:	00100793          	li	a5,1
    80200db8:	01f79793          	slli	a5,a5,0x1f
    80200dbc:	fcf43c23          	sd	a5,-40(s0)
    m2<<=31;
    80200dc0:	fe043783          	ld	a5,-32(s0)
    80200dc4:	01f79793          	slli	a5,a5,0x1f
    80200dc8:	fef43023          	sd	a5,-32(s0)
    unsigned long long res=0;
    80200dcc:	fc043823          	sd	zero,-48(s0)
    while(m1>=v2){
    80200dd0:	0480006f          	j	80200e18 <int_div+0x94>
        if(m2<m1){
    80200dd4:	fe043703          	ld	a4,-32(s0)
    80200dd8:	fe843783          	ld	a5,-24(s0)
    80200ddc:	02f77263          	bgeu	a4,a5,80200e00 <int_div+0x7c>
            m1-=m2;
    80200de0:	fe843703          	ld	a4,-24(s0)
    80200de4:	fe043783          	ld	a5,-32(s0)
    80200de8:	40f707b3          	sub	a5,a4,a5
    80200dec:	fef43423          	sd	a5,-24(s0)
            res|=mask;
    80200df0:	fd043703          	ld	a4,-48(s0)
    80200df4:	fd843783          	ld	a5,-40(s0)
    80200df8:	00f767b3          	or	a5,a4,a5
    80200dfc:	fcf43823          	sd	a5,-48(s0)
        }
        m2>>=1;
    80200e00:	fe043783          	ld	a5,-32(s0)
    80200e04:	0017d793          	srli	a5,a5,0x1
    80200e08:	fef43023          	sd	a5,-32(s0)
        mask>>=1;
    80200e0c:	fd843783          	ld	a5,-40(s0)
    80200e10:	0017d793          	srli	a5,a5,0x1
    80200e14:	fcf43c23          	sd	a5,-40(s0)
    while(m1>=v2){
    80200e18:	fc846783          	lwu	a5,-56(s0)
    80200e1c:	fe843703          	ld	a4,-24(s0)
    80200e20:	faf77ae3          	bgeu	a4,a5,80200dd4 <int_div+0x50>
    }
    return res;
    80200e24:	fd043783          	ld	a5,-48(s0)
    80200e28:	0007879b          	sext.w	a5,a5
    80200e2c:	00078513          	mv	a0,a5
    80200e30:	03813403          	ld	s0,56(sp)
    80200e34:	04010113          	addi	sp,sp,64
    80200e38:	00008067          	ret

0000000080200e3c <__muldi3>:
/* Our RV64 64-bit routine is equivalent to our RV32 32-bit routine.  */
# define __muldi3 __mulsi3
#endif

FUNC_BEGIN (__muldi3)
  mv     a2, a0
    80200e3c:	00050613          	mv	a2,a0
  li     a0, 0
    80200e40:	00000513          	li	a0,0
.L1:
  andi   a3, a1, 1
    80200e44:	0015f693          	andi	a3,a1,1
  beqz   a3, .L2
    80200e48:	00068463          	beqz	a3,80200e50 <__muldi3+0x14>
  add    a0, a0, a2
    80200e4c:	00c50533          	add	a0,a0,a2
.L2:
  srli   a1, a1, 1
    80200e50:	0015d593          	srli	a1,a1,0x1
  slli   a2, a2, 1
    80200e54:	00161613          	slli	a2,a2,0x1
  bnez   a1, .L1
    80200e58:	fe0596e3          	bnez	a1,80200e44 <__muldi3+0x8>
  ret
    80200e5c:	00008067          	ret

0000000080200e60 <putc>:
#include "printk.h"
#include "sbi.h"

void putc(char c) {
    80200e60:	fe010113          	addi	sp,sp,-32
    80200e64:	00113c23          	sd	ra,24(sp)
    80200e68:	00813823          	sd	s0,16(sp)
    80200e6c:	02010413          	addi	s0,sp,32
    80200e70:	00050793          	mv	a5,a0
    80200e74:	fef407a3          	sb	a5,-17(s0)
  sbi_ecall(SBI_PUTCHAR, 0, c, 0, 0, 0, 0, 0);
    80200e78:	fef44603          	lbu	a2,-17(s0)
    80200e7c:	00000893          	li	a7,0
    80200e80:	00000813          	li	a6,0
    80200e84:	00000793          	li	a5,0
    80200e88:	00000713          	li	a4,0
    80200e8c:	00000693          	li	a3,0
    80200e90:	00000593          	li	a1,0
    80200e94:	00100513          	li	a0,1
    80200e98:	b2dff0ef          	jal	ra,802009c4 <sbi_ecall>
}
    80200e9c:	00000013          	nop
    80200ea0:	01813083          	ld	ra,24(sp)
    80200ea4:	01013403          	ld	s0,16(sp)
    80200ea8:	02010113          	addi	sp,sp,32
    80200eac:	00008067          	ret

0000000080200eb0 <vprintfmt>:

static int vprintfmt(void(*putch)(char), const char *fmt, va_list vl) {
    80200eb0:	f2010113          	addi	sp,sp,-224
    80200eb4:	0c113c23          	sd	ra,216(sp)
    80200eb8:	0c813823          	sd	s0,208(sp)
    80200ebc:	0e010413          	addi	s0,sp,224
    80200ec0:	f2a43c23          	sd	a0,-200(s0)
    80200ec4:	f2b43823          	sd	a1,-208(s0)
    80200ec8:	f2c43423          	sd	a2,-216(s0)
    int in_format = 0, longarg = 0;
    80200ecc:	fe042623          	sw	zero,-20(s0)
    80200ed0:	fe042423          	sw	zero,-24(s0)
    size_t pos = 0;
    80200ed4:	fe043023          	sd	zero,-32(s0)
    for( ; *fmt; fmt++) {
    80200ed8:	4ac0006f          	j	80201384 <vprintfmt+0x4d4>
        if (in_format) {
    80200edc:	fec42783          	lw	a5,-20(s0)
    80200ee0:	0007879b          	sext.w	a5,a5
    80200ee4:	44078663          	beqz	a5,80201330 <vprintfmt+0x480>
            switch(*fmt) {
    80200ee8:	f3043783          	ld	a5,-208(s0)
    80200eec:	0007c783          	lbu	a5,0(a5)
    80200ef0:	0007879b          	sext.w	a5,a5
    80200ef4:	f9d7869b          	addiw	a3,a5,-99
    80200ef8:	0006871b          	sext.w	a4,a3
    80200efc:	01500793          	li	a5,21
    80200f00:	46e7ea63          	bltu	a5,a4,80201374 <vprintfmt+0x4c4>
    80200f04:	02069793          	slli	a5,a3,0x20
    80200f08:	0207d793          	srli	a5,a5,0x20
    80200f0c:	00279713          	slli	a4,a5,0x2
    80200f10:	00001797          	auipc	a5,0x1
    80200f14:	19478793          	addi	a5,a5,404 # 802020a4 <_srodata+0xa4>
    80200f18:	00f707b3          	add	a5,a4,a5
    80200f1c:	0007a783          	lw	a5,0(a5)
    80200f20:	0007871b          	sext.w	a4,a5
    80200f24:	00001797          	auipc	a5,0x1
    80200f28:	18078793          	addi	a5,a5,384 # 802020a4 <_srodata+0xa4>
    80200f2c:	00f707b3          	add	a5,a4,a5
    80200f30:	00078067          	jr	a5
                case 'l': { 
                    longarg = 1; 
    80200f34:	00100793          	li	a5,1
    80200f38:	fef42423          	sw	a5,-24(s0)
                    break; 
    80200f3c:	43c0006f          	j	80201378 <vprintfmt+0x4c8>
                }
                
                case 'x': {
                    long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    80200f40:	fe842783          	lw	a5,-24(s0)
    80200f44:	0007879b          	sext.w	a5,a5
    80200f48:	00078c63          	beqz	a5,80200f60 <vprintfmt+0xb0>
    80200f4c:	f2843783          	ld	a5,-216(s0)
    80200f50:	00878713          	addi	a4,a5,8
    80200f54:	f2e43423          	sd	a4,-216(s0)
    80200f58:	0007b783          	ld	a5,0(a5)
    80200f5c:	0140006f          	j	80200f70 <vprintfmt+0xc0>
    80200f60:	f2843783          	ld	a5,-216(s0)
    80200f64:	00878713          	addi	a4,a5,8
    80200f68:	f2e43423          	sd	a4,-216(s0)
    80200f6c:	0007a783          	lw	a5,0(a5)
    80200f70:	f8f43c23          	sd	a5,-104(s0)

                    int hexdigits = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1;
    80200f74:	fe842783          	lw	a5,-24(s0)
    80200f78:	0007879b          	sext.w	a5,a5
    80200f7c:	00078663          	beqz	a5,80200f88 <vprintfmt+0xd8>
    80200f80:	00f00793          	li	a5,15
    80200f84:	0080006f          	j	80200f8c <vprintfmt+0xdc>
    80200f88:	00700793          	li	a5,7
    80200f8c:	f8f42a23          	sw	a5,-108(s0)
                    for(int halfbyte = hexdigits; halfbyte >= 0; halfbyte--) {
    80200f90:	f9442783          	lw	a5,-108(s0)
    80200f94:	fcf42e23          	sw	a5,-36(s0)
    80200f98:	0840006f          	j	8020101c <vprintfmt+0x16c>
                        int hex = (num >> (4*halfbyte)) & 0xF;
    80200f9c:	fdc42783          	lw	a5,-36(s0)
    80200fa0:	0027979b          	slliw	a5,a5,0x2
    80200fa4:	0007879b          	sext.w	a5,a5
    80200fa8:	f9843703          	ld	a4,-104(s0)
    80200fac:	40f757b3          	sra	a5,a4,a5
    80200fb0:	0007879b          	sext.w	a5,a5
    80200fb4:	00f7f793          	andi	a5,a5,15
    80200fb8:	f8f42823          	sw	a5,-112(s0)
                        char hexchar = (hex < 10 ? '0' + hex : 'a' + hex - 10);
    80200fbc:	f9042783          	lw	a5,-112(s0)
    80200fc0:	0007871b          	sext.w	a4,a5
    80200fc4:	00900793          	li	a5,9
    80200fc8:	00e7cc63          	blt	a5,a4,80200fe0 <vprintfmt+0x130>
    80200fcc:	f9042783          	lw	a5,-112(s0)
    80200fd0:	0ff7f793          	zext.b	a5,a5
    80200fd4:	0307879b          	addiw	a5,a5,48
    80200fd8:	0ff7f793          	zext.b	a5,a5
    80200fdc:	0140006f          	j	80200ff0 <vprintfmt+0x140>
    80200fe0:	f9042783          	lw	a5,-112(s0)
    80200fe4:	0ff7f793          	zext.b	a5,a5
    80200fe8:	0577879b          	addiw	a5,a5,87
    80200fec:	0ff7f793          	zext.b	a5,a5
    80200ff0:	f8f407a3          	sb	a5,-113(s0)
                        putch(hexchar);
    80200ff4:	f8f44703          	lbu	a4,-113(s0)
    80200ff8:	f3843783          	ld	a5,-200(s0)
    80200ffc:	00070513          	mv	a0,a4
    80201000:	000780e7          	jalr	a5
                        pos++;
    80201004:	fe043783          	ld	a5,-32(s0)
    80201008:	00178793          	addi	a5,a5,1
    8020100c:	fef43023          	sd	a5,-32(s0)
                    for(int halfbyte = hexdigits; halfbyte >= 0; halfbyte--) {
    80201010:	fdc42783          	lw	a5,-36(s0)
    80201014:	fff7879b          	addiw	a5,a5,-1
    80201018:	fcf42e23          	sw	a5,-36(s0)
    8020101c:	fdc42783          	lw	a5,-36(s0)
    80201020:	0007879b          	sext.w	a5,a5
    80201024:	f607dce3          	bgez	a5,80200f9c <vprintfmt+0xec>
                    }
                    longarg = 0; in_format = 0; 
    80201028:	fe042423          	sw	zero,-24(s0)
    8020102c:	fe042623          	sw	zero,-20(s0)
                    break;
    80201030:	3480006f          	j	80201378 <vprintfmt+0x4c8>
                }
            
                case 'd': {
                    long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    80201034:	fe842783          	lw	a5,-24(s0)
    80201038:	0007879b          	sext.w	a5,a5
    8020103c:	00078c63          	beqz	a5,80201054 <vprintfmt+0x1a4>
    80201040:	f2843783          	ld	a5,-216(s0)
    80201044:	00878713          	addi	a4,a5,8
    80201048:	f2e43423          	sd	a4,-216(s0)
    8020104c:	0007b783          	ld	a5,0(a5)
    80201050:	0140006f          	j	80201064 <vprintfmt+0x1b4>
    80201054:	f2843783          	ld	a5,-216(s0)
    80201058:	00878713          	addi	a4,a5,8
    8020105c:	f2e43423          	sd	a4,-216(s0)
    80201060:	0007a783          	lw	a5,0(a5)
    80201064:	fcf43823          	sd	a5,-48(s0)
                    if (num < 0) {
    80201068:	fd043783          	ld	a5,-48(s0)
    8020106c:	0207d463          	bgez	a5,80201094 <vprintfmt+0x1e4>
                        num = -num; putch('-');
    80201070:	fd043783          	ld	a5,-48(s0)
    80201074:	40f007b3          	neg	a5,a5
    80201078:	fcf43823          	sd	a5,-48(s0)
    8020107c:	f3843783          	ld	a5,-200(s0)
    80201080:	02d00513          	li	a0,45
    80201084:	000780e7          	jalr	a5
                        pos++;
    80201088:	fe043783          	ld	a5,-32(s0)
    8020108c:	00178793          	addi	a5,a5,1
    80201090:	fef43023          	sd	a5,-32(s0)
                    }
                    int bits = 0;
    80201094:	fc042623          	sw	zero,-52(s0)
                    char decchar[25] = {'0', 0};
    80201098:	03000793          	li	a5,48
    8020109c:	f6f43023          	sd	a5,-160(s0)
    802010a0:	f6043423          	sd	zero,-152(s0)
    802010a4:	f6043823          	sd	zero,-144(s0)
    802010a8:	f6040c23          	sb	zero,-136(s0)
                    for (long tmp = num; tmp; bits++) {
    802010ac:	fd043783          	ld	a5,-48(s0)
    802010b0:	fcf43023          	sd	a5,-64(s0)
    802010b4:	0580006f          	j	8020110c <vprintfmt+0x25c>
                        decchar[bits] = (tmp % 10) + '0';
    802010b8:	fc043783          	ld	a5,-64(s0)
    802010bc:	00a00593          	li	a1,10
    802010c0:	00078513          	mv	a0,a5
    802010c4:	b69ff0ef          	jal	ra,80200c2c <__moddi3>
    802010c8:	00050793          	mv	a5,a0
    802010cc:	0ff7f793          	zext.b	a5,a5
    802010d0:	0307879b          	addiw	a5,a5,48
    802010d4:	0ff7f713          	zext.b	a4,a5
    802010d8:	fcc42783          	lw	a5,-52(s0)
    802010dc:	ff078793          	addi	a5,a5,-16
    802010e0:	008787b3          	add	a5,a5,s0
    802010e4:	f6e78823          	sb	a4,-144(a5)
                        tmp /= 10;
    802010e8:	fc043783          	ld	a5,-64(s0)
    802010ec:	00a00593          	li	a1,10
    802010f0:	00078513          	mv	a0,a5
    802010f4:	ab5ff0ef          	jal	ra,80200ba8 <__divdi3>
    802010f8:	00050793          	mv	a5,a0
    802010fc:	fcf43023          	sd	a5,-64(s0)
                    for (long tmp = num; tmp; bits++) {
    80201100:	fcc42783          	lw	a5,-52(s0)
    80201104:	0017879b          	addiw	a5,a5,1
    80201108:	fcf42623          	sw	a5,-52(s0)
    8020110c:	fc043783          	ld	a5,-64(s0)
    80201110:	fa0794e3          	bnez	a5,802010b8 <vprintfmt+0x208>
                    }

                    for (int i = bits; i >= 0; i--) {
    80201114:	fcc42783          	lw	a5,-52(s0)
    80201118:	faf42e23          	sw	a5,-68(s0)
    8020111c:	02c0006f          	j	80201148 <vprintfmt+0x298>
                        putch(decchar[i]);
    80201120:	fbc42783          	lw	a5,-68(s0)
    80201124:	ff078793          	addi	a5,a5,-16
    80201128:	008787b3          	add	a5,a5,s0
    8020112c:	f707c703          	lbu	a4,-144(a5)
    80201130:	f3843783          	ld	a5,-200(s0)
    80201134:	00070513          	mv	a0,a4
    80201138:	000780e7          	jalr	a5
                    for (int i = bits; i >= 0; i--) {
    8020113c:	fbc42783          	lw	a5,-68(s0)
    80201140:	fff7879b          	addiw	a5,a5,-1
    80201144:	faf42e23          	sw	a5,-68(s0)
    80201148:	fbc42783          	lw	a5,-68(s0)
    8020114c:	0007879b          	sext.w	a5,a5
    80201150:	fc07d8e3          	bgez	a5,80201120 <vprintfmt+0x270>
                    }
                    pos += bits + 1;
    80201154:	fcc42783          	lw	a5,-52(s0)
    80201158:	0017879b          	addiw	a5,a5,1
    8020115c:	0007879b          	sext.w	a5,a5
    80201160:	00078713          	mv	a4,a5
    80201164:	fe043783          	ld	a5,-32(s0)
    80201168:	00e787b3          	add	a5,a5,a4
    8020116c:	fef43023          	sd	a5,-32(s0)
                    longarg = 0; in_format = 0; 
    80201170:	fe042423          	sw	zero,-24(s0)
    80201174:	fe042623          	sw	zero,-20(s0)
                    break;
    80201178:	2000006f          	j	80201378 <vprintfmt+0x4c8>
                }

                case 'u': {
                    unsigned long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    8020117c:	fe842783          	lw	a5,-24(s0)
    80201180:	0007879b          	sext.w	a5,a5
    80201184:	00078c63          	beqz	a5,8020119c <vprintfmt+0x2ec>
    80201188:	f2843783          	ld	a5,-216(s0)
    8020118c:	00878713          	addi	a4,a5,8
    80201190:	f2e43423          	sd	a4,-216(s0)
    80201194:	0007b783          	ld	a5,0(a5)
    80201198:	0140006f          	j	802011ac <vprintfmt+0x2fc>
    8020119c:	f2843783          	ld	a5,-216(s0)
    802011a0:	00878713          	addi	a4,a5,8
    802011a4:	f2e43423          	sd	a4,-216(s0)
    802011a8:	0007a783          	lw	a5,0(a5)
    802011ac:	f8f43023          	sd	a5,-128(s0)
                    int bits = 0;
    802011b0:	fa042c23          	sw	zero,-72(s0)
                    char decchar[25] = {'0', 0};
    802011b4:	03000793          	li	a5,48
    802011b8:	f4f43023          	sd	a5,-192(s0)
    802011bc:	f4043423          	sd	zero,-184(s0)
    802011c0:	f4043823          	sd	zero,-176(s0)
    802011c4:	f4040c23          	sb	zero,-168(s0)
                    for (long tmp = num; tmp; bits++) {
    802011c8:	f8043783          	ld	a5,-128(s0)
    802011cc:	faf43823          	sd	a5,-80(s0)
    802011d0:	0580006f          	j	80201228 <vprintfmt+0x378>
                        decchar[bits] = (tmp % 10) + '0';
    802011d4:	fb043783          	ld	a5,-80(s0)
    802011d8:	00a00593          	li	a1,10
    802011dc:	00078513          	mv	a0,a5
    802011e0:	a4dff0ef          	jal	ra,80200c2c <__moddi3>
    802011e4:	00050793          	mv	a5,a0
    802011e8:	0ff7f793          	zext.b	a5,a5
    802011ec:	0307879b          	addiw	a5,a5,48
    802011f0:	0ff7f713          	zext.b	a4,a5
    802011f4:	fb842783          	lw	a5,-72(s0)
    802011f8:	ff078793          	addi	a5,a5,-16
    802011fc:	008787b3          	add	a5,a5,s0
    80201200:	f4e78823          	sb	a4,-176(a5)
                        tmp /= 10;
    80201204:	fb043783          	ld	a5,-80(s0)
    80201208:	00a00593          	li	a1,10
    8020120c:	00078513          	mv	a0,a5
    80201210:	999ff0ef          	jal	ra,80200ba8 <__divdi3>
    80201214:	00050793          	mv	a5,a0
    80201218:	faf43823          	sd	a5,-80(s0)
                    for (long tmp = num; tmp; bits++) {
    8020121c:	fb842783          	lw	a5,-72(s0)
    80201220:	0017879b          	addiw	a5,a5,1
    80201224:	faf42c23          	sw	a5,-72(s0)
    80201228:	fb043783          	ld	a5,-80(s0)
    8020122c:	fa0794e3          	bnez	a5,802011d4 <vprintfmt+0x324>
                    }

                    for (int i = bits; i >= 0; i--) {
    80201230:	fb842783          	lw	a5,-72(s0)
    80201234:	faf42623          	sw	a5,-84(s0)
    80201238:	02c0006f          	j	80201264 <vprintfmt+0x3b4>
                        putch(decchar[i]);
    8020123c:	fac42783          	lw	a5,-84(s0)
    80201240:	ff078793          	addi	a5,a5,-16
    80201244:	008787b3          	add	a5,a5,s0
    80201248:	f507c703          	lbu	a4,-176(a5)
    8020124c:	f3843783          	ld	a5,-200(s0)
    80201250:	00070513          	mv	a0,a4
    80201254:	000780e7          	jalr	a5
                    for (int i = bits; i >= 0; i--) {
    80201258:	fac42783          	lw	a5,-84(s0)
    8020125c:	fff7879b          	addiw	a5,a5,-1
    80201260:	faf42623          	sw	a5,-84(s0)
    80201264:	fac42783          	lw	a5,-84(s0)
    80201268:	0007879b          	sext.w	a5,a5
    8020126c:	fc07d8e3          	bgez	a5,8020123c <vprintfmt+0x38c>
                    }
                    pos += bits + 1;
    80201270:	fb842783          	lw	a5,-72(s0)
    80201274:	0017879b          	addiw	a5,a5,1
    80201278:	0007879b          	sext.w	a5,a5
    8020127c:	00078713          	mv	a4,a5
    80201280:	fe043783          	ld	a5,-32(s0)
    80201284:	00e787b3          	add	a5,a5,a4
    80201288:	fef43023          	sd	a5,-32(s0)
                    longarg = 0; in_format = 0; 
    8020128c:	fe042423          	sw	zero,-24(s0)
    80201290:	fe042623          	sw	zero,-20(s0)
                    break;
    80201294:	0e40006f          	j	80201378 <vprintfmt+0x4c8>
                }

                case 's': {
                    const char* str = va_arg(vl, const char*);
    80201298:	f2843783          	ld	a5,-216(s0)
    8020129c:	00878713          	addi	a4,a5,8
    802012a0:	f2e43423          	sd	a4,-216(s0)
    802012a4:	0007b783          	ld	a5,0(a5)
    802012a8:	faf43023          	sd	a5,-96(s0)
                    while (*str) {
    802012ac:	0300006f          	j	802012dc <vprintfmt+0x42c>
                        putch(*str);
    802012b0:	fa043783          	ld	a5,-96(s0)
    802012b4:	0007c703          	lbu	a4,0(a5)
    802012b8:	f3843783          	ld	a5,-200(s0)
    802012bc:	00070513          	mv	a0,a4
    802012c0:	000780e7          	jalr	a5
                        pos++; 
    802012c4:	fe043783          	ld	a5,-32(s0)
    802012c8:	00178793          	addi	a5,a5,1
    802012cc:	fef43023          	sd	a5,-32(s0)
                        str++;
    802012d0:	fa043783          	ld	a5,-96(s0)
    802012d4:	00178793          	addi	a5,a5,1
    802012d8:	faf43023          	sd	a5,-96(s0)
                    while (*str) {
    802012dc:	fa043783          	ld	a5,-96(s0)
    802012e0:	0007c783          	lbu	a5,0(a5)
    802012e4:	fc0796e3          	bnez	a5,802012b0 <vprintfmt+0x400>
                    }
                    longarg = 0; in_format = 0; 
    802012e8:	fe042423          	sw	zero,-24(s0)
    802012ec:	fe042623          	sw	zero,-20(s0)
                    break;
    802012f0:	0880006f          	j	80201378 <vprintfmt+0x4c8>
                }

                case 'c': {
                    char ch = (char)va_arg(vl,int);
    802012f4:	f2843783          	ld	a5,-216(s0)
    802012f8:	00878713          	addi	a4,a5,8
    802012fc:	f2e43423          	sd	a4,-216(s0)
    80201300:	0007a783          	lw	a5,0(a5)
    80201304:	f6f40fa3          	sb	a5,-129(s0)
                    putch(ch);
    80201308:	f7f44703          	lbu	a4,-129(s0)
    8020130c:	f3843783          	ld	a5,-200(s0)
    80201310:	00070513          	mv	a0,a4
    80201314:	000780e7          	jalr	a5
                    pos++;
    80201318:	fe043783          	ld	a5,-32(s0)
    8020131c:	00178793          	addi	a5,a5,1
    80201320:	fef43023          	sd	a5,-32(s0)
                    longarg = 0; in_format = 0; 
    80201324:	fe042423          	sw	zero,-24(s0)
    80201328:	fe042623          	sw	zero,-20(s0)
                    break;
    8020132c:	04c0006f          	j	80201378 <vprintfmt+0x4c8>
                }
                default:
                    break;
            }
        }
        else if(*fmt == '%') {
    80201330:	f3043783          	ld	a5,-208(s0)
    80201334:	0007c783          	lbu	a5,0(a5)
    80201338:	00078713          	mv	a4,a5
    8020133c:	02500793          	li	a5,37
    80201340:	00f71863          	bne	a4,a5,80201350 <vprintfmt+0x4a0>
          in_format = 1;
    80201344:	00100793          	li	a5,1
    80201348:	fef42623          	sw	a5,-20(s0)
    8020134c:	02c0006f          	j	80201378 <vprintfmt+0x4c8>
        }
        else {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
            putch(*fmt);
    80201350:	f3043783          	ld	a5,-208(s0)
    80201354:	0007c703          	lbu	a4,0(a5)
    80201358:	f3843783          	ld	a5,-200(s0)
    8020135c:	00070513          	mv	a0,a4
    80201360:	000780e7          	jalr	a5
            pos++;
    80201364:	fe043783          	ld	a5,-32(s0)
    80201368:	00178793          	addi	a5,a5,1
    8020136c:	fef43023          	sd	a5,-32(s0)
    80201370:	0080006f          	j	80201378 <vprintfmt+0x4c8>
                    break;
    80201374:	00000013          	nop
    for( ; *fmt; fmt++) {
    80201378:	f3043783          	ld	a5,-208(s0)
    8020137c:	00178793          	addi	a5,a5,1
    80201380:	f2f43823          	sd	a5,-208(s0)
    80201384:	f3043783          	ld	a5,-208(s0)
    80201388:	0007c783          	lbu	a5,0(a5)
    8020138c:	b40798e3          	bnez	a5,80200edc <vprintfmt+0x2c>
        }
    }
    return pos;
    80201390:	fe043783          	ld	a5,-32(s0)
    80201394:	0007879b          	sext.w	a5,a5
}
    80201398:	00078513          	mv	a0,a5
    8020139c:	0d813083          	ld	ra,216(sp)
    802013a0:	0d013403          	ld	s0,208(sp)
    802013a4:	0e010113          	addi	sp,sp,224
    802013a8:	00008067          	ret

00000000802013ac <printk>:



int printk(const char* s, ...) {
    802013ac:	f9010113          	addi	sp,sp,-112
    802013b0:	02113423          	sd	ra,40(sp)
    802013b4:	02813023          	sd	s0,32(sp)
    802013b8:	03010413          	addi	s0,sp,48
    802013bc:	fca43c23          	sd	a0,-40(s0)
    802013c0:	00b43423          	sd	a1,8(s0)
    802013c4:	00c43823          	sd	a2,16(s0)
    802013c8:	00d43c23          	sd	a3,24(s0)
    802013cc:	02e43023          	sd	a4,32(s0)
    802013d0:	02f43423          	sd	a5,40(s0)
    802013d4:	03043823          	sd	a6,48(s0)
    802013d8:	03143c23          	sd	a7,56(s0)
    int res = 0;
    802013dc:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
    802013e0:	04040793          	addi	a5,s0,64
    802013e4:	fcf43823          	sd	a5,-48(s0)
    802013e8:	fd043783          	ld	a5,-48(s0)
    802013ec:	fc878793          	addi	a5,a5,-56
    802013f0:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
    802013f4:	fe043783          	ld	a5,-32(s0)
    802013f8:	00078613          	mv	a2,a5
    802013fc:	fd843583          	ld	a1,-40(s0)
    80201400:	00000517          	auipc	a0,0x0
    80201404:	a6050513          	addi	a0,a0,-1440 # 80200e60 <putc>
    80201408:	aa9ff0ef          	jal	ra,80200eb0 <vprintfmt>
    8020140c:	00050793          	mv	a5,a0
    80201410:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
    80201414:	fec42783          	lw	a5,-20(s0)
}
    80201418:	00078513          	mv	a0,a5
    8020141c:	02813083          	ld	ra,40(sp)
    80201420:	02013403          	ld	s0,32(sp)
    80201424:	07010113          	addi	sp,sp,112
    80201428:	00008067          	ret

000000008020142c <rand>:

int initialize = 0;
int r[1000];
int t = 0;

uint64 rand() {
    8020142c:	ff010113          	addi	sp,sp,-16
    80201430:	00813423          	sd	s0,8(sp)
    80201434:	01010413          	addi	s0,sp,16
    // int i;
    t++;
    80201438:	00004797          	auipc	a5,0x4
    8020143c:	ba878793          	addi	a5,a5,-1112 # 80204fe0 <t>
    80201440:	0007a783          	lw	a5,0(a5)
    80201444:	0017879b          	addiw	a5,a5,1
    80201448:	0007871b          	sext.w	a4,a5
    8020144c:	00004797          	auipc	a5,0x4
    80201450:	b9478793          	addi	a5,a5,-1132 # 80204fe0 <t>
    80201454:	00e7a023          	sw	a4,0(a5)
    return t;
    80201458:	00004797          	auipc	a5,0x4
    8020145c:	b8878793          	addi	a5,a5,-1144 # 80204fe0 <t>
    80201460:	0007a783          	lw	a5,0(a5)
    // r[t + 344] = r[t + 344 - 31] + r[t + 344 - 3];
    
	// t++;

    // return (uint64)r[t - 1 + 344];
}
    80201464:	00078513          	mv	a0,a5
    80201468:	00813403          	ld	s0,8(sp)
    8020146c:	01010113          	addi	sp,sp,16
    80201470:	00008067          	ret

0000000080201474 <memset>:
#include "string.h"

void *memset(void *dst, int c, uint64 n) {
    80201474:	fc010113          	addi	sp,sp,-64
    80201478:	02813c23          	sd	s0,56(sp)
    8020147c:	04010413          	addi	s0,sp,64
    80201480:	fca43c23          	sd	a0,-40(s0)
    80201484:	00058793          	mv	a5,a1
    80201488:	fcc43423          	sd	a2,-56(s0)
    8020148c:	fcf42a23          	sw	a5,-44(s0)
    char *cdst = (char *)dst;
    80201490:	fd843783          	ld	a5,-40(s0)
    80201494:	fef43023          	sd	a5,-32(s0)
    for (uint64 i = 0; i < n; ++i)
    80201498:	fe043423          	sd	zero,-24(s0)
    8020149c:	0280006f          	j	802014c4 <memset+0x50>
        cdst[i] = c;
    802014a0:	fe043703          	ld	a4,-32(s0)
    802014a4:	fe843783          	ld	a5,-24(s0)
    802014a8:	00f707b3          	add	a5,a4,a5
    802014ac:	fd442703          	lw	a4,-44(s0)
    802014b0:	0ff77713          	zext.b	a4,a4
    802014b4:	00e78023          	sb	a4,0(a5)
    for (uint64 i = 0; i < n; ++i)
    802014b8:	fe843783          	ld	a5,-24(s0)
    802014bc:	00178793          	addi	a5,a5,1
    802014c0:	fef43423          	sd	a5,-24(s0)
    802014c4:	fe843703          	ld	a4,-24(s0)
    802014c8:	fc843783          	ld	a5,-56(s0)
    802014cc:	fcf76ae3          	bltu	a4,a5,802014a0 <memset+0x2c>

    return dst;
    802014d0:	fd843783          	ld	a5,-40(s0)
}
    802014d4:	00078513          	mv	a0,a5
    802014d8:	03813403          	ld	s0,56(sp)
    802014dc:	04010113          	addi	sp,sp,64
    802014e0:	00008067          	ret
