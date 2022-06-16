.model small
.stack 100h
.code
main proc
    mov ah, 02h
    mov bl, 01h
    ; int 21h
start:
    mov dl, bl
    int 21h
    add bl, 01h
    cmp bl, 5fh
    jle start

    mov ah, 4ch
    int 21h
main endp
end main
