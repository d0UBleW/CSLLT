.model small
.stack 100h
.data
        count dw 0
        i dw 0
.code
main proc
        mov ah, 01h
        int 21h
        xor ah, ah
        sub al, 30h
        cmp al, 00h
        jg INIT
        mov ah, 4ch
        int 21h
INIT:
        mov count, ax
        mov cx, count
        add count, 01h
        mov dl, 0dh
        mov ah, 02h
        int 21h
        mov dl, 0ah
        mov ah, 02h
        int 21h

LOOP1:
        mov ax, count
        mov i, ax
        sub i, cx

LOOP2:
        mov dl, '*'
        mov ah, 02h
        int 21h
        sub i, 01h
        jnz LOOP2

        mov dl, 0dh
        mov ah, 02h
        int 21h
        mov dl, 0ah
        mov ah, 02h
        int 21h

        sub cx, 01h
        jnz LOOP1

        mov ah, 4ch
        int 21h
main endp
end main
