.model small
.stack 100h
.data
    msg1 db "Welcome to APU", 0dh, 0ah, "$"
    msg2 db "Good bye!$"

.code

main proc
    ; mov ax, SEG msg2
    ; mov ax, SEG msg1
    mov ax, @data
    mov ds, ax

    mov ah, 09h
    mov dx, OFFSET msg1
    int 21h

    mov dx, offset msg2
    int 21h

    mov ah, 4ch
    int 21h
main endp
end main
