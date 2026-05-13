# Chapitre 01 — Introduction au langage assembleur

## Concepts abordés

- Structure d'un programme NASM
- Sections `.data` et `.text`
- Label `_start` (point d'entrée)
- Appels système Linux (`syscall`)
- `sys_write` (écrire sur stdout)
- `sys_exit` (quitter le programme)

## Exemple : hello_world.asm

Le programme affiche "Bonjour, monde!" en utilisant directement l'appel système `write` du noyau Linux.

```nasm
section .data
    msg     db  "Bonjour, monde!", 10
    msg_len equ $ - msg

section .text
    global _start

_start:
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, msg
    mov rdx, msg_len
    syscall

    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall
```

## Compilation et exécution

```bash
nasm -f elf64 hello_world.asm -o hello_world.o
ld -o hello_world hello_world.o
./hello_world
```

## Points importants

- Tout programme NASM Linux doit définir `global _start`
- Les numéros de syscall sont dans `/usr/include/asm/unistd_64.h`
- `equ $ - msg` calcule la longueur de la chaîne à la compilation
- `xor rdi, rdi` est plus efficace que `mov rdi, 0` pour mettre un registre à zéro
