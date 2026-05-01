; post2c.asm - Calculadora MUL/DIV (Etiqueta pOp actualizada)
ORG 100h

section .data
    pA      db "Primer operando (0-9): $"
    pB      db 0Dh, 0Ah, "Segundo operando (0-9): $"
    msgOp   db 0Dh, 0Ah, "Seleccione operacion [* para Multiplicar, / para Dividir]: $"
    msgR    db 0Dh, 0Ah, "Resultado: $"
    msgErr  db 0Dh, 0Ah, "Error: Division por cero.$"
    crlf    db 0Dh, 0Ah, "$"

section .text
start:
    ; --- Leer Operando A ---
    mov ah, 09h
    mov dx, pA
    int 21h

    mov ah, 01h
    int 21h
    sub al, 30h         ; Convertir de ASCII a binario
    mov bl, al          ; Guardar A en BL

    ; --- Leer Operando B ---
    mov ah, 09h
    mov dx, pB
    int 21h

    mov ah, 01h
    int 21h
    sub al, 30h
    mov cl, al          ; Guardar B en CL

    ; --- Leer Operador (Usando la nueva etiqueta msgOp) ---
    mov ah, 09h
    mov dx, msgOp       ; Se actualizó la referencia aquí
    int 21h

    mov ah, 01h
    int 21h
    mov bh, al          ; Operador en BH

    ; --- Mostrar Resultado ---
    mov ah, 09h
    mov dx, msgR
    int 21h

    ; Evaluar operación
    cmp bh, '*'
    je .multi
    cmp bh, '/'
    je .divi
    jmp .fin

.multi:
    mov al, bl
    mul cl              ; AX = AL * CL
    call imprimirAX
    jmp .fin

.divi:
    cmp cl, 0           ; Validar división por cero
    je .errorDiv
    xor ah, ah
    mov al, bl
    div cl              ; AL = Cociente
    xor ah, ah          ; Limpiar para imprimir
    call imprimirAX
    jmp .fin

.errorDiv:
    mov ah, 09h
    mov dx, msgErr
    int 21h

.fin:
    mov ah, 09h
    mov dx, crlf
    int 21h
    mov ah, 4Ch         ; Salir al DOS
    xor al, al
    int 21h

; Subrutina para imprimir AX en decimal
imprimirAX:
    mov bx, 10
    xor cx, cx
.divide:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz .divide
.mostrar:
    pop dx
    add dl, 30h
    mov ah, 02h
    int 21h
    loop .mostrar
    ret