.model small
.stack 100h
.data
    msg db "Welcome to CSLLT class$"

.code
main proc
    mov ax, @data
    mov es, ax

    mov ah, 13h
    mov al, 00h
    mov bh, 00h ; start value of char, always 0
    mov bl, 2dh ; colour code
    mov cx, 0ah ; number of char to be displayed
    ; default screen 24 rows
    mov dh, 18h ; row
    mov dl, 19h ; col
    mov bp, offset msg
    int 10h

    mov ah, 4ch
    int 21h

main endp
end
