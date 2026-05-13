# Solutions — Chapitre 05 : Entrées/Sorties

## Solution 1 — Écho de saisie

```nasm
section .data
    msg_prompt  db  "Entrez du texte : ", 0
    msg_saisi   db  "Vous avez saisi : ", 0

section .bss
    tampon  resb 65     ; 64 octets + null

section .text
    global _start

print_str:              ; rdi = adresse, rdx = longueur
    mov rax, 1
    mov rsi, rdi
    mov rdi, 1
    syscall
    ret

_start:
    ; Afficher le prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_prompt
    mov rdx, 18
    syscall

    ; Lire l'entrée
    mov rax, 0
    mov rdi, 0
    mov rsi, tampon
    mov rdx, 64
    syscall
    mov rbx, rax        ; sauvegarder le nombre d'octets lus

    ; Afficher le préfixe
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_saisi
    mov rdx, 18
    syscall

    ; Afficher le texte lu
    mov rax, 1
    mov rdi, 1
    mov rsi, tampon
    mov rdx, rbx
    syscall

    ; Quitter avec le nombre d'octets lus comme code de retour
    mov rdi, rbx
    mov rax, 60
    syscall
```

## Solution 2 — Écrire sur stderr

```nasm
mov rax, 1
mov rdi, 2          ; fd = stderr (pas 1)
mov rsi, msg_erreur
mov rdx, msg_len
syscall
```

## Solution 3 — Lire `/etc/hostname`

Voir `ch13_fichiers/fichiers.asm` pour un exemple complet de lecture de fichier. La logique est identique avec `sys_open(O_RDONLY=0)`.
