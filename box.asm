.model small
.stack 100h

MAX = 10h

.data
    rev db 00h
    back db 00h
    buf db MAX
        db ?
        db MAX dup(0)

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 0ah
    lea dx, buf
    int 21h

    mov ah, 02h
    mov dl, 0ah
    int 21h
    mov dl, 0dh
    int 21h

    mov cl, 00h
    ; ch denotes the row
    mov ch, 01h

LOOP1:
    ; bl = cl
    mov bl, cl
    xor bh, bh

    ; dl = buf[cl+2]
    mov dl, buf[bx+2]
    mov ah, 02h
    int 21h
    mov dl, 20h
    int 21h

    ; cmp back, 01h
    lea si, back
    mov al, [si]
    cmp al, 01h

    je LOOP3
    inc cl
    cmp cl, ch
    jl LOOP1

    ; mov back, 01h
    lea di, back
    mov al, 01h
    mov [di], al

    ; cl = 2 * (len(input) - i-th row)
    push cx
    lea si, buf[1]
    mov cl, [si]
    sub cl, ch
    add cl, cl

LOOP2:
    dec cl
    cmp cl, 00h
    jl RESET
    mov ah, 02h
    mov dl, buf[bx+2]
    int 21h
    mov dl, 20h
    int 21h
    jmp LOOP2

RESET:
    pop cx

LOOP3:
    dec cl
    cmp cl, 00h
    jge LOOP1

    ; mov back, 00h
    lea di, back
    mov al, 00h
    mov [di], al

    mov cl, 00h

    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h

    lea si, rev
    mov al, [si]
    cmp al, 01h
    je REVERSE
    inc ch
    lea si, buf[1]
    mov al, [si]
    cmp ch, al
    jle LOOP1

    ; mov rev, 01h
    lea di, rev
    mov al, 01h
    mov [di], al

REVERSE:
    dec ch
    cmp ch, 00h
    jg LOOP1


    mov ah, 4ch
    int 21h
    
main endp
end main
