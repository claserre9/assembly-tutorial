# Exercices — Chapitre 01 : Introduction

## Exercice 1 — Compléter le programme

Complétez le programme suivant pour qu'il affiche "Assembleur x86-64" suivi d'un saut de ligne :

```nasm
section .data
    msg     db  _______________, 10
    msg_len equ $ - msg

section .text
    global _start

_start:
    mov rax, ___
    mov rdi, ___
    mov rsi, ___
    mov rdx, ___
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
```

## Exercice 2 — Afficher plusieurs messages

Écrivez un programme qui affiche :
```
Ligne 1
Ligne 2
Ligne 3
```

Chaque ligne doit être une chaîne séparée dans `.data`.

## Exercice 3 — Trouver les erreurs

Identifiez et corrigez les erreurs dans le programme suivant :

```nasm
section data
    msg db "Bonjour", 10
    msg_len = $ - msg

section .text
    global start

start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscal

    mov rax, 60
    mov rdi, 0
    syscall
```
