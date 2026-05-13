# Chapitre 07 — Boucles

## Concepts abordés

- Boucle `for` avec compteur décroissant
- Instruction `loop` (décrémente `rcx` et saute)
- Boucle `while` (condition en tête)
- Boucle `do-while` (condition en queue)
- Gestion du registre `rcx` lors d'appels système

## Pattern de boucle for

```nasm
    mov rcx, 10         ; compteur d'itérations
boucle:
    ; corps de la boucle
    dec rcx
    jnz boucle          ; répéter si rcx != 0
```

## Instruction `loop`

```nasm
    mov rcx, 5
boucle:
    ; corps
    loop boucle         ; dec rcx ; jnz boucle
```

> `loop` est pratique mais plus lent que `dec rcx / jnz` sur les processeurs modernes.

## Pattern while

```nasm
boucle_while:
    cmp rax, limite
    jge fin_while
    ; corps
    inc rax
    jmp boucle_while
fin_while:
```

## Pattern do-while

```nasm
boucle_do:
    ; corps (exécuté au moins une fois)
    inc rbx
    cmp rbx, limite
    jl  boucle_do
```

## Boucle infinie avec `break`

```nasm
boucle_infinie:
    ; corps
    cmp rax, condition_sortie
    je  fin_boucle
    jmp boucle_infinie
fin_boucle:
```

## Attention

Les appels système (`syscall`) peuvent modifier `rcx` et `r11`. Toujours sauvegarder `rcx` sur la pile avant un `syscall` à l'intérieur d'une boucle.
