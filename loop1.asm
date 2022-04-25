.model small
.stack 100h
.code
main proc
    mov cx, 05h
    mov ah, 02h

A:
    mov dl, 2ah ; '*'
    int 21h

    mov dl, 09h ; '\t'
    int 21h

    loop A

    mov dl, 0dh ; '\r'
    int 21h

    mov dl, 0ah ; '\n'
    int 21h

    mov dl, 0dh ; '\r'
    int 21h

    mov dl, 0ah ; '\n'
    int 21h

    mov cx, 08h

B:
    mov dl, 0c8h
    int 21h

    mov dl, 09h
    int 21h

    loop B

    mov dl, 0dh ; '\r'
    int 21h

    mov dl, 0ah ; '\n'
    int 21h

    mov ah, 4ch
    int 21h
main endp
end main
