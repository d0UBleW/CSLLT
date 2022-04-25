.model small
.stack 100h
.data
    back db 00h
    rev db 00h
    CRLF db 0dh, 0ah, "$"
    SPC db 20h, "$"
    menuMsg db "Main Menu", 0dh, 0ah
         db "1. Number Patterns", 0dh, 0ah
         db "2. Design Patterns", 0dh, 0ah
         db "3. Box Patterns", 0dh, 0ah
         db "4. Nested Loop Patterns", 0dh, 0ah
         db "0. Exit", 0dh, 0ah, 0dh, 0ah
         db "choice> $"
    
    title1 db "Number Patterns", 0dh, 0ah
           db "===============", 0dh, 0ah, "$"

    errMsg db "Invalid choice", 0dh, 0ah, "$"
    anyMsg db "Press any key to continue$"

    choice db 02h
           db ?
           db 02h dup(0)

    inputPrompt db "Input [0-9]> $"

    input db 02h
          db ?
          db 02h dup(0)

.code
setup macro
    push bp
    mov bp, sp
endm

leaveret macro
    mov sp, bp
    pop bp
    ret
endm

output macro MESS
    mov ah, 09h
    lea dx, MESS
    int 21h
endm

anyKey macro
    output anyMsg
    mov ah, 01h
    int 21h
endm


main proc
    mov ax, @data
    mov ds, ax

    call menu

    mov ah, 4ch
    int 21h

main endp

menu proc
    setup
INIT:
    call clearScreen

    output menuMsg

    mov ah, 0ah
    lea dx, choice
    int 21h

    output CRLF

    lea si, [choice+02h]
    mov cx, '0'
    mov dx, '4'
    mov ax, [si]
    push cx
    push dx
    push ax
    call verify
    cmp ax, 00h
    je VALID
    call errorPop
    jmp INIT

VALID:
    lea si, [choice+02h]
    mov ax, [si]
    cmp al, '0'
    jne FIR
    jmp EN

FIR:
    cmp al, '1'
    jne SEC
    call numond
    jmp INIT

SEC:
    cmp al, '2'
    jne THI
    jmp INIT

THI:
    cmp al, '3'
    jne FOU
    jmp INIT

FOU:
    jmp INIT

EN:
    leaveret
    
menu endp

numond proc
    setup

L:
    call clearScreen
    output title1
    output inputPrompt

    lea dx, input
    mov ah, 0ah
    int 21h

    lea si, [input+02h]
    mov cx, '0'
    mov dx, '9'
    mov al, [si]
    push cx
    push dx
    push ax
    call verify
    cmp ax, 00h
    je STRT
    call errorPop
    jmp L

STRT:
    lea di, [input+02h]
    mov al, [di]
    sub al, '0'
    mov [di], al

    mov cl, 00h
    mov ch, 00h

    output CRLF
    
LOOP1:
    lea si, [input+02h]
    mov al, [si]
    sub al, ch
    mov bl, al

LOOP2:
    cmp bl, 00h
    jle LOOP3
    output SPC
    dec bl
    jmp LOOP2

LOOP3:
    mov dl, cl
    add dl, '0'
    mov ah, 02h
    int 21h

    lea si, back
    mov al, [si]
    cmp al, 01h
    je LOOP4

    inc cl
    cmp cl, ch
    jle LOOP3

    lea di, back
    mov al, 01h
    mov [di], al
    dec cl

LOOP4:
    dec cl
    cmp cl, 00h
    jge LOOP3

    mov cl, 00h

    lea di, back
    mov al, 00h
    mov [di], al

    output CRLF

    lea si, rev
    mov al, [si]
    cmp al, 01h
    je REVERSE

    inc ch
    lea si, [input+02h]
    mov al, [si]
    cmp ch, al
    jle LOOP1

    lea di, rev
    mov al, 01h
    mov [di], al
    dec ch
    jmp REVERSE

UPUP:
    jmp LOOP1

REVERSE:
    dec ch
    cmp ch, 00h
    jge UPUP

    lea di, rev
    mov al, 00h
    mov [di], al

    anyKey
    leaveret
numond endp

verify proc
    setup

    mov al, [bp+04h]
    mov ah, [bp+06h]
    cmp al, ah
    jg B
    mov ah, [bp+08h]
    cmp al, ah
    jl B
    mov ax, 00h
    jmp A
B:
    mov ax, 01h
A:
    leaveret

verify endp

clearScreen proc
    setup

    mov ax, 0600h
    mov bh, 07h
    mov cx, 0000h
    mov dx, 184fh ; 24 x 79 (rows x cols)
    int 10h

    mov ax, 0200h
    xor bh, bh
    xor dx, dx
    int 10h

    leaveret

clearScreen endp

errorPop proc
    setup

    mov ah, 09h
    lea dx, errMsg
    int 21h
    anyKey

    leaveret
errorPop endp

end main
