.model small
.stack 100h
.code
main proc
    mov al, '@' ; char to be displayed
    mov bh, 0   ; start value of char, always 0
    mov bl, 19h ; color code
    mov cx, 2dh ; repeat char display 2dh times
    mov ah, 09h
    int 10h

    mov ah, 4ch
    int 21h
main endp
end
