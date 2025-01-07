;;; Order of sections expected by the linker in FreeBSD:
;;;   .text: Executable code (first in memory).
;;; .rodata: Read-only data (constants).
;;;   .data: Initialized variables.
;;;    .bss: Uninitialized variables (zeroed by the OS).
;;;
;;; Syscall arguments in FreeBSD x86-64:
;;; rdi, rsi, rdx, r10, r8, r9
;;; Syscall number is placed in rax.

%include 'functions.asm'

section .text
global  _start

_start:
    ;; there might be some rsp alignment going on
    ;; argc migh be at [rsp] or [rsp+8]
    ;; [rdi] returns the correct number of arguments
    ;; by comparing rdi with rsp I can tell where argc is
    sub     rdi, rsp
    jz      stuff
    pop     rcx
    jz      stuff

stuff:
    pop     rcx                 ; store argc (top of the stack) in rcx
    pop     rdx                 ; store program name
    dec     rcx                 ; decrease rcx by 1 (ignore program name)
    jz      done                ; exit if there were no args

    pop     rax                 ; store address of string (program argument)
    mov     rcx, 0              ; counter to keep track of digits
    xor     rdx, rdx

nextdigit:
    xor     rbx, rbx            ; reset lower and upper bytes
    mov     bl, [rax+rcx]       ; store actual data in rbx
    cmp     bl, 48              ; 48 is ascii value for 0
    jl      done                ; jump if less
    cmp     bl, 57              ; 57 is ascii value for 9
    jg      done                ; jump if greater

    sub     bl, 48              ; convert ascii to decimal representation
    add     rdx, rbx

    inc     rcx
    jmp     nextdigit

done:
    mov     rax, rdx
    call    iprintlf
    call    exit
