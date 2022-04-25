.model small
.stack 100h
.data
    back db 0
    rev db 0
    buf db 02h
        db ?
        db 02h dup(0)

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 0ah
    lea dx, buf
    int 21h

    ; mov ah, 01h
    ; int 21h

    lea si, buf[2]

    ; cmp buf[2], '9'
    mov al, '9'
    cmp [si], al
    jg EXIT

    ; cmp buf[2], '0'
    mov al, '0'
    cmp [si], al
    jl EXIT

    sub [si], al
    jmp INIT

EXIT:
    mov ah, 4ch
    int 21h

INIT:
    mov cl, 00h
    mov ch, 00h

    ; print CRLF
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov dl, 0ah
    mov ah, 02h
    int 21h

LOOP1:
    ; get the number of spaces to be displayed
    ; by subtracting input with current row
    lea di, buf[2]
    mov al, [di]
    sub al, ch
    mov bl, al

LOOP2:
    ; print spaces
    cmp bl, 00h
    jle LOOP3
    mov dl, 20h
    mov ah, 02h
    int 21h
    dec bl
    jmp LOOP2

LOOP3:
    mov dl, cl
    add dl, '0'
    mov ah, 02h
    int 21h

    lea di, back
    mov al, 01h
    cmp [di], al
    je LOOP4

    inc cl
    cmp cl, ch
    jle LOOP3

    mov [di], al
    dec cl

LOOP4:
    dec cl
    cmp cl, 00h
    jge LOOP3

    mov cl, 00h
    mov al, 00h
    mov [di], al

LINE:
    ; print CRLF
    mov dl, 0dh
    mov ah, 02h
    int 21h
    mov dl, 0ah
    int 21h

    lea di, rev
    mov al, 01h
    cmp [di], al
    je REVERSE

    inc ch
    lea si, buf[2]
    cmp ch, [si]
    jle LOOP1

    ; set rev to 1 after completing the upper side
    mov [di], al
    dec ch

REVERSE:
    dec ch
    cmp ch, 00h
    jge LOOP1

    mov ah, 4ch
    int 21h

main endp
end main
