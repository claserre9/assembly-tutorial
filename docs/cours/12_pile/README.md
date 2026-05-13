# Chapitre 12 — Gestion de la pile (stack)

## 12.1 Fonctionnement LIFO

La pile x86-64 **croît vers les adresses basses**. `rsp` (Stack Pointer) pointe toujours sur le dernier élément empilé.

```
Adresses hautes
+-----------+
| données   |
+-----------+  <- rsp + 8  (ancien sommet)
| valeur    |
+-----------+  <- rsp       (sommet actuel)
| ???       |   <- zone non allouée
Adresses basses
```

---

## 12.2 `push` et `pop`

```nasm
push rax    ; rsp -= 8, [rsp] = rax
pop  rbx    ; rbx = [rsp], rsp += 8
```

`push`/`pop` opèrent sur des **quadwords** (8 octets) en mode 64 bits.

```nasm
; Échanger rax et rbx sans registre temporaire
push rax
push rbx
pop  rax
pop  rbx
; ATTENTION : ordre inversé (LIFO) — rax <-> rbx échangés
```

---

## 12.3 Alignement de la pile sur 16 octets

La System V AMD64 ABI exige que la pile soit alignée sur **16 octets au moment d'un `call`**. En pratique :

- Au point d'entrée `_start`, `rsp` est aligné sur 16 octets.
- Chaque `call` pousse 8 octets → `rsp % 16 == 8` dans la fonction appelée.
- Pour appeler une autre fonction, aligner avant le `call` :

```nasm
; Si rsp % 16 == 8 (cas normal après call), on push un 8 octets supplémentaire
sub  rsp, 8         ; ou push rbp
call autre_fonction
add  rsp, 8         ; ou pop rbp
```

**Idiome fiable** : masquer les 4 bits de poids faible de `rsp` :

```nasm
and  rsp, -16       ; aligner sur 16 (détruit les infos précédentes — à faire en début de _start)
```

---

## 12.4 Stack frame et variables locales

Le **frame pointer** `rbp` sert de référence fixe pour accéder aux arguments et variables locales.

```nasm
ma_fonction:
    push rbp            ; sauvegarder le frame pointer de l'appelant
    mov  rbp, rsp       ; rbp pointe sur le bas du frame actuel
    sub  rsp, 32        ; allouer 32 octets (4 variables locales de 8 octets)

    ; Variables locales : accès via rbp
    mov  qword [rbp - 8],  0    ; local1 = 0
    mov  qword [rbp - 16], 1    ; local2 = 1
    mov  qword [rbp - 24], 2    ; local3 = 2
    mov  qword [rbp - 32], 3    ; local4 = 3

    ; Arguments au-dessus de rbp (7e argument et au-delà)
    ; [rbp + 8]  = adresse de retour
    ; [rbp + 16] = 7e argument
    ; [rbp + 24] = 8e argument

    leave               ; mov rsp, rbp + pop rbp
    ret
```

---

## 12.5 Disposition de la pile pendant un appel

```
Après push rbp / mov rbp, rsp / sub rsp, N :

[rbp + 24]   7e argument (si > 6 args)
[rbp + 16]   8e argument
[rbp +  8]   adresse de retour (poussée par call)
[rbp +  0]   rbp sauvegardé    <- rbp pointe ici
[rbp -  8]   variable locale 1
[rbp - 16]   variable locale 2
...
[rsp     ]   bas du frame      <- rsp pointe ici
```

---

## 12.6 `pushfq` et `popfq` (sauvegarde des drapeaux)

```nasm
pushfq          ; empiler RFLAGS (8 octets)
; ... instructions qui modifient les drapeaux ...
popfq           ; restaurer RFLAGS
```

Utile pour préserver l'état des drapeaux autour d'un bloc de code :

```nasm
; Tester rax > 0 et rax < 100 sans perdre les drapeaux entre les deux tests
cmp  rax, 0
jle  .non_valide

pushfq
cmp  rax, 100
jge  .non_valide_pop
popfq
; rax est dans ]0, 100[
jmp  .valide

.non_valide_pop:
    popfq
.non_valide:
```

---

## 12.7 Exemple : pile comme structure de données

```nasm
; Utiliser la pile pour évaluer une expression postfixée
; (Exemple : 3 4 + 2 * = 14)

push 3          ; pile : [3]
push 4          ; pile : [3, 4]

pop  rbx
pop  rax
add  rax, rbx   ; rax = 7
push rax        ; pile : [7]

push 2          ; pile : [7, 2]

pop  rbx
pop  rax
imul rax, rbx   ; rax = 14
push rax        ; pile : [14]

pop  rax        ; résultat = 14
```

---

## 12.8 Débordement de pile (stack overflow)

La pile a une taille limitée (souvent 8 Mo sur Linux). Une récursion infinie ou l'allocation de très grands tableaux locaux provoque un `SIGSEGV`.

```nasm
; DANGEREUX : alloue 10 Mo sur la pile
sub  rsp, 10485760   ; peut provoquer un stack overflow
```

Pour de grandes allocations, préférer `sys_mmap` ou des variables globales (`.bss`).

---

## 12.9 Instructions connexes

| Instruction | Effet |
|-------------|-------|
| `push r64` | `rsp -= 8`, `[rsp] = r64` |
| `pop r64` | `r64 = [rsp]`, `rsp += 8` |
| `pushfq` | Empiler RFLAGS |
| `popfq` | Dépiler RFLAGS |
| `leave` | `mov rsp, rbp` + `pop rbp` |
| `enter N, 0` | `push rbp` + `mov rbp, rsp` + `sub rsp, N` (rarement utilisé) |

---

## Résumé

- La pile **croît vers les adresses basses** ; `rsp` pointe sur le sommet.
- Aligner `rsp` sur **16 octets avant tout `call`**.
- Variables locales via `sub rsp, N` et accès en `[rbp - offset]`.
- `push`/`pop` par paires pour ne pas désaligner la pile.
- Sauvegarder `rbp` au prologue, le restaurer à l'épilogue avec `leave`.
