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

    mov     rdi, 0              ; file descriptor for standard input
    mov     rsi, sinput         ; buffer to store input
    mov     rdx, 255            ; how many bytes to read
    mov     rax, 3              ; read syscall
    syscall

    mov     rax, msg2
    call    sprint

    mov     rax, sinput
    call    sprint

    call    exit

section .data
msg1        db      'Enter your name: ', 0
msg2        db      'Hello, ', 0

section .bss
sinput:     resb    255         ; reserve 255 byte space for the user input string
