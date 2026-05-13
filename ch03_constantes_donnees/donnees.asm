; Chapitre 03 — Constantes et données : segment de données (.data, .bss, .rodata)

section .rodata
    ; Données en lecture seule — tentative d'écriture = segfault
    titre       db  "--- Démonstration des segments de données ---", 10
    titre_len   equ $ - titre

section .data
    ; Variables globales initialisées (modifiables)
    compteur    dq  0       ; entier 64 bits initialisé à 0
    flag        db  1       ; octet initialisé à 1

section .bss
    ; Variables non initialisées (réservation d'espace seulement)
    tampon      resb 64     ; réserve 64 octets
    entier_buf  resq 1      ; réserve 1 quadword (8 octets)

section .text
    global _start

_start:
    ; Afficher le titre
    mov rax, 1
    mov rdi, 1
    mov rsi, titre
    mov rdx, titre_len
    syscall

    ; Modifier une variable dans .data
    mov qword [compteur], 42    ; compteur = 42
    inc qword [compteur]        ; compteur = 43

    ; Lire la valeur modifiée
    mov rax, [compteur]         ; rax = 43

    ; Utiliser le tampon .bss pour y écrire une chaîne
    mov byte [tampon],     'O'
    mov byte [tampon + 1], 'K'
    mov byte [tampon + 2], 10   ; saut de ligne

    mov rax, 1
    mov rdi, 1
    mov rsi, tampon
    mov rdx, 3
    syscall

    ; Quitter
    mov rax, 60
    xor rdi, rdi
    syscall
