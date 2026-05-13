# Solutions — Chapitre 17 : Listes chaînées

## Solution 1 — longueur_liste

```nasm
; rdi = tête → rax = longueur
longueur_liste:
    push rbp
    mov  rbp, rsp
    xor  rax, rax
.boucle:
    test rdi, rdi
    jz   .fin
    inc  rax
    mov  rdi, [rdi + Noeud.suivant]
    jmp  .boucle
.fin:
    pop  rbp
    ret
```

## Solution 2 — chercher

```nasm
; rdi = tête, rsi = valeur → rax = pointeur ou 0
chercher:
    push rbp
    mov  rbp, rsp
.boucle:
    test rdi, rdi
    jz   .non_trouve
    cmp  [rdi + Noeud.valeur], rsi
    je   .trouve
    mov  rdi, [rdi + Noeud.suivant]
    jmp  .boucle
.trouve:
    mov  rax, rdi
    jmp  .fin
.non_trouve:
    xor  rax, rax
.fin:
    pop  rbp
    ret
```

## Solution 3 — inverser_liste

```nasm
; rdi = ancienne tête → rax = nouvelle tête
inverser_liste:
    push rbp
    mov  rbp, rsp
    push rbx
    push r12
    push r13

    xor  rbx, rbx           ; prev = NULL
    mov  r12, rdi           ; curr = tête

.boucle:
    test r12, r12
    jz   .fin

    mov  r13, [r12 + Noeud.suivant]     ; next = curr.suivant
    mov  [r12 + Noeud.suivant], rbx     ; curr.suivant = prev
    mov  rbx, r12                        ; prev = curr
    mov  r12, r13                        ; curr = next
    jmp  .boucle

.fin:
    mov  rax, rbx           ; nouvelle tête = prev

    pop  r13
    pop  r12
    pop  rbx
    pop  rbp
    ret
```
