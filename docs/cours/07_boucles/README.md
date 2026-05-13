# Chapitre 7 — Boucles

## 7.1 Patron `while`

La forme la plus générale : tester la condition **avant** le corps.

```nasm
; while (rax < 10) { rax++ }
    xor rax, rax        ; rax = 0
.while:
    cmp rax, 10
    jge .fin_while      ; si rax >= 10, quitter
    inc rax
    jmp .while
.fin_while:
```

## 7.2 Patron `do-while`

Tester la condition **après** le corps — au moins une exécution garantie.

```nasm
; do { rax++ } while (rax < 10)
    xor rax, rax
.do:
    inc rax
    cmp rax, 10
    jl .do              ; si rax < 10, recommencer
```

Ce patron est légèrement plus efficace car il évite un saut inutile au premier tour.

## 7.3 Patron `for` (compteur dans `rcx`)

```nasm
; for (rcx = 0; rcx < N; rcx++) { ... }
    xor rcx, rcx
.for:
    cmp rcx, N
    jge .fin_for
    ; corps de la boucle
    inc rcx
    jmp .for
.fin_for:
```

Ou en comptant à rebours (plus idiomatique en assembleur) :

```nasm
; for (rcx = N; rcx > 0; rcx--)
    mov rcx, N
.for:
    ; corps
    dec rcx
    jnz .for            ; ZF=0 tant que rcx != 0
```

L'idiome `dec rcx` / `jnz` est très courant et s'exprime aussi avec `loop`.

## 7.4 L'instruction `loop`

`loop etiquette` est équivalent à `dec rcx` + `jnz etiquette` en une seule instruction.

```nasm
    mov rcx, 5          ; compteur = 5
.boucle:
    ; corps (5 fois)
    loop .boucle        ; rcx-- ; si rcx != 0, sauter à .boucle
```

### Variantes

| Instruction  | Condition de continuation    |
|--------------|------------------------------|
| `loop`       | `rcx != 0`                   |
| `loope`/`loopz`  | `rcx != 0` et `ZF = 1`   |
| `loopne`/`loopnz` | `rcx != 0` et `ZF = 0` |

> **Attention :** `loop` décrémente uniquement **rcx** (pas r/ecx en mode 64 bits selon l'encodage). En mode 64 bits, c'est bien `rcx` qui est utilisé.

## 7.5 `rcx` et les syscalls

`syscall` **détruit** `rcx` et `r11`. Si vous utilisez `rcx` comme compteur de boucle et effectuez un syscall dans le corps, sauvegardez `rcx` :

```nasm
    mov rcx, 10
.boucle:
    push rcx            ; sauvegarder avant syscall
    ; ... appel syscall ...
    pop rcx             ; restaurer après syscall
    dec rcx
    jnz .boucle
```

Ou utilisez un autre registre callee-saved (`rbx`, `r12`–`r15`) comme compteur.

## 7.6 Patron `break` (sortie anticipée)

```nasm
    mov rcx, 10
.boucle:
    ; condition de break
    cmp [tableau + rcx*8 - 8], 0
    je  .break          ; si valeur == 0, quitter
    ; corps normal
    dec rcx
    jnz .boucle
.break:
```

## 7.7 Patron `continue` (itération suivante)

```nasm
    mov rcx, 10
.boucle:
    ; condition de continue
    test rcx, 1
    jnz .suivant        ; si impair, passer au suivant
    ; corps pour les pairs seulement
    ; ...
.suivant:
    dec rcx
    jnz .boucle
```

## 7.8 Boucle imbriquée

```nasm
; for i in 0..3: for j in 0..3: ...
    mov r12, 3          ; i = 3 (registre callee-saved)
.boucle_i:
    mov r13, 3          ; j = 3
.boucle_j:
    ; corps (utilise r12 = i, r13 = j)
    dec r13
    jnz .boucle_j
    dec r12
    jnz .boucle_i
```

Utiliser des registres callee-saved (`r12`–`r15`) pour les compteurs de boucles imbriquées évite les conflits.

## 7.9 Exemple complet : somme d'un tableau

```nasm
; Calcule la somme d'un tableau de N qwords
; rdi = adresse du tableau, rsi = N
; retourne rax = somme
sum_array:
    xor rax, rax        ; somme = 0
    test rsi, rsi
    jz  .ret            ; N == 0 : retourner 0
.loop:
    add rax, [rdi]      ; somme += *ptr
    add rdi, 8          ; ptr++
    dec rsi
    jnz .loop
.ret:
    ret
```

## Résumé

- `dec reg` / `jnz` est l'idiome de boucle comptée le plus courant.
- `loop` est pratique mais déconseillé si `rcx` est utilisé par des syscalls dans la boucle.
- Préférer les registres callee-saved (`rbx`, `r12`–`r15`) pour les compteurs persistants.
- La forme `do-while` génère moins d'instructions et s'adapte mieux aux boucles qui s'exécutent au moins une fois.
