.model small
.stack 100h

.data
    buf db 41h          ; buffer size
        db ?            ; actual input length
        db 41h dup(0)   ; input goes here

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 0ah
    lea dx, buf
    int 21h

    ; mov si, offset buf+1
    ; mov cl, [si]
    ; xor ch, ch
    ; inc cx
    ; add si, cx
    ; mov al, '$'
    ; mov [si], al

    mov ah, 02h
    mov dl, 0ah
    int 21h
    mov dl, 0dh
    int 21h

    mov ah, 40h
    mov bx, 01h
    ; lea si, [buf+1]    ; get address of input length
    mov cl, buf[1]        ; get the input length from the address
    xor ch, ch
    lea dx, buf[2]
    int 21h

    mov ah, 4ch
    int 21h


main endp
end main
