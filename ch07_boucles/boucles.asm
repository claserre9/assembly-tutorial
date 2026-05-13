; Chapitre 07 — Boucles

section .data
    msg_iter    db  "Iteration : ", 0
    msg_iter_len equ $ - msg_iter - 1
    newline     db  10

section .bss
    chiffre_buf resb 4

section .text
    global _start

; Affiche le chiffre dans rax (0-9)
print_digit:
    add al, '0'
    mov [chiffre_buf], al
    mov byte [chiffre_buf + 1], 10
    mov rax, 1
    mov rdi, 1
    mov rsi, chiffre_buf
    mov rdx, 2
    syscall
    ret

_start:
    ; === Boucle avec compteur décroissant (pattern classique) ===
    mov rcx, 5              ; compteur = 5
boucle_decompte:
    push rcx                ; sauvegarder rcx (syscall peut le modifier)

    mov rax, 1
    mov rdi, 1
    mov rsi, msg_iter
    mov rdx, msg_iter_len
    syscall

    pop rcx
    push rcx
    mov rax, rcx
    call print_digit        ; afficher le compteur courant

    pop rcx
    dec rcx
    jnz boucle_decompte     ; sauter si rcx != 0

    ; === Boucle avec instruction LOOP ===
    ; LOOP décrémente rcx et saute si rcx != 0
    mov rcx, 3
boucle_loop:
    push rcx
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_iter
    mov rdx, msg_iter_len
    syscall
    pop rcx
    push rcx
    mov rax, rcx
    call print_digit
    pop rcx
    loop boucle_loop

    ; === Boucle while (tant que condition) ===
    mov rax, 0              ; compteur
boucle_while:
    cmp rax, 5
    jge fin_while           ; sortir si rax >= 5
    push rax
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_iter
    mov rdx, msg_iter_len
    syscall
    pop rax
    push rax
    call print_digit
    pop rax
    inc rax
    jmp boucle_while
fin_while:

    ; === do-while : exécuter au moins une fois ===
    mov rbx, 0
boucle_do:
    push rbx
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_iter
    mov rdx, msg_iter_len
    syscall
    pop rbx
    push rbx
    mov rax, rbx
    call print_digit
    pop rbx
    inc rbx
    cmp rbx, 3
    jl  boucle_do           ; répéter si rbx < 3

    ; Quitter
    mov rax, 60
    xor rdi, rdi
    syscall
