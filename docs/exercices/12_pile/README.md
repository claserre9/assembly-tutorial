# Exercices — Chapitre 12 : Gestion de la pile

## Exercice 1 — Tracer la pile

Tracez manuellement l'état de la pile (valeur de `rsp` et contenu) après chaque instruction :

```nasm
; rsp initial = 0x7FFF1000

push rax        ; rax = 100 — rsp = ? contenu = ?
push rbx        ; rbx = 200 — rsp = ? contenu = ?
push rcx        ; rcx = 300 — rsp = ? contenu = ?
pop  rax        ; rax = ? rsp = ?
pop  rbx        ; rbx = ? rsp = ?
pop  rcx        ; rcx = ? rsp = ?
```

## Exercice 2 — Procédure avec variables locales

Écrivez une procédure `produit_scalaire` qui calcule le produit scalaire de deux vecteurs de 3 éléments :
- `rdi` = adresse vecteur A
- `rsi` = adresse vecteur B
- Utilise des variables locales sur la pile pour stocker les produits partiels
- Retourne `rax` = A[0]*B[0] + A[1]*B[1] + A[2]*B[2]

## Exercice 3 — Analyser un bug de pile

Le code suivant a un bug. Trouvez et corrigez-le :

```nasm
ma_fonction:
    push rbp
    mov  rbp, rsp
    sub  rsp, 8         ; 1 variable locale

    push rbx            ; sauvegarder rbx
    mov  rbx, rdi

    ; calcul...
    mov  rax, rbx

    pop  rbx
    ; ERREUR : que manque-t-il ?
    ret
```
