; Chapitre 17 — Listes chaînées en assembleur

; Structure d'un nœud de liste
struc Noeud
    .valeur:    resq 1      ; données (entier 64 bits)
    .suivant:   resq 1      ; pointeur vers le nœud suivant (NULL = 0)
    .taille:
endstruc

section .data
    msg_liste   db  "Liste : ", 0
    msg_liste_l equ $ - msg_liste - 1
    msg_sep     db  " -> ", 0
    msg_sep_l   equ $ - msg_sep - 1
    msg_null    db  "NULL", 10
    msg_null_l  equ $ - msg_null
    newline     db  10

    ; Nœuds statiques (pour la démonstration)
    noeud1:
        istruc Noeud
            at Noeud.valeur,  dq 10
            at Noeud.suivant, dq noeud2
        iend
    noeud2:
        istruc Noeud
            at Noeud.valeur,  dq 20
            at Noeud.suivant, dq noeud3
        iend
    noeud3:
        istruc Noeud
            at Noeud.valeur,  dq 30
            at Noeud.suivant, dq 0      ; NULL
        iend

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
    mov  byte [rdi], 0
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
    mov  rax, 1
    mov  rsi, rdi
    mov  rdx, rcx
    mov  rdi, 1
    syscall
    mov  rsp, rbp
    pop  rbp
    ret

; Afficher toute la liste à partir du nœud dans rdi
; Modifie : rax, rbx, rcx, rdx, rsi
afficher_liste:
    push rbp
    mov  rbp, rsp
    push rbx

    ; Afficher "Liste : "
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_liste
    mov rdx, msg_liste_l
    syscall

    ; Parcourir la liste
    mov rbx, noeud1         ; rbx = pointeur courant

.parcours:
    test rbx, rbx
    jz   .fin_liste

    ; Afficher la valeur du nœud courant
    mov rax, [rbx + Noeud.valeur]
    call print_uint

    ; Charger le pointeur suivant
    mov rbx, [rbx + Noeud.suivant]
    test rbx, rbx
    jz   .fin_liste

    ; Afficher " -> "
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_sep
    mov rdx, msg_sep_l
    syscall
    jmp .parcours

.fin_liste:
    ; Afficher "NULL\n"
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_null
    mov rdx, msg_null_l
    syscall

    pop rbx
    pop rbp
    ret

_start:
    call afficher_liste

    ; Modifier la liste : noeud2.suivant = NULL (supprimer noeud3)
    mov qword [noeud2 + Noeud.suivant], 0

    call afficher_liste

    ; Quitter
    mov rax, 60
    xor rdi, rdi
    syscall
