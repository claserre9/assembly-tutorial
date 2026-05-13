# Exercices — Chapitre 11 : Modes d'adressage

## Exercice 1 — Identifier les modes

Pour chaque instruction, identifiez le mode d'adressage utilisé :

```nasm
mov rax, 42                      ; mode : ?
mov rax, rbx                     ; mode : ?
mov rax, [variable]              ; mode : ?
mov rax, [rsi]                   ; mode : ?
mov rax, [rsi + 8]               ; mode : ?
mov rax, [tableau + rcx * 8]     ; mode : ?
mov rax, [rbp - 16]              ; mode : ?
lea rdi, [tableau + rcx * 4]     ; mode : ?
```

## Exercice 2 — Calcul avec LEA

Utilisez `lea` (sans `mul`) pour calculer les expressions suivantes en une ou deux instructions :

- `rax = rbx * 3`
- `rax = rbx * 5`
- `rax = rbx * 9`
- `rax = rbx * 10`

*Astuce : `lea rax, [rbx + rbx*2]` = rbx * 3*

## Exercice 3 — Accès à une structure via pointeur

Soit la structure :
```nasm
struc Point
    .x: resq 1   ; offset 0
    .y: resq 1   ; offset 8
endstruc
```

Et un pointeur `rsi` vers un `Point`. Écrivez le code pour :
1. Charger `x` dans `rax`
2. Charger `y` dans `rbx`
3. Calculer `x + y` et stocker dans `rax`
4. Stocker le résultat dans `y` via le pointeur
