section .data
msg     db       'hello, world!', 10, 0

section .text
    global  _start

_start:
    mov     rbx, msg            ; move the address of msg into rbx
    mov     rax, rbx            ; move the address in rbx into rax

nextchar:
    cmp     byte [rax], 0       ; compare the byte pointed to by rax at this address against zero
    jz      finished            ; jump to `finished` if the zero flagged is set
    inc     rax
    jmp     nextchar

finished:
    sub     rax, rbx            ; subtract the address in rbx from the address in rax
                                ; the result is number of segments between them
                                ; stored inside rax

    mov     rdx, rax            ; message length
    mov     rax, 4              ; write syscall
    mov     rdi, 1              ; file descriptor of standard output
    mov     rsi, msg            ; address of the message to write
    syscall

    mov     rax, 1              ; exit syscall
    mov     rdi, 0              ; exit code 0
    syscall
