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

    mov bl, buf[1]
    mov cl, 00h
    ; ch denotes the row
    mov ch, 01h

LOOP1:
    ; si = cl
    mov ax, cx
    xor ah, ah
    mov si, ax

    ; dl = buf[cl+2]
    mov dl, buf[si+2]
    mov ah, 02h
    int 21h
    mov dl, 20h
    int 21h

    ; cmp back, 01h
    lea di, back
    mov al, 01h
    cmp [di], al

    je LOOP3
    inc cl
    cmp cl, ch
    jl LOOP1

    ; mov back, 01h
    lea di, back
    mov al, 01h
    mov [di], al

    ; bh = 2 * (len(input) - i-th row)
    xor ax, ax
    mov al, bl
    sub al, ch
    add al, al
    mov bh, al

LOOP2:
    dec bh
    cmp bh, 00h
    jl LOOP3
    mov ah, 02h
    mov dl, buf[si+2]
    int 21h
    mov dl, 20h
    int 21h
    jmp LOOP2


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

    lea di, rev
    mov al, 01h
    cmp [di], al
    je REVERSE
    inc ch
    cmp ch, bl
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
