; Chapitre 09 — Tableaux

section .data
    tableau     dq  10, 20, 30, 40, 50   ; tableau de 5 entiers 64 bits
    taille      equ ($ - tableau) / 8    ; nombre d'éléments
    msg_elem    db  "Element : ", 0
    msg_elem_len equ $ - msg_elem - 1
    newline     db  10

section .bss
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

_start:
    ; --- Accès indexé à un tableau ---
    ; Adressage : base + index * scale
    mov rsi, tableau        ; adresse de base
    mov rcx, 0              ; index

boucle_affichage:
    cmp rcx, taille
    jge fin_boucle

    push rcx
    push rsi

    ; Afficher le label
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_elem
    mov rdx, msg_elem_len
    syscall

    pop  rsi
    pop  rcx
    push rcx
    push rsi

    ; Charger tableau[rcx] : taille d'un élément = 8 octets (qword)
    mov rax, [rsi + rcx * 8]
    call print_uint

    pop rsi
    pop rcx
    inc rcx
    jmp boucle_affichage

fin_boucle:
    ; --- Modifier un élément ---
    mov qword [tableau + 2 * 8], 999    ; tableau[2] = 999

    ; --- Recherche du maximum ---
    mov rsi, tableau
    mov rcx, taille
    mov rax, [rsi]          ; max = tableau[0]
    mov rbx, 1              ; i = 1

boucle_max:
    cmp rbx, rcx
    jge fin_max
    mov rdx, [rsi + rbx * 8]
    cmp rdx, rax
    jle pas_plus_grand
    mov rax, rdx            ; nouveau maximum
pas_plus_grand:
    inc rbx
    jmp boucle_max

fin_max:
    ; rax contient le maximum

    ; Quitter
    mov rax, 60
    xor rdi, rdi
    syscall
