;;; Order of sections expected by the linker in FreeBSD:
;;;   .text: Executable code (first in memory).
;;; .rodata: Read-only data (constants).
;;;   .data: Initialized variables.
;;;    .bss: Uninitialized variables (zeroed by the OS).
;;;
;;; Syscall arguments in FreeBSD x86-64:
;;; rdi, rsi, rdx, r10, r8, r9
;;; Syscall number is placed in rax.


section .text
global  _start

_start:
    mov     rax, msg            ; move the address of msg into rax
    call    strlen

    mov     rdx, rax            ; strlen leaves the result inside rax, we need it inside rdx for the syscall
    mov     rax, 4              ; write syscall
    mov     rdi, 1              ; file descriptor of standard output
    mov     rsi, msg            ; address of the message to write
    syscall

    mov     rax, 1              ; exit syscall
    mov     rdi, 0              ; exit code 0
    syscall

strlen:
    push    rbx                 ; push the value in rbx onto the stack to preserve it while we use rbx inside this function
    mov     rbx, rax            ; move the address in rax into rbx

nextchar:
    cmp     byte [rax], 0       ; compare the byte pointed to by rax at this address against zero
    jz      finished            ; jump to `finished` if the zero flagged is set
    inc     rax
    jmp     nextchar

finished:
    sub     rax, rbx            ; subtract the address in rbx from the address in rax
                                ; the result is number of segments between them
                                ; stored inside rax
    pop     rbx                 ; pop the value on the stack back into rbx
    ret                         ; return to where the function was called

section .data
msg     db       'hello, world!', 10, 0
