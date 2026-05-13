# Exercices — Chapitre 08 : Procédures

## Exercice 1 — Procédure min/max

Écrivez deux procédures :
- `minimum` : prend `rdi` et `rsi`, retourne `rax` = min(rdi, rsi)
- `maximum` : prend `rdi` et `rsi`, retourne `rax` = max(rdi, rsi)

Testez avec plusieurs paires de valeurs.

## Exercice 2 — Fibonacci récursif

Écrivez une procédure récursive `fibonacci` qui :
- Prend `rdi` = n
- Retourne `rax` = F(n) (F(0)=0, F(1)=1, F(n)=F(n-1)+F(n-2))

Testez pour n = 0 à 10.

> Rappel : sauvegarder `rbx`, `r12`-`r15` si utilisés ; `call` modifie `rsp`.

## Exercice 3 — Procédure avec variables locales

Écrivez une procédure `somme_tableau` qui :
- Prend `rdi` = adresse du tableau, `rsi` = nombre d'éléments (entiers 64 bits)
- Utilise au moins une variable locale sur la pile (compteur i)
- Retourne `rax` = somme de tous les éléments

Structure attendue :
```nasm
somme_tableau:
    push rbp
    mov  rbp, rsp
    sub  rsp, 16    ; espace pour i et sum
    ; ...
    mov  rsp, rbp
    pop  rbp
    ret
```
