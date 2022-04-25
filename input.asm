.model small
.stack 400h

count = 50h

.data
    msg db ""

.code
main proc
    ; read a character from keyboard via DOS and echo out
    ; returns the character in `al` register
    ; mov ah, 01h
    ; int 21h

    ; print out the input character
    ; mov ah, 02h
    ; mov dl, al
    ; int 21h

    ; read a character from keyboard via BIOS
    ; mov ah, 00h
    ; int 16h

    ; display a character from `dl` parameter via DOS
    ; mov ah, 02h
    ; mov dl, al
    ; int 21h

    ; read input string
    mov ax, @data
    mov ds, ax

    mov ah, 0ah
    mov dx, offset msg
    int 21h

    mov ah, 02h
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h

    mov ah, 0ah
    mov dx, offset msg
    int 21h

    mov ah, 02h
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h

    ; print 5 bytes from msg
    mov ah, 40h
    mov bx, 1
    mov cx, 05h
    mov dx, offset msg
    int 21h

    mov ah, 4ch
    int 21h
main endp
end main
