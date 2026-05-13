; Projet Final — Gestionnaire d'Étudiants
; Point d'entrée et menu principal

extern print_string, print_uint, print_newline, read_string
extern ajouter_etudiant, afficher_etudiants, rechercher_etudiant

section .data
    msg_titre   db  "=== Gestionnaire d'Etudiants ===", 10, 0
    msg_menu1   db  "1. Ajouter un etudiant", 10, 0
    msg_menu2   db  "2. Afficher tous les etudiants", 10, 0
    msg_menu3   db  "3. Quitter", 10, 0
    msg_choix   db  "Votre choix : ", 0
    msg_invalide db  "Choix invalide.", 10, 0

section .bss
    choix_buf   resb 4

section .text
    global _start

afficher_menu:
    push rbp
    mov  rbp, rsp
    mov  rdi, msg_titre
    call print_string
    mov  rdi, msg_menu1
    call print_string
    mov  rdi, msg_menu2
    call print_string
    mov  rdi, msg_menu3
    call print_string
    pop  rbp
    ret

_start:
.boucle_principale:
    call afficher_menu

    ; Afficher le prompt de choix
    mov  rdi, msg_choix
    call print_string

    ; Lire le choix
    mov  rdi, choix_buf
    mov  rsi, 3
    call read_string

    ; Interpréter le choix
    movzx rax, byte [choix_buf]

    cmp  al, '1'
    je   .menu_ajouter

    cmp  al, '2'
    je   .menu_afficher

    cmp  al, '3'
    je   .menu_quitter

    ; Choix invalide
    mov  rdi, msg_invalide
    call print_string
    jmp  .boucle_principale

.menu_ajouter:
    call ajouter_etudiant
    jmp  .boucle_principale

.menu_afficher:
    call afficher_etudiants
    jmp  .boucle_principale

.menu_quitter:
    mov  rax, 60
    xor  rdi, rdi
    syscall
