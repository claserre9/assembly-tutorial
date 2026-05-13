# Exercices — Chapitre 02 : Registres

## Exercice 1 — Valeurs des registres

Sans exécuter le code, indiquez la valeur de chaque registre après chaque instruction :

```nasm
mov rax, 0xFFFFFFFFFFFFFFFF   ; rax = ?
mov eax, 1                    ; rax = ?
mov ax,  0x1234               ; rax = ?
mov al,  0xFF                 ; rax = ?
mov ah,  0x00                 ; rax = ?
```

## Exercice 2 — Échange de valeurs

Écrivez un programme qui échange les valeurs de `rax` et `rbx` **sans utiliser de variable temporaire en mémoire**. Utilisez uniquement des registres et l'instruction `xchg` ou une séquence de `xor`.

```nasm
; Avant : rax = 100, rbx = 200
; Après : rax = 200, rbx = 100
```

## Exercice 3 — Opérations sur les sous-registres

Écrivez un programme qui :
1. Place la valeur `0x1122334455667788` dans `rax`
2. Extrait l'octet de poids fort de `ax` (c'est-à-dire `ah`) et le place dans `rbx`
3. Met à zéro uniquement les bits 8–15 de `rax` (en utilisant `and`)
4. Affiche le résultat final de `rax` (votre programme peut juste quitter avec `rdi` = rax pour vérifier via `echo $?`)
