.model small

.stack 100h

.data
msg db "Hello, world!", 0dh, 0ah, "$"
chat db "This is a string!"

.code
main PROC
    mov ax, @data
    mov ds, ax
    mov ah, 09h ; $ delimited string
    mov dx, OFFSET msg
    int 21h
    mov ah, 40h
    mov bx, 1
    mov cx, 11h
    mov dx, OFFSET chat
    int 21h
    .EXIT
    ; mov ah, 4Ch
    ; int 21h
main ENDP
END main
