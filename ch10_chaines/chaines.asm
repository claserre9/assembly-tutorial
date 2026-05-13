; Chapitre 10 — Chaînes de caractères

section .data
    chaine1     db  "Bonjour, monde!", 0    ; chaîne terminée par null
    chaine2     db  "Assembleur", 0
    newline     db  10
    msg_len     db  "Longueur : ", 0
    msg_len_l   equ $ - msg_len - 1

section .bss
    tampon      resb 64
    result_buf  resb 32

section .text
    global _start

print_uint:
    push rbp
    mov  rbp, rsp
    sub  rsp, 32
    mov  rbx, 10
    mov  rcx, 0
    lea  rdi, [rsp + 31]
    mov  byte [rdi], 10
    dec  rdi
.loop:
    xor  rdx, rdx
    div  rbx
    add  dl, '0'
    mov  [rdi], dl
    dec  rdi
    inc  rcx
    test rax, rax
    jnz  .loop
    inc  rdi
    inc  rcx
    mov  rax, 1
    mov  rsi, rdi
    mov  rdx, rcx
    mov  rdi, 1
    syscall
    mov  rsp, rbp
    pop  rbp
    ret

; Calcule la longueur d'une chaîne terminée par null
; rdi = adresse de la chaîne
; retourne rax = longueur
strlen:
    push rbp
    mov  rbp, rsp
    xor  rax, rax
.loop:
    cmp  byte [rdi + rax], 0
    je   .fin
    inc  rax
    jmp  .loop
.fin:
    pop  rbp
    ret

; Copie une chaîne terminée par null
; rdi = destination, rsi = source
strcpy_asm:
    push rbp
    mov  rbp, rsp
.loop:
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    test al, al
    jnz  .loop
    pop  rbp
    ret

; Concatène src à la fin de dst
; rdi = destination (dst), rsi = source (src)
strcat_asm:
    push rbp
    mov  rbp, rsp
    push rdi
    ; Aller à la fin de dst
.find_end:
    cmp  byte [rdi], 0
    je   .start_copy
    inc  rdi
    jmp  .find_end
.start_copy:
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    test al, al
    jnz  .start_copy
    pop  rdi
    pop  rbp
    ret

_start:
    ; Calculer la longueur de chaine1
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_len
    mov rdx, msg_len_l
    syscall

    mov rdi, chaine1
    call strlen
    call print_uint

    ; Afficher chaine1
    mov rdi, chaine1
    call strlen
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, chaine1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Copier chaine2 dans tampon
    mov rdi, tampon
    mov rsi, chaine2
    call strcpy_asm

    ; Afficher tampon
    mov rdi, tampon
    call strlen
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, tampon
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Utiliser les instructions de chaîne REPNE SCASB pour strlen rapide
    mov rdi, chaine1
    mov rcx, 0xFFFFFFFF
    xor al, al              ; chercher le null byte
    repne scasb             ; répéter : scasb (compare al avec [rdi], inc rdi, dec rcx) tant que non égal
    not rcx
    dec rcx                 ; longueur dans rcx

    ; Quitter
    mov rax, 60
    xor rdi, rdi
    syscall
