;;; calculate string length
;;; result stored in rax
slen:
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

;;; print string
;;; expects address of string in rax
sprint:
    push    rdx
    push    rdi
    push    rsi

    push    rax
    call    slen                ; slen stores the result inside rax, we need to save it
    mov     rdx, rax            ; rdx now stores length of the string
    pop     rax

    mov     rsi, rax            ; address of the message to write
    mov     rax, 4              ; write syscall
    mov     rdi, 1              ; file descriptor of standard output
    syscall

    pop     rsi
    pop     rdi
    pop     rdx
    ret

;;; exit program
exit:
    mov     rax, 1              ; exit syscall
    mov     rdi, 0              ; exit code 0
    syscall
