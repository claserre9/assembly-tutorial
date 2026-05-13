# Solutions — Chapitre 07 : Boucles

## Solution 1 — Somme de 1 à 100

```nasm
section .text
    global _start

_start:
    xor  rax, rax       ; somme = 0
    mov  rcx, 100       ; compteur = 100
.boucle:
    add  rax, rcx       ; somme += i
    dec  rcx
    jnz  .boucle

    ; rax = 5050, mais code de retour max = 255
    ; 5050 mod 256 = 186
    mov  rdi, rax
    mov  rax, 60
    syscall
```

## Solution 2 — Table de multiplication de 7

Implémentation partielle — le programme nécessite une routine `print_uint` :

```nasm
    mov rcx, 1          ; i = 1
.boucle_table:
    push rcx
    mov rax, 7
    imul rax, rcx       ; rax = 7 * i
    call print_uint     ; afficher le résultat
    pop rcx
    inc rcx
    cmp rcx, 11
    jl  .boucle_table
```

## Solution 3 — Triangle d'astérisques

```nasm
section .data
    etoile  db '*'
    nl      db 10

section .text
    global _start

_start:
    mov rbx, 1          ; ligne courante (1 à 5)

.boucle_lignes:
    cmp rbx, 6
    jge .fin

    mov rcx, rbx        ; nombre d'étoiles = numéro de ligne
.boucle_etoiles:
    push rbx
    push rcx
    mov rax, 1
    mov rdi, 1
    mov rsi, etoile
    mov rdx, 1
    syscall
    pop rcx
    pop rbx
    dec rcx
    jnz .boucle_etoiles

    push rbx
    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall
    pop rbx

    inc rbx
    jmp .boucle_lignes

.fin:
    mov rax, 60
    xor rdi, rdi
    syscall
```

## Solution 4 — Compter les voyelles

```nasm
section .data
    texte   db  "Bonjour le monde", 0

section .text
    global _start

_start:
    mov rsi, texte
    xor rcx, rcx        ; compteur = 0
.boucle:
    movzx rax, byte [rsi]
    test al, al
    jz .fin
    ; Vérifier si c'est une voyelle
    cmp al, 'a' & je .voyelle
    cmp al, 'e' ; simplifier : utiliser une table de lookup en pratique
    je .voyelle
    cmp al, 'i'
    je .voyelle
    cmp al, 'o'
    je .voyelle
    cmp al, 'u'
    je .voyelle
    jmp .suite
.voyelle:
    inc rcx
.suite:
    inc rsi
    jmp .boucle
.fin:
    mov rdi, rcx
    mov rax, 60
    syscall
; "Bonjour le monde" contient : o, u, o, e, o, e = 6 voyelles
```
