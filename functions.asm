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
    mov     rdi, 1              ; file descriptor of standard output
    mov     rax, 4              ; write syscall
    syscall

    pop     rsi
    pop     rdi
    pop     rdx
    ret

;;; print string with line feed
;;; expects address of string in rax
sprintlf:
    call    sprint

    push    rax                 ; store original rax
    mov     rax, 10             ; 10 is the ascii character for a line feed
    push    rax                 ; push the line feed onto the stack so we can get the address

    mov     rax, rsp            ; address of the message to write, rsp is a stack pointer
    call    sprint

    pop     rax                 ; remove line feed from the stack
    pop     rax                 ; restore original rax
    ret

;;; print integer (itoa)
;;; iprint(int number)
iprint:
    push    rax
    push    rcx
    push    rdx
    push    rsi
    mov     rcx, 0              ; how many bytes we need to print

divideloop:
    inc     rcx

    mov     rdx, 0              ; reminder is stored here
    mov     rsi, 10             ; we want to divide by 10
    idiv    rsi                 ; idiv divides rax by rsi, quotient part is in rax, reminder in rdx

    add     rdx, 48             ; convert rdx to it's ASCII representation
    push    rdx                 ; push string representation onto the stack
    cmp     rax, 0              ; can we divide again?
    jnz     divideloop

printloop:
    dec     rcx

    mov     rax, rsp            ; move the stack pointer into rax for printing
    push    rcx
    call    sprint
    pop     rcx
    pop     rax
    cmp     rcx, 0              ; did we print everything?
    jnz     printloop

    pop     rsi
    pop     rdx
    pop     rcx
    pop     rax
    ret

;;; exit program
exit:
    mov     rax, 1              ; exit syscall
    mov     rdi, 0              ; exit code 0
    syscall
