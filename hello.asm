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

poparg:
    pop     rax                 ; store address of string (program argument)

    ;; atoi start
    xor     rbx, rbx            ; reset lower and upper bytes
    mov     bl, [rax]           ; store actual data in rbx
    cmp     bl, 48              ; 48 is ascii value for 0
    jl      done                ; jump if less
    cmp     bl, 57              ; 57 is ascii value for 9
    jg      done                ; jump if greater

    sub     bl, 48              ; convert ascii to decimal representation
    mov     rax, rbx
    call    iprintlf
    ;; atoi end

    dec     rcx
    jnz     poparg

done:
    call    exit
