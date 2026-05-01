; post2.asm - Suma y Resta de 32 bits (ADC y SBB)
ORG 100h

section .data
    ; A = 0x0001FFFF (131071 decimal)
    aLo dw 0FFFFh
    aHi dw 0001h
    ; B = 0x00010001 (65537 decimal)
    bLo dw 0001h
    bHi dw 0001h
    
    msgSuma  db "Suma OK: 0003:0000$", 0Dh, 0Ah, "$"
    msgResta db "Resta OK: 0001:FFFF$", 0Dh, 0Ah, "$"
    crlf     db 0Dh, 0Ah, "$"

section .text
start:
    ; --- SUMA DE 32 BITS ---
    mov ax, [aLo]
    mov dx, [aHi]
    add ax, [bLo]    ; Suma partes bajas: FFFF + 0001 = 0000 (CF=1)
    adc dx, [bHi]    ; Suma partes altas + acarreo: 0001 + 0001 + 1 = 0003
    
    ; Verificación Checkpoint 1
    cmp dx, 0003h
    jne .resta
    mov ah, 09h
    mov dx, msgSuma
    int 21h

.resta:
    ; --- RESTA DE 32 BITS (Resultado previo - B) ---
    ; Se espera: 0x00030000 - 0x00010001 = 0x0001FFFF
    mov ax, 0000h    ; Parte baja del resultado anterior
    mov dx, 0003h    ; Parte alta del resultado anterior
    sub ax, [bLo]    ; 0000 - 0001 = FFFF (CF=1/Prestamo)
    sbb dx, [bHi]    ; 0003 - 0001 - 1 = 0001[cite: 5]
    
    ; Verificación Checkpoint 2
    cmp ax, 0FFFFh
    jne .fin
    mov ah, 09h
    mov dx, msgResta
    int 21h

.fin:
    mov ah, 4Ch
    int 21h