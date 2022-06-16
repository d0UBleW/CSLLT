.model small
.stack 200h
.data
        count dw 0
        i dw 0
        space dw 0
        ast dw 0
        rev db 0
.code
main proc
        mov ax, @data
        mov ds, ax
        mov ah, 01h
        int 21h
        xor ah, ah
        sub al, 30h
        cmp ax, 00h
        jg INIT
        mov ah, 4ch
        int 21h
INIT:
        mov count, ax
        mov cx, count
        mov i, cx
        mov dl, 0dh
        mov ah, 02h
        int 21h
        mov dl, 0ah
        mov ah, 02h
        int 21h

LOOP1:
        mov space, cx
        mov ax, i
        sub ax, cx
        mov ast, ax

LOOP2:
        cmp space, 01h
        jle LOOP3
        mov dl, 20h
        mov ah, 02h
        int 21h
        sub space, 01h
        jmp LOOP2
LOOP3:
        mov dl, 2ah
        mov ah, 02h
        int 21h
        sub ast, 01h
        cmp ast, 00h
        jge LOOP3

        mov dl, 0dh
        mov ah, 02h
        int 21h
        mov dl, 0ah
        mov ah ,02h
        int 21h

        cmp rev, 00h
        jne REVERSE
        add i, 01h ; creates a diamond
        sub cx, 01h
        cmp cx, 00h
        jg LOOP1

        mov rev, 01h
        sub i, 01h
        add cx, 01h

REVERSE:
        sub i, 01h
        add cx, 01h
        cmp cx, count
        jle LOOP1

        mov ah, 4ch
        int 21h
main endp
end main
