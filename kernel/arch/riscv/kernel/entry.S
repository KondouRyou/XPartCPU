    .extern dummy
    .section .text.entry
    .align 2
    .globl _traps,__dummy,__switch_to
_traps:

    # YOUR CODE HERE
    # -----------

        # 1. save 32 registers and sepc to stack
    sd sp, -0x8(sp)
    sd ra, -0x10(sp)
    sd gp, -0x18(sp)
    sd tp, -0x20(sp)
    sd t0, -0x28(sp)
    sd t1, -0x30(sp)
    sd t2, -0x38(sp)
    sd t3, -0x40(sp)
    sd t4, -0x48(sp)
    sd t5, -0x50(sp)
    sd t6, -0x58(sp)
    sd a0, -0x60(sp)
    sd a1, -0x68(sp)
    sd a2, -0x70(sp)
    sd a3, -0x78(sp)
    sd a4, -0x80(sp)
    sd a5, -0x88(sp)
    sd a6, -0x90(sp)
    sd a7, -0x98(sp)
    sd s0, -0xa0(sp)
    sd s1, -0xa8(sp)
    sd s2, -0xb0(sp)
    sd s3, -0xb8(sp)
    sd s4, -0xc0(sp)
    sd s5, -0xc8(sp)
    sd s6, -0xd0(sp)
    sd s7, -0xd8(sp)
    sd s8, -0xe0(sp)
    sd s9, -0xe8(sp)
    sd s10, -0xf0(sp)
    sd s11, -0xf8(sp)
    csrr a1,sepc
    sd a1, -0x100(sp)
    addi sp, sp, -0x100

    # -----------

        # 2. call trap_handler
    csrr a0, scause
    call trap_handler

    # -----------

        # 3. restore sepc and 32 registers (x2(sp) should be restore last) from stack
    ld a1, 0x0(sp)
    csrw sepc, a1
    addi sp, sp, 0x8
    ld s11, 0x0(sp)
    ld s10, 0x8(sp)
    ld s9, 0x10(sp)
    ld s8, 0x18(sp)
    ld s7, 0x20(sp)
    ld s6, 0x28(sp)
    ld s5, 0x30(sp)
    ld s4, 0x38(sp)
    ld s3, 0x40(sp)
    ld s2, 0x48(sp)
    ld s1, 0x50(sp)
    ld s0, 0x58(sp)
    ld a7, 0x60(sp)
    ld a6, 0x68(sp)
    ld a5, 0x70(sp)
    ld a4, 0x78(sp)
    ld a3, 0x80(sp)
    ld a2, 0x88(sp)
    ld a1, 0x90(sp)
    ld a0, 0x98(sp)
    ld t6, 0xa0(sp)
    ld t5, 0xa8(sp)
    ld t4, 0xb0(sp)
    ld t3, 0xb8(sp)
    ld t2, 0xc0(sp)
    ld t1, 0xc8(sp)
    ld t0, 0xd0(sp)
    ld tp, 0xd8(sp)
    ld gp, 0xe0(sp)
    ld ra, 0xe8(sp)
    ld sp, 0xf0(sp)

    # -----------

        # 4. return from trap
    sret

    # -----------

__dummy:
    la a0, dummy
    csrw sepc, a0
    sret

__switch_to:
    # save state to prev process
    # YOUR CODE HERE
    sd ra,40(a0)
    sd sp,48(a0)
    sd s0,56(a0)
    sd s1,64(a0)
    sd s2,72(a0)
    sd s3,80(a0)
    sd s4,88(a0)
    sd s5,96(a0)
    sd s6,104(a0)
    sd s7,112(a0)
    sd s8,120(a0)
    sd s9,128(a0)
    sd s10,136(a0)
    sd s11,144(a0)

    # restore state from next process
    # YOUR CODE HERE
    ld s11,144(a1)
    ld s10,136(a1)
    ld s9,128(a1)
    ld s8,120(a1)
    ld s7,112(a1)
    ld s6,104(a1)
    ld s5,96(a1)
    ld s4,88(a1)
    ld s3,80(a1)
    ld s2,72(a1)
    ld s1,64(a1)
    ld s0,56(a1)
    ld sp,48(a1)
    ld ra,40(a1)

    ret