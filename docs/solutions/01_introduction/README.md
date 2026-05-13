# Solutions — Chapitre 01 : Introduction

## Solution 1 — Compléter le programme

```nasm
section .data
    msg     db  "Assembleur x86-64", 10
    msg_len equ $ - msg

section .text
    global _start

_start:
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, msg
    mov rdx, msg_len
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
```

## Solution 2 — Afficher plusieurs messages

```nasm
section .data
    ligne1      db  "Ligne 1", 10
    ligne1_len  equ $ - ligne1
    ligne2      db  "Ligne 2", 10
    ligne2_len  equ $ - ligne2
    ligne3      db  "Ligne 3", 10
    ligne3_len  equ $ - ligne3

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, ligne1
    mov rdx, ligne1_len
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, ligne2
    mov rdx, ligne2_len
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, ligne3
    mov rdx, ligne3_len
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
```

## Solution 3 — Les erreurs dans le code

Les erreurs étaient :
1. `section data` → doit être `section .data` (le point est obligatoire)
2. `msg_len = $ - msg` → doit être `msg_len equ $ - msg` (utiliser `equ` pour les constantes)
3. `global start` → doit être `global _start` (le trait souligné est obligatoire)
4. `start:` → doit être `_start:`
5. `syscal` → doit être `syscall` (double l)
