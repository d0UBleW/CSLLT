.model small
.stack 100h
.code
main proc
    mov ah, 02h
    mov bl, 06h
    mov cl, 00h
    mov ch, 01h

top:
    inc cl;
    mov dl, 2ah
    int 21h

    cmp cl, ch
    jne top

    mov dl, 0dh
    int 21h

    mov dl, 0ah
    int 21h

    mov cl, 00h
    inc ch
    dec bl
    cmp bl, 00h
    jne top

    mov ah, 4ch
    int 21h
main endp
end main
