.model small
.stack 100h
.data
        i dw 0
        space dw 0
        ast dw 0
.code
main proc
        mov ax, @data
        mov ds, ax
        mov cx, 03h
        mov i, cx

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

        add i, 01h ; creates the mirror
        sub cx, 01h
        jnz LOOP1

        mov ah, 4ch
        int 21h
main endp
end main
