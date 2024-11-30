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
    mov     rcx, 0              ; set rcx to 0

nextnumber:
    inc     rcx                 ; increment

    mov     rax, rcx            ; store rcx in rax
    push    rcx
    call    iprintlf            ; print digit
    pop     rcx

    cmp     rcx, 10
    jne     nextnumber

    call    exit
