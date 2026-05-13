# Chapitre 09 — Tableaux

## Concepts abordés

- Déclaration de tableaux dans `.data`
- Accès indexé : `base + index * scale`
- Tableaux de différents types (octets, mots, quadwords)
- Parcours de tableau avec boucle
- Recherche du minimum/maximum

## Déclaration d'un tableau

```nasm
section .data
    entiers dq  10, 20, 30, 40, 50  ; 5 entiers 64 bits
    octets  db  1, 2, 3, 4, 5       ; 5 octets
    taille  equ ($ - entiers) / 8   ; nombre d'éléments
```

## Accès indexé

```nasm
; tableau[i] avec des éléments de 8 octets
mov rax, [entiers + rcx * 8]    ; charger entiers[rcx]
mov [entiers + rcx * 8], rdx    ; stocker dans entiers[rcx]
```

La syntaxe générale est : `[base + index * scale + displacement]`

| Scale | Taille de l'élément |
|-------|---------------------|
| 1 | `db` (octet) |
| 2 | `dw` (mot) |
| 4 | `dd` (dword) |
| 8 | `dq` (qword) |

## Exemple : parcourir un tableau

```nasm
    mov rsi, entiers    ; adresse de base
    mov rcx, 0          ; index i = 0
boucle:
    cmp rcx, taille
    jge fin
    mov rax, [rsi + rcx * 8]   ; rax = entiers[i]
    ; traiter rax...
    inc rcx
    jmp boucle
fin:
```

## Adressage avec LEA

```nasm
lea rdi, [entiers + rcx * 8]   ; rdi = adresse de entiers[rcx]
```

`lea` calcule et charge l'adresse sans déréférencer — utile pour passer un pointeur vers un élément.
