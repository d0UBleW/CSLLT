.model small
.stack 100h
.code
main proc
    mov bl, 14h
    mov dl, '?'
    mov ah, 02h
top:
    int 21h
    dec bl
    cmp bl, 0
    jg top

    mov ah, 4ch
    int 21h
main endp
end main
