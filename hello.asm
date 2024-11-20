;;; Order of sections expected by the linker in FreeBSD:
;;;   .text: Executable code (first in memory).
;;; .rodata: Read-only data (constants).
;;;   .data: Initialized variables.
;;;    .bss: Uninitialized variables (zeroed by the OS).
;;;
;;; Syscall arguments in FreeBSD x86-64:
;;; rdi, rsi, rdx, r10, r8, r9
;;; Syscall number is placed in rax.

%include    'functions.asm'

section .text
    global  _start

_start:
    mov     rax, msg1
    call    sprint
    mov     rax, msg2
    call    sprint
    call    exit

section .data
    msg1    db  'hello, world!', 10, 0
    msg2    db  'bye, world!', 10, 0
