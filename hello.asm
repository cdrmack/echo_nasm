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
    ;; there might be some rsp alignment going on
    ;; argc migh be at [rsp] or [rsp+8]
    ;; I assume it was aligned if rsp stores 0 or a "big" number
    pop     rcx

    cmp     rcx, 0
    jz      aligned

    cmp     rcx, 10
    jg      aligned             ; if greater than 10 then I assume it's garbage

    jmp     stuff

aligned:
    pop     rcx

stuff:
    mov     rax, msg
    call    sprint

    mov     rax, rcx
    call    iprintlf

    call    exit

.data:
msg     db      'Number of arguments: ', 0
