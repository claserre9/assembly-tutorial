# Cours 01 — Introduction au langage assembleur

## Qu'est-ce que l'assembleur ?

Le langage assembleur est une **représentation symbolique du code machine**. Chaque instruction assembleur correspond (presque) directement à une instruction du processeur. Il n'y a pas de compilation vers un langage intermédiaire : l'assembleur est traduit directement en binaire par l'assembleur (NASM, GAS, MASM...).

## Pourquoi apprendre l'assembleur ?

- Comprendre le fonctionnement réel du processeur et de la mémoire
- Optimiser des sections critiques de code (calcul intensif, cryptographie)
- Développement de systèmes embarqués et de noyaux OS
- Sécurité informatique : reverse engineering, exploitation

## Architecture x86-64

x86-64 (aussi appelé AMD64 ou Intel 64) est l'extension 64 bits de l'architecture x86. Elle offre :
- 16 registres généraux de 64 bits
- Espace d'adressage virtuel de 64 bits
- Instructions étendues SSE/SSE2/AVX

## Outils nécessaires

| Outil | Rôle | Installation |
|-------|------|-------------|
| NASM | Assembleur (produit les fichiers .o) | `sudo apt install nasm` |
| ld | Éditeur de liens (produit l'exécutable) | fourni avec binutils |
| GDB | Débogueur | `sudo apt install gdb` |

## Structure d'un programme NASM

```nasm
section .data
    ; données initialisées

section .bss
    ; données non initialisées (réservées)

section .text
    global _start       ; point d'entrée obligatoire

_start:
    ; code principal
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; code de retour 0
    syscall
```

## Premier programme : hello_world.asm

Voir `ch01_introduction/hello_world.asm` pour le code source commenté.

```bash
nasm -f elf64 hello_world.asm -o hello_world.o
ld -o hello_world hello_world.o
./hello_world
```

## Points à retenir

1. `global _start` est obligatoire pour l'éditeur de liens
2. Les commentaires commencent par `;`
3. `syscall` est l'instruction pour appeler le noyau Linux
4. `rax = 60` (sys_exit) + `syscall` = fin du programme
5. `equ $ - label` calcule la taille d'une donnée à la compilation
