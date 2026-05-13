; Chapitre 19 — Multi-fichiers : module utilitaires
; Ce fichier est un module réutilisable assemblé séparément

section .data
    newline     db  10

section .bss
    _print_buf  resb 32

section .text

; Déclarer les symboles exportés (visibles depuis les autres modules)
global print_uint
global print_string
global print_newline
global strlen_util

; Affiche un entier non signé (rdi = valeur)
print_uint:
    push rbp
    mov  rbp, rsp
    push rbx
    push r12

    mov  r12, rdi           ; sauvegarder la valeur
    mov  rbx, 10
    mov  rcx, 0
    lea  rdi, [_print_buf + 31]
    mov  byte [rdi], 10     ; '\n'
    dec  rdi

    mov  rax, r12
.conv:
    xor  rdx, rdx
    div  rbx
    add  dl, '0'
    mov  [rdi], dl
    dec  rdi
    inc  rcx
    test rax, rax
    jnz  .conv
    inc  rdi
    inc  rcx

    mov  rax, 1
    mov  rsi, rdi
    mov  rdx, rcx
    mov  rdi, 1
    syscall

    pop r12
    pop rbx
    pop rbp
    ret

; Affiche une chaîne null-terminée (rdi = adresse)
print_string:
    push rbp
    mov  rbp, rsp
    push rbx

    mov  rbx, rdi
    call strlen_util
    mov  rdx, rax       ; longueur

    mov  rax, 1
    mov  rdi, 1
    mov  rsi, rbx
    syscall

    pop rbx
    pop rbp
    ret

; Affiche un saut de ligne
print_newline:
    push rbp
    mov  rbp, rsp
    mov  rax, 1
    mov  rdi, 1
    mov  rsi, newline
    mov  rdx, 1
    syscall
    pop  rbp
    ret

; Calcule la longueur d'une chaîne null-terminée (rdi = adresse)
; Retourne rax = longueur
strlen_util:
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
