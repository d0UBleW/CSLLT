.model small
.stack 100h
.data
    count db 0
    num db '0'
    rev db 0
.code
main proc
    mov ax, @data
    mov ds, ax
    mov ah, 01h
    int 21h
    cmp al, '0'
    jl EXIT
    cmp al, '9'
    jg EXIT
    sub al, '0'
    jmp INIT
EXIT:
    mov ah, 4ch
    int 21h
INIT:
    mov count, al
    mov cl, 00h
    ; print CRLF
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov dl, 0ah
    mov ah, 02h
    int 21h

LOOP1:
    ; reset char to be displayed to '0'
    mov al, '0'
    mov num, al
    ; get the number of spaces to be displayed
    ; by subtracting input with current row
    mov al, count
    sub al, cl
    mov bl, al
    sub bl, 01h

LOOP2:
    ; print spaces
    cmp bl, 00h
    jle LOOP3
    mov dl, 20h
    mov ah, 02h
    int 21h
    sub bl, 01h
    jmp LOOP2

LOOP3:
    ; print num char increasingly until num is equal to current row
    mov dl, num
    mov ah, 02h
    int 21h
    add num, 01h
    mov al, cl
    add al, '0'
    cmp num, al
    jle LOOP3
    sub num, 01h

LOOP4:
    ; print num char decreasingly until num is equal to '0'
    sub num, 01h
    mov al, num
    cmp al, '0'
    jl LINE
    mov dl, num
    mov ah, 02h
    int 21h
    jmp LOOP4

LINE:
    ; print CRLF
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov dl, 0ah
    int 21h

    cmp rev, 01h
    je REVERSE
    add cl, 01h
    cmp cl, count
    jl LOOP1

    ; set rev to 1 after completing the upper side
    mov rev, 01h
    sub cl, 01h

REVERSE:
    sub cl, 01h
    cmp cl, 00h
    jge LOOP1

    mov ah, 4ch
    int 21h

main endp
end main
