.model small
.stack 100h
.data
    ext             db 00h

    back            db 00h

    rev             db 00h

    CRLF            db 0dh, 0ah, "$"

    SPC             db 20h, "$"

    menuMsg         db 01h, " APU Assembly Festival Main Menu ", 02h, 0dh, 0ah
                    db "1. Number Patterns", 0dh, 0ah
                    db "2. Design Patterns", 0dh, 0ah
                    db "3. Box Patterns", 0dh, 0ah
                    db "4. Nested Loop Patterns", 0dh, 0ah
                    db "5. Event Information", 0dh, 0ah
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

    title5          db "Event Information", 0dh, 0ah
                    db "=================", 0dh, 0ah, "$"

    infoMsg         db "| Welcome to APU Assembly Festival  |", 0dh, 0ah
                    db "|                                   |", 0dh, 0ah
                    db "| In this event, you are invited to |", 0dh, 0ah
                    db "| explore about assembly language.  |", 0dh, 0ah
                    db "| You will be guided to write your  |", 0dh, 0ah
                    db "| own program in assembly language. |", 0dh, 0ah
                    db "|                                   |", 0dh, 0ah
                    db "| Come join us on:                  |", 0dh, 0ah
                    db "|     Date : 31 July 2022           |", 0dh, 0ah
                    db "|     Time : 13:00 - 18:00          |", 0dh, 0ah
                    db "|     Venue: APU Campus 3rd floor   |", 0dh, 0ah
                    db "$"

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
save macro
    push ax
    push bx
    push cx
    push dx
endm

restore macro
    pop dx
    pop cx
    pop bx
    pop ax
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

    save
    call menu
    restore

    mov ah, 4ch
    int 21h

main endp

menu proc
    setup
    ; allocate 2 bytes for getNumInput return value
    sub sp, 2h

INIT:
    save
    call clearScreen
    restore

    output menuMsg

    save
    lea si, [inputNum]
    push si
    mov ah, '5'
    mov al, '0'
    push ax
    call getNumInput
    mov [bp-02h], ax
    add sp, 4h
    restore
    cmp word ptr [bp-02h], 00h
    je VALID
    output CRLF
    save
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
    save
    call numond
    restore
    jmp INIT

SEC:
    cmp al, '2'
    jne THI
    save
    call design
    restore
    jmp INIT

THI:
    cmp al, '3'
    jne FOU
    save
    call box
    restore 
    jmp INIT

FOU:
    cmp al, '4'
    jne FIV
    save
    call triangle
    restore
    jmp INIT

FIV:
    save
    call info
    restore
    jmp INIT

EN:
    lea di, [ext]
    mov al, 01h
    mov [di], al
    save
    call clearScreen
    restore
    leaveret
    
menu endp

info proc
    setup

    save
    call clearScreen
    restore

    output title5
    output CRLF

    save
    mov ah, 25h
    mov al, 09h
    push ax
    call repeat
    add sp, 2h
    restore
    output CRLF

    output infoMsg

    save
    mov ah, 25h
    mov al, 09h
    push ax
    call repeat
    add sp, 2h
    restore
    output CRLF
    output CRLF

    anyKey

    leaveret
info endp

numond proc
    setup
    ; allocate 2 bytes for getNumInput return value
    sub sp, 2h

.NUM_START:
    save
    call clearScreen
    restore
    output title1
    output inputNumPrompt

    save
    lea si, [inputNum]
    push si
    mov ah, '9'
    mov al, '0'
    push ax
    call getNumInput
    mov [bp-02h], ax
    add sp, 4h
    restore
    cmp word ptr [bp-02h], 00h
    je .NUM_INIT
    output CRLF
    save
    call errorPop
    restore
    jmp .NUM_START

.NUM_INIT:
    lea si, [inputNum+02h]
    mov al, [si]
    sub al, '0'
    mov [si], al

    mov cl, 00h ; col starting from 0
    mov ch, 00h ; row starting from 0

    output CRLF
    
.NUM_SPC1:
    ; calculate spaces
    ; number of spaces = user input
    lea si, [inputNum+02h]
    mov al, [si]
    sub al, ch
    mov bl, al

.NUM_SPC2:
    ; print spaces
    cmp bl, 00h
    jle .NUM_PRINT
    output SPC
    dec bl
    jmp .NUM_SPC2

.NUM_PRINT:
    ; print num starting from 0 incrementally
    save
    mov al, cl
    add al, '0'
    push ax
    call printColor
    add sp, 2h
    restore

    lea si, back
    mov al, [si]
    cmp al, 01h
    je .NUM_DECR

    ; increase num until it matches the current row number
    inc cl
    cmp cl, ch
    jle .NUM_PRINT

    ; num matches the current row number
    lea di, back
    mov al, 01h
    mov [di], al
    dec cl

.NUM_DECR:
    ; decrease num until it reaches '0'
    dec cl
    cmp cl, 00h
    jge .NUM_PRINT

    ; reset num to 0
    mov cl, 00h

    ; reset `back` to print incrementally again
    lea di, back
    mov al, 00h
    mov [di], al

    output CRLF

    lea si, rev
    mov al, [si]
    cmp al, 01h
    je .NUM_REV

    ; increment current row and print pattern until it matches the user input
    ; number
    inc ch
    lea si, [inputNum+02h]
    mov al, [si]
    cmp ch, al
    jle .NUM_SPC1

    ; current row matches user input
    ; set `rev` to start printing the lower part
    lea di, rev
    mov al, 01h
    mov [di], al
    dec ch
    jmp .NUM_REV

.NUM_TMP:
    jmp .NUM_SPC1

.NUM_REV:
    ; decrement current row and print pattern until it reaches '0'
    dec ch
    cmp ch, 00h
    jge .NUM_TMP

    ; reset `rev`
    lea di, rev
    mov al, 00h
    mov [di], al

    anyKey
    leaveret
numond endp

design proc
    setup
    ; allocate 2 bytes for getNumInput return value
    sub sp, 2h

.DES_START:
    save
    call clearScreen
    restore

    output title2
    output inputNumPrompt4

    ; get the pattern size
    save
    lea si, [inputNum]
    push si
    mov ah, '6'
    mov al, '1'
    push ax
    call getNumInput
    mov [bp-02h], ax
    add sp, 4h
    restore
    cmp word ptr [bp-02h], 00h
    je .DES_INIT
    output CRLF
    save
    call errorPop
    restore
    jmp .DES_START

.DES_INIT:
    ; get the pattern length (number of diamond)
    output CRLF
    output inputNumPrompt3

    save
    lea si, [inputNum2]
    push si
    mov ah, '6'
    mov al, '1'
    push ax
    call getNumInput
    mov [bp-02h], ax
    add sp, 4h
    restore
    cmp word ptr [bp-02h], 00h
    je .DES_INIT2
    output CRLF
    save
    call errorPop
    restore
    jmp .DES_INIT

.DES_INIT2:
    output CRLF
    lea si, [inputNum+02h]
    mov al, [si]
    sub al, '0'
    mov [si], al ; size
    mov cl, 00h ; row

    lea si, [inputNum2+02h]
    mov al, [si]
    sub al, '0'
    mov [si], al ; number of shape
    mov ch, 00h ; n-th shape starting from 0

.DES_PAT:
    ; set cursor to print starting from n-th shape
    ; n-th shape starting column = ((2*size)-1)*n
    save
    mov ah, ch
    lea si, [inputNum+02h]
    mov al, [si]
    push ax
    call moveCursorColumn
    add sp, 2 
    restore

    ; print spaces
    ; num of spaces = size - row - 1
    save
    lea si, [inputNum+02h]
    mov al, [si]
    sub al, cl
    dec al
    mov ah, al
    mov al, ' '
    push ax
    call repeat
    add sp, 2h
    restore

    save
    mov ah, 01h
    mov al, '*'
    push ax
    call repeat
    add sp, 2h
    restore

    ; print spaces between '*'
    ; num of spaces = 2*row
    save
    mov ah, cl
    add ah, ah
    mov al, ' '
    push ax
    call repeat
    add sp, 2h
    restore

    save
    mov ah, 01h
    mov al, '*'
    push ax
    call repeat
    add sp, 2h
    restore

    output CRLF

    ; check if printing the mirror lower part
    lea si, [rev]
    mov al, [si]
    cmp al, 01h
    je .DES_REV

    ; on each iteration, increase row until it reaches user input on shape
    ; size
    lea si, [inputNum+02h]
    mov al, [si]
    inc cl
    cmp cl, al
    jl .DES_TMP2

    ; size reaches 0
    ; set `rev` to start printing the mirrow lower part
    lea di, [rev]
    mov al, 01h
    mov [di], al

    ; when printing the mirrow lower part, decrease our row to the point where
    ; it printed the mirroring row, i.e., when row = input-1
    dec cl
    jmp .DES_REV

.DES_TMP:
    ; move cursor back to the first row of the shape
    ; current cursor row - (2*size-1)
    save
    lea si, [inputNum+02h]
    mov al, [si]
    push ax
    call resetCursorRow
    add sp, 2h
    restore

.DES_TMP2:
    jmp .DES_PAT

.DES_REV:
    ; decrease `cl` until it reaches 0
    dec cl
    cmp cl, 00h
    jge .DES_TMP2

    ; reset `rev`
    lea di, [rev]
    mov al, 00h
    mov [di], al

    ; reset row
    mov cl, 00h

    ; check if we have printed according to the specified number of shapes
    inc ch
    lea si, [inputNum2+02h]
    mov al, [si]
    cmp ch, al
    jl .DES_TMP

    anyKey
    leaveret
design endp

box proc
    setup

.BOX_START:
    save
    call clearScreen
    restore
    output title3
    output inputStrPrompt

    mov ah, 0ah
    lea dx, inputStr
    int 21h

    output CRLF

    mov cl, 00h ; col starting from 0
    mov ch, 01h ; row starting from 1

.BOX_FORW:
    ; set the index of string to be printed in which the index is equal to
    ; the column
    mov bl, cl
    xor bh, bh

    save
    ; get character from the specified index
    mov dl, [inputStr+02h+bx]
    mov al, dl
    push ax
    call printColor
    add sp, 2h
    restore
    output SPC

    ; check if printing forward or backward
    lea si, back
    mov al, [si]
    cmp al, 01h
    je .BOX_BACKW

    ; move to the next character in the input string
    inc cl
    cmp cl, ch
    jl .BOX_FORW

    ; set `back` to printing backward
    lea di, back
    mov al, 01h
    mov [di], al

    ; store the current state of row and col
    push cx

    ; repeatedly print the last printed character
    ; since the box size is 2 times the input string length
    ; and we have printed the first `ch` character
    ; we can take the input string length subtracts it with the number of
    ; character we have printed, then multiply it by 2
    lea si, [inputStr+01h]
    mov cl, [si]
    sub cl, ch
    add cl, cl

.BOX_REP:
    dec cl
    cmp cl, 00h
    jl .BOX_RSTCX
    save
    mov dl, [inputStr+bx+02h]
    mov al, dl
    push ax
    call printColor
    add sp, 2h
    restore
    output SPC
    jmp .BOX_REP

.BOX_RSTCX:
    pop cx

.BOX_BACKW:
    ; now to print backward, we only need to do the opposite,
    ; i.e., decrement cl
    dec cl
    cmp cl, 00h
    jge .BOX_FORW

    ; reset `back` to print forward
    lea di, back
    mov al, 00h
    mov [di], al
    mov cl, 00h
    output CRLF

    ; check if printing the mirror lower part
    lea si, rev
    mov al, [si]
    cmp al, 01h
    je .BOX_REV

    ; increase the first `ch` character to be printed by 1
    inc ch

    ; check if we have printed the whole string
    lea si, [inputStr+01h]
    mov al, [si]
    cmp ch, al
    jle .BOX_TMP

    ; after the whole string is printed,
    ; set to printing the mirror lower part
    lea di, rev
    mov al, 01h
    mov [di], al
    jmp .BOX_REV

.BOX_TMP:
    jmp .BOX_FORW

.BOX_REV:
    ; to print the mirror lower part, just do the opposite of
    ; increasing the first `ch` character to be printed by 1,
    ; i.e., decrease the first `ch` character to be printed by 1
    dec ch
    cmp ch, 00h
    jg .BOX_TMP

    ; reset `rev` value
    lea di, rev
    mov al, 00h
    mov [di], al

    anyKey
    leaveret
box endp

triangle proc
    setup
    ; allocate 2 bytes for getNumInput return value
    sub sp, 2h

.TRI_START:
    save
    call clearScreen
    restore

    output title4
    output inputNumPrompt2

    ; get input between 1 and 9 inclusively
    save
    lea si, [inputNum]
    push si
    mov ah, '9'
    mov al, '1'
    push ax
    call getNumInput
    mov [bp-02h], ax
    add sp, 4h
    restore
    cmp word ptr [bp-02h], 00h
    je .TRI_INIT

    output CRLF
    save
    call errorPop
    restore
    jmp .TRI_START

.TRI_INIT:
    output CRLF

    lea si, [inputNum+02h]
    mov al, [si]
    sub al, '0'
    mov [si], al

    mov bl, [si] ; triangle height
    xor bh, bh
    mov cl, 01h ; left-side triangle starting length

.TRI_AST:
    mov ch, bl ; right-side triangle starting length

    ; print left-side triangle
    save
    ; print '*' as many as the specified left-side length
    mov ah, cl
    mov al, '*'
    push ax
    call repeat
    add sp, 2h
    restore

    ; print spaces
    save
    mov ah, 28h
    sub ah, cl
    mov al, ' '
    push ax
    call repeat
    add sp, 2h
    restore

    ; print right-side triangle
    save
    ; print '*' as many as the specified right-side length
    mov ah, ch
    mov al, '*'
    push ax
    call repeat
    add sp, 2h
    restore
    
    ; increase left-side length
    inc cl
    ; decrease right-side length
    dec bl
    output CRLF
    cmp bl, 00h
    jg .TRI_AST

    output CRLF
    output CRLF

    lea si, [inputNum+02h]
    mov bh, [si] ; right-side triangle num of digit
    mov bl, '1' ; right-side triangle starting digit
    mov ch, 01h ; left-side triangle num of digit
    mov cl, '1' ; left-side triangle starting digit

.TRI_NUM:
    ; print left-side triangle where the starting digit is always 1
    save
    ; reset left-side triangle starting digit to 1
    mov al, cl
    ; print a sequence starting from digit 1 with difference equal to +1 and
    ; sequence length equal to `ch`
    mov ah, ch
    push ax
    call printNum
    add sp, 2h
    restore

    save
    mov al, ' '
    mov ah, 28h
    sub ah, ch
    push ax
    call repeat
    add sp, 2h
    restore
    
    save
    ; set starting digit of right-side triangle
    mov al, bl
    ; print a sequence starting from digit `bh` with difference equal to +1
    ; and sequence length equal to `bl`
    mov ah, bh
    push ax
    call printNum
    add sp, 2h
    restore

    ; increment left-side triangle num of digit to be printed
    inc ch
    ; increment right-side triangle starting digit by 1
    inc bl
    ; decrement right-side triangle num of digit to be printed
    dec bh
    output CRLF
    cmp bh, 00h
    jg .TRI_NUM

    anyKey

    leaveret
triangle endp

verify proc
    ; first param  (bp+04h): number to be verified
    ; second param (bp+05h): lower bound
    ; third param (bp+06h): upper bound
    ; return value to AX register, 0 if valid, 1 if invalid

    setup

    mov al, [bp+04h]
    mov ah, [bp+06h]
    cmp al, ah
    jg .INVLD

    mov ah, [bp+05h]
    cmp al, ah
    jl .INVLD
    mov ax, 00h
    jmp .VLD

.INVLD:
    mov ax, 01h

.VLD:
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
    ; first param  (bp+04h): character to be printed
    ; second param (bp+05h): number of character to be printed

    setup

    mov cl, [bp+05h]
    xor ch, ch
    cmp cx, 00h
    je .STOP

.REP:
    save
    mov dl, [bp+04h]
    mov al, dl
    push ax
    call printColor
    add sp, 2h
    restore
    loop .REP

.STOP:
    leaveret
repeat endp

printNum proc
    ; first param  (bp+04h): starting digit to be printed incrementally
    ; second param (bp+05h): number of digit to be printed

    setup

    mov dl, [bp+04h]
    mov cl, [bp+05h]
    xor ch, ch

.REPN:
    save
    mov al, dl
    push ax
    call printColor
    add sp, 2h
    restore
    inc dl
    loop .REPN

    leaveret
printNum endp

getNumInput proc
    ; first param  (bp+04h): lower bound
    ; second param (bp+05h): upper bound
    ; third param  (bp+06h): address to store input
    ; return value to AX register, 0 if valid, 1 if invalid

    setup
    ; allocate 2 bytes for verify return value
    sub sp, 2h

    ; read input
    mov dx, [bp+06h]
    mov ah, 0ah
    int 21h

    save
    mov al, [bp+05h]
    push ax
    mov si, [bp+06h]
    add si, 02h
    mov al, [si]
    mov ah, [bp+04h]
    push ax
    call verify
    mov [bp-02h], ax
    add sp, 4h
    restore
    mov ax, [bp-02h]

    leaveret
getNumInput endp

printColor proc
    ; first param (bp+04h): character to be printed

    setup

    mov al, [bp+04h]
    mov bh, 0
    mov bl, al

    ; make sure bl is between 10h to 1fh
    ; since the program bg color is blue (1h)
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
    
    save
    call advanceCursor
    restore
    
    leaveret
printColor endp

advanceCursor proc
    setup

    ; get current cursor position
    ; value returned to DX (DH: row, DL: col)
    mov ah, 03h
    mov bh, 00h
    int 10h

    ; set cursor position
    mov ah, 02h
    inc dl
    int 10h

    leaveret
advanceCursor endp

resetCursorRow proc
    ; first param (bp+04h): design size

    setup
    
    ; get current cursor position
    ; value returned to DX (DH: row, DL: col)
    mov ah, 03h
    mov bh, 00h
    int 10h

    mov ch, [bp+04h]
    add ch, ch
    dec ch

    ; set cursor position
    mov ah, 02h
    sub dh, ch
    int 10h

    leaveret
resetCursorRow endp

moveCursorColumn proc
    ; first param  (bp+04h): design size
    ; second param (bp+05h): n-th design shape

    setup

    ; get current cursor position
    ; value returned to DX (DH: row, DL: col)
    mov ah, 03h
    mov bh, 00h
    int 10h

    mov cl, [bp+04h]
    mov ch, [bp+05h]
    add cl, cl
    dec cl

.MCCLOOP:
    cmp ch, 00h
    jle .MCCLEAVE
    add dl, cl
    dec ch
    jmp .MCCLOOP

.MCCLEAVE:
    ; set cursor position
    mov ah, 02h
    int 10h

    leaveret
moveCursorColumn endp

end main
