.model small
.stack 100h
.data
    ext             db 00h
    return          db 00h

    back            db 00h

    rev             db 00h

    CRLF            db 0dh, 0ah, "$"

    SPC             db 20h, "$"

    menuMsg         db 01h, " APU Assembly Festival Main Menu ", 02h, 0dh, 0ah
                    db "1. Number Patterns", 0dh, 0ah
                    db "2. Design Patterns", 0dh, 0ah
                    db "3. Box Patterns", 0dh, 0ah
                    db "4. Nested Loop Patterns", 0dh, 0ah
                    db "0. Exit", 0dh, 0ah, 0dh, 0ah
                    db "choice> $"

    title1          db "Number Patterns", 0dh, 0ah
                    db "===============", 0dh, 0ah, "$"

    title2          db "Design Patterns", 0dh, 0ah
                    db "===============", 0dh, 0ah, "$"

    title3          db "Box Patterns", 0dh, 0ah
                    db "============", 0dh, 0ah, "$"

    title4          db "Nested Loop Patterns", 0dh, 0ah
                    db "====================", 0dh, 0ah, "$"

    errMsg          db "Invalid input", 0dh, 0ah, "$"

    anyMsg          db "Press any key to continue$"

    inputNumPrompt  db "Input [0-9]> $"

    inputNumPrompt2 db "Input [1-9]> $"

    inputNum        db 02h
                    db ?
                    db 02h dup(0)

    inputNum2       db 02h
                    db ?
                    db 02h dup(0)

    inputNumPrompt3 db "Number of shapes [1-6]> $"

    inputNumPrompt4 db "Size [1-6]> $"

    inputStrPrompt  db "Input [max 10 chars.]> $"

    inputStr        db 0bh
                    db ?
                    db 0bh dup(0)

.code
prepare macro
    push bx
    push cx
    push dx
    push ax
endm

restore macro
    pop ax
    pop dx
    pop cx
    pop bx
endm

setup macro
    push bp
    mov bp, sp
endm

leaveret macro
    mov sp, bp
    pop bp
    ret
endm

output macro MESS
    mov ah, 09h
    lea dx, MESS
    int 21h
endm

anyKey macro
    output anyMsg
    mov ah, 01h
    int 21h
endm


main proc
    mov ax, @data
    mov ds, ax

    prepare
    call menu
    restore

    mov ah, 4ch
    int 21h

main endp

menu proc
    setup
INIT:
    prepare
    call clearScreen
    restore

    output menuMsg

    mov ax, '0'
    mov dx, '4'
    lea cx, [inputNum]
    prepare
    call getNumInput
    restore
    lea si, [return]
    mov ax, [si]
    cmp ax, 00h
    je VALID
    output CRLF
    prepare
    call errorPop
    restore
    jmp INIT

VALID:
    lea si, [inputNum+02h]
    mov ax, [si]
    cmp al, '0'
    jne FIR
    jmp EN

FIR:
    cmp al, '1'
    jne SEC
    prepare
    call numond
    restore
    jmp INIT

SEC:
    cmp al, '2'
    jne THI
    prepare
    call design
    restore
    jmp INIT

THI:
    cmp al, '3'
    jne FOU
    prepare
    call box
    restore 
    jmp INIT

FOU:
    prepare
    call triangle
    restore
    jmp INIT

EN:
    lea di, [ext]
    mov al, 01h
    mov [di], al
    prepare
    call clearScreen
    restore
    leaveret
    
menu endp

numond proc
    setup

NUMLBL1:
    prepare
    call clearScreen
    restore
    output title1
    output inputNumPrompt

    mov ax, '0'
    mov dx, '9'
    lea cx, [inputNum]
    prepare
    call getNumInput
    restore
    lea si, [return]
    mov ax, [si]
    cmp ax, 00h
    je NUMINIT
    output CRLF
    prepare
    call errorPop
    restore
    jmp NUMLBL1

NUMINIT:
    lea si, [inputNum+02h]
    mov al, [si]
    sub al, '0'
    mov [si], al

    mov cl, 00h ; col
    mov ch, 00h ; row

    output CRLF
    
NUMSPC1:
    ; calculate spaces
    lea si, [inputNum+02h]
    mov al, [si]
    sub al, ch
    mov bl, al

NUMSPC2:
    ; print spaces
    cmp bl, 00h
    jle NUMNUM
    output SPC
    dec bl
    jmp NUMSPC2

NUMNUM:
    mov dl, cl
    add dl, '0'
    mov al, dl
    prepare
    call printColor
    restore

    lea si, back
    mov al, [si]
    cmp al, 01h
    je NUMDEC

    ; increase num until it matches the current row number
    inc cl
    cmp cl, ch
    jle NUMNUM

    ; num matches the current row number
    lea di, back
    mov al, 01h
    mov [di], al
    dec cl

NUMDEC:
    ; decrease num until it reaches '0'
    dec cl
    cmp cl, 00h
    jge NUMNUM

    mov cl, 00h

    lea di, back
    mov al, 00h
    mov [di], al

    output CRLF

    lea si, rev
    mov al, [si]
    cmp al, 01h
    je NUMREV

    ; increment current row until it matches the user input number
    inc ch
    lea si, [inputNum+02h]
    mov al, [si]
    cmp ch, al
    jle NUMSPC1

    lea di, rev
    mov al, 01h
    mov [di], al
    dec ch
    jmp NUMREV

NUMTEMP:
    jmp NUMSPC1

NUMREV:
    ; decrement current row until it reaches '0'
    dec ch
    cmp ch, 00h
    jge NUMTEMP

    lea di, rev
    mov al, 00h
    mov [di], al

    anyKey
    leaveret
numond endp

design proc
    setup

DESLBL1:
    prepare
    call clearScreen
    restore
    output title2
    output inputNumPrompt4

    mov ax, '1'
    mov dx, '6'
    lea cx, [inputNum]
    prepare
    call getNumInput
    restore
    lea si, [return]
    mov ax, [si]
    cmp ax, 00h
    je DESINIT
    output CRLF
    prepare
    call errorPop
    restore
    jmp DESLBL1

DESINIT:
    output CRLF
    output inputNumPrompt3
    mov ax, '1'
    mov dx, '6'
    lea cx, [inputNum2]
    prepare
    call getNumInput
    restore
    lea si, [return]
    mov ax, [si]
    cmp ax, 00h
    je DESINIT2
    output CRLF
    prepare
    call errorPop
    restore
    jmp DESINIT

DESINIT2:
    output CRLF
    lea si, [inputNum+02h]
    mov al, [si]
    sub al, '0'
    mov [si], al
    mov bl, al
    mov cl, 00h

    lea si, [inputNum2+02h]
    mov al, [si]
    sub al, '0'
    mov [si], al
    mov bh, al
    mov ch, 00h

DESLBL2:
    mov dl, ch
    lea si, [inputNum+02h]
    mov al, [si]
    prepare
    call moveCursorColumn
    restore
    lea si, [inputNum+02h]
    mov al, [si]
    sub al, cl
    dec al
    mov dl, al
    mov al, ' '

    prepare
    call repeat
    restore

    mov dl, 01h
    mov al, '*'

    prepare
    call repeat
    restore

    mov dl, cl
    add dl, dl
    mov al, ' '

    prepare
    call repeat
    restore

    mov dl, 01h
    mov al, '*'

    prepare
    call repeat
    restore

    output CRLF

    lea si, [rev]
    mov al, [si]
    cmp al, 01h
    je DESREV

    dec bl
    inc cl
    cmp bl, 00h
    jg DESLBL2

    lea di, [rev]
    mov al, 01h
    mov [di], al
    inc bl
    dec cl
    jmp DESREV

DESTMP:
    lea si, [inputNum+02h]
    mov al, [si]
    prepare
    call resetCursorRow
    restore
DESTMP2:
    jmp DESLBL2

DESREV:
    inc bl
    dec cl
    lea si, [inputNum+02h]
    mov al, [si]
    cmp bl, al
    jle DESTMP2

    lea di, [rev]
    mov al, 00h
    mov [di], al
    mov cl, 00h

    ; mov ah, 03h
    ; mov bh, 00h
    ; int 10h

    lea si, [inputNum+02h]
    mov bl, [si]

    inc ch
    cmp ch, bh
    jl DESTMP

    anyKey
    leaveret
design endp

box proc
    setup

BOXSTART:
    prepare
    call clearScreen
    restore
    output title3
    output inputStrPrompt

    mov ah, 0ah
    lea dx, inputStr
    int 21h

    output CRLF

    mov cl, 00h
    mov ch, 01h

BOXLBL1:
    mov bl, cl
    xor bh, bh

    mov dl, [inputStr+bx+02h]
    mov al, dl
    prepare
    call printColor
    restore
    output SPC

    lea si, back
    mov al, [si]
    cmp al, 01h

    je BOXLBL3
    inc cl
    cmp cl, ch
    jl BOXLBL1
    
    lea di, back
    mov al, 01h
    mov [di], al

    push cx
    lea si, [inputStr+01h]
    mov cl, [si]
    sub cl, ch
    add cl, cl

BOXLBL2:
    dec cl
    cmp cl, 00h
    jl BOXRST
    mov dl, [inputStr+bx+02h]
    mov al, dl
    prepare
    call printColor
    restore
    output SPC
    jmp BOXLBL2

BOXRST:
    pop cx

BOXLBL3:
    dec cl
    cmp cl, 00h
    jge BOXLBL1

    lea di, back
    mov al, 00h
    mov [di], al

    mov cl, 00h
    output CRLF

    lea si, rev
    mov al, [si]
    cmp al, 01h
    je BOXREV
    inc ch
    lea si, [inputStr+01h]
    mov al, [si]
    cmp ch, al
    jle BOXTMP

    lea di, rev
    mov al, 01h
    mov [di], al
    jmp BOXREV

BOXTMP:
    jmp BOXLBL1

BOXREV:
    dec ch
    cmp ch, 00h
    jg BOXTMP

    lea di, rev
    mov al, 00h
    mov [di], al

    anyKey
    leaveret
box endp

triangle proc
    setup

TRILBL1:
    prepare
    call clearScreen
    restore
    output title4
    output inputNumPrompt2
    mov ax, '1'
    mov dx, '9'
    lea cx, [inputNum]
    prepare
    call getNumInput
    restore
    lea si, [return]
    mov ax, [si]
    cmp ax, 00h
    je TRIINIT
    output CRLF
    prepare
    call errorPop
    restore
    jmp TRILBL1

TRIINIT:
    output CRLF
    lea si, [inputNum+02h]
    mov al, [si]
    sub al, '0'
    mov [si], al
    mov bl, [si]
    xor bh, bh
    mov cl, 01h

TRI1:
    mov ch, bl
    mov dl, cl
    mov al, '*'

    prepare
    call repeat
    restore

    mov dl, ch
    mov al, ' '

    prepare
    call repeat
    restore

    mov dl, ch
    mov al, '*'

    prepare
    call repeat
    restore
    
    inc cl
    dec bl
    output CRLF
    cmp bl, 00h
    jg TRI1

    output CRLF

    lea si, [inputNum+02h]
    mov bl, [si]
    mov bh, '1'
    mov ch, 01h
    mov cl, '1'

TRI2:
    mov al, cl
    mov dl, ch

    prepare
    call printNum
    restore

    inc ch
    mov al, ' '
    mov dl, bl

    prepare
    call repeat
    restore

    mov al, bh
    mov dl, bl
    
    prepare
    call printNum
    restore

    inc bh
    dec bl
    output CRLF
    cmp bl, 00h
    jg TRI2

    anyKey

    leaveret
triangle endp

verify proc
    setup

    mov al, [bp+04h]
    mov ah, [bp+06h]
    cmp al, ah
    jg B
    mov ah, [bp+08h]
    cmp al, ah
    jl B
    mov ax, 00h
    jmp A
B:
    mov ax, 01h
A:
    leaveret

verify endp

clearScreen proc
    setup

    ; check exit
    lea si, [ext]
    mov al, [si]
    cmp al, 00h
    jne .RESETBG

    ; scroll up (AL = 0 : clear)
    mov ax, 0600h

    ; bg blue, fg light cyan
    mov bh, 1bh
    jmp .NXT

.RESETBG:
    ; scroll up (AL = 19h : scroll up 19h lines )
    mov ax, 0619h
    ; bg black, fg light gray
    mov bh, 07h

.NXT:
    ; CH (upper row) CL (left column)
    mov cx, 0000h
    ; DH (lower row) DL (right column)
    mov dx, 184fh ; 24 (18h) x 79 (4fh) (rows x cols)
    int 10h

    ; set cursor to top left
    mov ax, 0200h
    xor bh, bh
    ; DH (row) DL (col)
    xor dx, dx
    int 10h

    leaveret
clearScreen endp

errorPop proc
    setup

    mov ah, 09h
    lea dx, errMsg
    int 21h
    anyKey

    leaveret
errorPop endp

repeat proc
    setup

    mov cl, [bp+06h]
    xor ch, ch
    cmp cx, 00h
    je .STOP

L1:
    mov dl, [bp+04h]
    mov al, dl
    prepare
    call printColor
    restore
    loop L1

.STOP:
    leaveret
repeat endp

printNum proc
    setup

    mov dl, [bp+04h]
    mov cl, [bp+06h]
    xor ch, ch

L2:
    mov al, dl
    prepare
    call printColor
    restore
    ; mov ah, 02h
    ; int 21h
    inc dl
    loop L2

    leaveret
printNum endp

getNumInput proc
    setup

    mov dx, [bp+08h]
    mov ah, 0ah
    int 21h

    ; lea si, [inputNum+02h]
    mov cx, [bp+04h]
    mov dx, [bp+06h]
    mov si, [bp+08h]
    add si, 02h
    mov ax, [si]
    prepare
    call verify
    lea di, [return]
    mov [di], ax
    restore

    leaveret
getNumInput endp

printColor proc
    setup

    mov al, [bp+04h]
    mov bh, 0
    mov bl, al

.REPEAT:
    cmp bl, 1fh
    jle .LOWR
    sub bl, 07h
    jmp .REPEAT

.LOWR:
    cmp bl, 10h
    jge .OK
    add bl, 03h
    jmp .REPEAT

.OK:
    mov cx, 01h
    mov ah, 09h
    int 10h
    
    prepare
    call advanceCursor
    restore
    
    leaveret
printColor endp

advanceCursor proc
    setup

    mov ah, 03h
    mov bh, 00h
    int 10h

    mov ah, 02h
    inc dl
    int 10h

    leaveret
advanceCursor endp

resetCursorRow proc
    setup
    
    mov ah, 03h
    mov bh, 00h
    int 10h

    mov ch, [bp+04h]
    add ch, ch
    dec ch

    mov ah, 02h
    sub dh, ch
    int 10h

    leaveret

resetCursorRow endp

moveCursorColumn proc
    setup

    mov ah, 03h
    mov bh, 00h
    int 10h

    mov cl, [bp+04h]
    mov ch, [bp+06h]
    add cl, cl
    dec cl

.MCCLOOP:
    cmp ch, 00h
    jle .MCCLEAVE
    mov ah, 02h
    add dl, cl
    dec ch
    jmp .MCCLOOP

.MCCLEAVE:
    int 10h
    leaveret
moveCursorColumn endp

end main
