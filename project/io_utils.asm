; Projet — Module E/S
; Fonctions réutilisables pour la saisie et l'affichage

section .data
    newline     db  10

section .bss
    _uint_buf   resb 32

section .text
global print_string, print_uint, print_newline, read_string, strlen_p

; Affiche une chaîne null-terminée (rdi = adresse)
print_string:
    push rbp
    mov  rbp, rsp
    push rbx
    mov  rbx, rdi
    call strlen_p
    mov  rdx, rax
    mov  rax, 1
    mov  rdi, 1
    mov  rsi, rbx
    syscall
    pop  rbx
    pop  rbp
    ret

; Affiche un entier non signé (rdi = valeur)
print_uint:
    push rbp
    mov  rbp, rsp
    push rbx
    push r12
    mov  r12, rdi
    mov  rbx, 10
    xor  rcx, rcx
    lea  rdi, [_uint_buf + 31]
    mov  byte [rdi], 0
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
    mov  rax, 1
    mov  rsi, rdi
    mov  rdx, rcx
    mov  rdi, 1
    syscall
    pop  r12
    pop  rbx
    pop  rbp
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

; Lit une ligne depuis stdin (rdi = tampon, rsi = taille max)
; Retourne rax = nombre d'octets lus (sans le \n)
read_string:
    push rbp
    mov  rbp, rsp
    push rbx
    push r12
    mov  rbx, rdi
    mov  r12, rsi
    mov  rax, 0         ; sys_read
    mov  rdi, 0         ; stdin
    mov  rsi, rbx
    mov  rdx, r12
    syscall
    ; Supprimer le '\n' final
    test rax, rax
    jz   .fin
    mov  rcx, rax
    dec  rcx
    cmp  byte [rbx + rcx], 10
    jne  .fin
    mov  byte [rbx + rcx], 0
    dec  rax
.fin:
    pop  r12
    pop  rbx
    pop  rbp
    ret

; Longueur d'une chaîne null-terminée (rdi = adresse → rax = longueur)
strlen_p:
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
