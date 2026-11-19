.model small

.data
    msg_prompt  db 'Ingresa texto y presiona Enter: $'
    msg_result  db 0Dh, 0Ah, 'Cantidad de vocales: $'
    vocales     dw 0
    temp_num    dw 0
    digito      db 0
    mostro_dig  db 0

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 09h
    lea dx, msg_prompt
    int 21h

leer_loop:
    mov ah, 01h
    int 21h

    cmp al, 0Dh
    je fin_lectura

    cmp al, 'a'
    je es_vocal
    cmp al, 'e'
    je es_vocal
    cmp al, 'i'
    je es_vocal
    cmp al, 'o'
    je es_vocal
    cmp al, 'u'
    je es_vocal

    cmp al, 'A'
    je es_vocal
    cmp al, 'E'
    je es_vocal
    cmp al, 'I'
    je es_vocal
    cmp al, 'O'
    je es_vocal
    cmp al, 'U'
    je es_vocal

    jmp leer_loop

es_vocal:
    inc vocales
    jmp leer_loop

fin_lectura:
    mov ah, 09h
    lea dx, msg_result
    int 21h

    call imprimir_numero

    mov ah, 4Ch
    int 21h
main endp

imprimir_numero proc
    mov ax, vocales
    mov temp_num, ax
    mov mostro_dig, 0

    cmp temp_num, 0
    jne centenas
    mov dl, '0'
    mov ah, 02h
    int 21h
    ret

centenas:
    mov digito, 0

resta_100:
    cmp temp_num, 100
    jb decenas
    sub temp_num, 100
    inc digito
    jmp resta_100

decenas:
    cmp digito, 0
    jne imp_centena
    cmp mostro_dig, 1
    je imp_centena
    jmp prep_decenas

imp_centena:
    mov dl, digito
    add dl, '0'
    mov ah, 02h
    int 21h
    mov mostro_dig, 1

prep_decenas:
    mov digito, 0

resta_10:
    cmp temp_num, 10
    jb unidades
    sub temp_num, 10
    inc digito
    jmp resta_10

unidades:
    cmp digito, 0
    jne imp_decena
    cmp mostro_dig, 1
    je imp_decena
    jmp imp_unidad

imp_decena:
    mov dl, digito
    add dl, '0'
    mov ah, 02h
    int 21h
    mov mostro_dig, 1

imp_unidad:
    mov ax, temp_num
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    ret
imprimir_numero endp

end main