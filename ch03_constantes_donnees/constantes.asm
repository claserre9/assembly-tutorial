; Chapitre 03 — Constantes et données : constantes symboliques

section .data
    ; Constantes de chaîne
    msg_bienvenue   db  "Bienvenue dans le tutoriel assembleur!", 10
    len_bienvenue   equ $ - msg_bienvenue

    ; Constantes numériques avec equ
    MAX_SIZE        equ 100
    VERSION         equ 1

    ; Données initialisées de différents types
    octet_val       db  0xFF        ; 1 octet (8 bits)
    mot_val         dw  0x1234      ; 2 octets (16 bits)
    dword_val       dd  0xDEADBEEF  ; 4 octets (32 bits)
    qword_val       dq  0x0102030405060708 ; 8 octets (64 bits)

    ; Tableau d'octets initialisé
    tableau         db  1, 2, 3, 4, 5
    taille_tableau  equ ($ - tableau)

section .text
    global _start

_start:
    ; Afficher le message de bienvenue
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_bienvenue
    mov rdx, len_bienvenue
    syscall

    ; Utiliser une constante numérique dans un calcul
    mov rax, MAX_SIZE   ; rax = 100
    add rax, VERSION    ; rax = 101

    ; Quitter
    mov rax, 60
    xor rdi, rdi
    syscall
