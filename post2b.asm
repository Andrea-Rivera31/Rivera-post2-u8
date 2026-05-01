; post2b.asm - Suma BCD con DAA
ORG 100h

section .data
    bcd1      db 47h    ; "47"
    bcd2      db 38h    ; "38"
    resultado db 0
    msg       db "BCD suma: $"
    crlf      db 0Dh, 0Ah, "$"

section .text
start:
    mov al, [bcd1]
    add al, [bcd2]      ; AL = 7Fh (Suma binaria normal)[cite: 5]
    daa                 ; Ajuste: AL = 85h (Resultado BCD correcto)[cite: 5]
    mov [resultado], al

    ; Imprimir encabezado
    mov ah, 09h
    mov dx, msg
    int 21h

    ; Imprimir dígitos desglosados
    mov al, [resultado]
    mov bl, al
    shr al, 4           ; Obtener nibble alto (decenas)
    add al, 30h         ; Convertir a ASCII
    mov dl, al
    mov ah, 02h
    int 21h

    mov al, bl
    and al, 0Fh         ; Obtener nibble bajo (unidades)
    add al, 30h         ; Convertir a ASCII
    mov dl, al
    int 21h

    mov ah, 09h
    mov dx, crlf
    int 21h

    mov ah, 4Ch
    int 21h