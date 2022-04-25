.model small
.stack 100h
.data
    menu    db "Main Menu", 0dh, 0ah
            db "1. Student Info", 0dh, 0ah
            db "2. Subject Info", 0dh, 0ah
            db "3. Marks Info", 0dh, 0ah
            db "4. Quit Program", 0dh, 0ah
            db "Enter Choice: $"

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 09h
    mov dx, offset menu
    int 21h

    mov ah, 1
    int 21h

    mov ah, 4ch
    int 21h
main endp
end
