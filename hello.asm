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
    sub     rcx, 1              ; decrease rcx by 1, ignore program name

    mov     rax, rdx
    call    sprintlf            ; print program name

    mov     rax, rcx
    call    iprintlf            ; print argc - 1

    ;; push    0
    ;; push    '---'
    ;; mov     rax, rsp
    ;; call    sprintlf

    pop     rax                 ; rax should point to string (program argument)
    ;; xor     rbx, rbx            ; reset lower and upper bytes
    mov     bl, [rax]           ; store actual data in rbx
    cmp     bl, 48              ; 48 is ascii value for 0
    jl      done                ; jump if less
    cmp     bl, 57              ; 57 is ascii value for 9
    jg      done                ; jump if greater

    sub     bl, 48              ; convert ascii to decimal representation
    mov     rax, rbx
    call    iprintlf

done:
    call    exit

;; nextarg:
;;     cmp     rcx, 0
;;     jz      nomoreargs

;;     pop     rax                 ; move argument from stack to rax
;;     call    atoi

;;     sub     rcx, 1
;;     jmp     nextarg


;;     ;; mov     rax, msg            ; rax stores pointer to msg
;;     ;; mov     rax, 8

;;     ;; mov     rdx, 0              ; reminder is stored here
;;     ;; mov     rsi, 10             ; we want to divide by 10
;;     ;; idiv    rsi                 ; divide rax by rsi, quotient part is in rax, reminder in rdx

;;     ;; add     rdx, 48             ; convert rdx to it's ASCII representation, start of atoi
;;     ;; mov     rax, rdx            ; move reminder to rax

;; nomoreargs:
;;     call    exit
