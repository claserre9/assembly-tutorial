# Chapitre 12 — Gestion de la pile

## Concepts abordés

- Fonctionnement de la pile (LIFO, croissance vers le bas)
- Instructions `push` et `pop`
- Cadre de pile (stack frame) : `rbp`, `rsp`
- Variables locales sur la pile
- Alignement de la pile sur 16 octets
- `pushfq` / `popfq` (sauvegarde/restauration des drapeaux)

## Fonctionnement de la pile x86-64

La pile croît vers les **adresses basses**. `rsp` pointe toujours vers le dernier élément empilé.

```
Avant push:     Après push rax:
rsp → [ancien]  rsp → [valeur rax]
                      [ancien]
```

## Instructions de pile

```nasm
push rax        ; rsp -= 8 ; [rsp] = rax
pop  rbx        ; rbx = [rsp] ; rsp += 8
```

## Cadre de pile standard

```
     | ...              |
rbp+16 | argument 7 (si > 6 args) |
rbp+8  | adresse de retour        |
rbp+0  | ancien rbp               | ← rbp après le prologue
rbp-8  | variable locale 1        |
rbp-16 | variable locale 2        |
rsp → | ...              |
```

## Prologue et épilogue

```nasm
; Prologue
push rbp
mov  rbp, rsp
sub  rsp, 32        ; N octets pour les variables locales (multiple de 16)

; ... corps de la fonction ...

; Épilogue
mov  rsp, rbp
pop  rbp
ret
```

## Alignement de la pile

Avant tout `call`, `rsp` doit être aligné sur **16 octets**.  
Le `call` empile 8 octets (adresse retour), donc au point d'entrée de la procédure `rsp % 16 == 8`.  
Le prologue empile encore `rbp` (8 octets) → `rsp % 16 == 0`.  
Si des variables locales sont ajoutées, leur taille doit maintenir cet alignement.

## Exemple : sauvegarder des registres

```nasm
push rbx        ; sauvegarder avant modification
push r12
; ... utiliser rbx, r12 ...
pop  r12        ; restaurer dans l'ordre inverse
pop  rbx
```
