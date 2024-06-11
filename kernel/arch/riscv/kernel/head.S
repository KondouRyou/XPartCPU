.extern start_kernel, sbi_set_timer, mm_init, task_init
.extern setup_vm, setup_vm_final, early_pgtbl

  .section .text.init
  .globl _start
_start:
  # li t0, 0
  # csrw satp, t0
  la sp, stack_base
  # li t0, 0xffffffdf80000000
  # sub sp, sp, t0

  call setup_vm
  call relocate

  call mm_init
  call setup_vm_final
  call task_init

  # set stvec = _traps
  la t0, _traps
  csrw stvec, t0

  # set sie[STIE] = 1
  li t0, (1 << 5)
  csrs sie, t0

  # set first time interrupt
  rdtime a0
  li t0, 10000000
  add a0, a0, t0
  call sbi_set_timer

  # set sstatus[SIE] = 1
  li t0, (1 << 1)
  csrs sstatus, t0

  li a0, 2024
  j start_kernel

relocate:
  li t0, 0xffffffdf80000000
  add ra, ra, t0
  add sp, sp, t0

  li t0, 8
  slli t0, t0, 60
  la t1, early_pgtbl
  # li t2, 0xffffffdf80000000
  # sub t1, t1, t2
  srli t1, t1, 12
  or t0, t0, t1
  csrw satp, t0

  sfence.vma zero, zero

  fence.i

  ret


  .section .stack.entry
  .globl stack_base, stack_bound
stack_bound:
  .space 0x1000, 0x0
stack_base:
  #stack_top <- sp
