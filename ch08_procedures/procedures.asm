; Chapitre 08 — Procédures et conventions d'appel (System V AMD64 ABI)

section .data
    msg_carre   db  "Carre de 7 : ", 0
    msg_carre_len equ $ - msg_carre - 1
    msg_max     db  "Max(10, 25) : ", 0
    msg_max_len equ $ - msg_max - 1
    newline     db  10

section .bss
    result_buf  resb 32

section .text
    global _start

; Affiche l'entier non signé dans rax, suivi d'un saut de ligne
; Convention : modifie rax, rbx, rcx, rdx, rdi, rsi
print_uint:
    push rbp
    mov  rbp, rsp
    sub  rsp, 32                ; espace local pour les chiffres

    mov  rbx, 10
    mov  rcx, 0
    lea  rdi, [rsp + 31]
    mov  byte [rdi], 10         ; '\n' en fin
    dec  rdi
.conv_loop:
    xor  rdx, rdx
    div  rbx
    add  dl, '0'
    mov  [rdi], dl
    dec  rdi
    inc  rcx
    test rax, rax
    jnz  .conv_loop
    inc  rdi
    inc  rcx                    ; compter le '\n'

    mov  rax, 1
    mov  rsi, rdi
    mov  rdx, rcx
    mov  rdi, 1
    syscall

    mov  rsp, rbp
    pop  rbp
    ret

; --- Procédure : carré d'un entier ---
; Argument   : rdi = entier n
; Retour     : rax = n * n
; Registres préservés : rbx, rbp, r12-r15
calcul_carre:
    push rbp
    mov  rbp, rsp
    mov  rax, rdi
    imul rax, rdi               ; rax = rdi * rdi
    pop  rbp
    ret

; --- Procédure : maximum de deux entiers ---
; Arguments  : rdi = a, rsi = b
; Retour     : rax = max(a, b)
trouver_max:
    push rbp
    mov  rbp, rsp
    mov  rax, rdi
    cmp  rdi, rsi
    jge  .fin                   ; si rdi >= rsi, rax = rdi est déjà correct
    mov  rax, rsi               ; sinon rax = rsi
.fin:
    pop  rbp
    ret

; --- Procédure récursive : factorielle ---
; Argument   : rdi = n
; Retour     : rax = n!
factorielle:
    push rbp
    mov  rbp, rsp
    push rbx
    mov  rbx, rdi               ; sauvegarder n (rbx est préservé par convention)

    cmp  rdi, 1
    jle  .cas_base              ; factorielle(0) = factorielle(1) = 1

    dec  rdi
    call factorielle             ; rax = factorielle(n-1)
    imul rax, rbx               ; rax = n * factorielle(n-1)
    jmp  .fin_rec

.cas_base:
    mov  rax, 1

.fin_rec:
    pop  rbx
    pop  rbp
    ret

_start:
    ; Appel de calcul_carre(7)
    mov  rdi, 7
    call calcul_carre
    push rax

    mov  rax, 1
    mov  rdi, 1
    mov  rsi, msg_carre
    mov  rdx, msg_carre_len
    syscall

    pop  rax
    call print_uint

    ; Appel de trouver_max(10, 25)
    mov  rdi, 10
    mov  rsi, 25
    call trouver_max
    push rax

    mov  rax, 1
    mov  rdi, 1
    mov  rsi, msg_max
    mov  rdx, msg_max_len
    syscall

    pop  rax
    call print_uint

    ; Quitter
    mov  rax, 60
    xor  rdi, rdi
    syscall
