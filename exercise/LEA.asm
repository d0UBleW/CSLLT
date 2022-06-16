.model small
.stack 100h

.data
    sms db "Wilkommen", 0dh, 0ah
    sms1 db "https://github.com/d0UBleW", 0dh, 0ah
    sms2 db "First Name: "
    sms3 db "Middle Name: -", 0dh, 0ah, "Last Name: Wijaya", 0dh, 0ah
    inp1 db ""

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 40h
    mov bx, 01h
    mov cx, 0bh
    lea dx, [sms]
    int 21h

    mov ah, 40h ; set `ah` again since ax is overwritten by previous int
    mov bx, 01h
    mov cx, 1ch
    lea dx, [sms1]
    int 21h

    mov ah, 40h
    mov bx, 01h
    mov cx, 0ch
    lea dx, [sms2]
    int 21h

    mov ah, 0ah
    lea dx, [inp1]
    int 21h

    mov ah, 02h
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h

    mov ah, 40h
    mov bx, 01h
    mov cx, 23h
    lea dx, [sms3]
    int 21h

    mov ah, 40h
    mov bx, 01h
    mov cx, 0bh
    lea dx, [sms]
    int 21h

    mov ah, 09h
    lea dx, [inp1+2] ; our input from 0ah start from third byte
    int 21h

    mov ah, 4ch
    int 21h

main endp
end main
