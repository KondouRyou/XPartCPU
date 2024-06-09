.extern start_kernel

.section .text.init
.globl _start,_ekernel
_start:

  li a0, 0x20
  csrs sie, a0

  li a2, 0x50000
  addi a0, zero, 0
  addi a1, zero, 0
  addi a3, zero, 0
  addi a4, zero, 0
  addi a5, zero, 0
  addi a6, zero, 0
  addi a7, zero, 0
  la sp, stack_top
  call sbi_ecall

  la a0, _traps
  csrw stvec, a0

  li t0, 0xa2
  csrw sstatus, t0

  call mm_init

  call task_init
  
  j start_kernel

.section .stack.entry
.globl stack_bottom
stack_bottom:
    .space 0x1000
.globl stack_top
stack_top:
