.model small
.stack 100h
.code
MAIN proc
    ; display a prompt
    mov ah, 2h  ; display a character function
    mov dl, '?' ; character '?' is displayed
    int 21h     ; call DOS to display
    mov dl, 41h
    int 21h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    mov dl, 'P'
    int 21h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    mov dl, 'U'
    int 21h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    mov dl, 'U'
    int 21h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    mov dl, 'U'
    int 21h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    mov dl, 'U'
    int 21h

    ; end program
    mov ah, 4Ch ; DOS exit function
    int 21h     ; exit to DOS
MAIN endp
    end MAIN
