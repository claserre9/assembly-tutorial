# Solutions — Chapitre 13 : Fichiers

## Solution 1 — Copier un fichier

```nasm
section .data
    src_path    db  "/tmp/source.txt", 0
    dst_path    db  "/tmp/destination.txt", 0

section .bss
    fd_src      resq 1
    fd_dst      resq 1
    bloc        resb 64

section .text
    global _start

_start:
    ; Ouvrir source en lecture
    mov rax, 2
    mov rdi, src_path
    xor rsi, rsi        ; O_RDONLY = 0
    xor rdx, rdx
    syscall
    mov [fd_src], rax

    ; Ouvrir destination en écriture (créer/tronquer)
    mov rax, 2
    mov rdi, dst_path
    mov rsi, 0x241      ; O_WRONLY|O_CREAT|O_TRUNC
    mov rdx, 0o644
    syscall
    mov [fd_dst], rax

.boucle_copie:
    ; Lire un bloc
    mov rax, 0
    mov rdi, [fd_src]
    mov rsi, bloc
    mov rdx, 64
    syscall
    test rax, rax
    jz  .fin_copie      ; EOF

    ; Écrire le bloc
    mov rdx, rax
    mov rax, 1
    mov rdi, [fd_dst]
    mov rsi, bloc
    syscall
    jmp .boucle_copie

.fin_copie:
    mov rax, 3
    mov rdi, [fd_src]
    syscall
    mov rax, 3
    mov rdi, [fd_dst]
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
```

## Solutions 2 et 3

Les solutions 2 (compter les lignes) et 3 (fichier de log) suivent le même patron : `open → read/write → close`, avec une vérification `js erreur` après chaque syscall.
