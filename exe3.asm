.model small
.stack 200h
.code
main proc
    mov ah, 02h
    mov bl, 80h
    mov dl, 00h

top:
    int 21h
    inc dl
    dec bl
    cmp bl, 00h
    jge top

    mov ah, 4ch
    int 21h

main endp
end main
