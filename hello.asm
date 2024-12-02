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
    mov     rax, 42
    mov     rbx, 4
    div     rbx                 ; divide rax by rbx
    call    iprint              ; print quotient

    mov     rax, msg1
    call    sprint

    mov     rax, rdx            ; move remainder into rax
    call    iprintlf

    call    exit

section .data
msg1    db  ' remainder ', 0
