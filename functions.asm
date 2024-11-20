;;; calculate string length
;;; result stored in rax
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

;;; exit program
exit:
    mov     rax, 1              ; exit syscall
    mov     rdi, 0              ; exit code 0
    syscall
