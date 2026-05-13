# Solutions — Chapitre 18 : SIMD

## Solution 1 — Addition vectorielle

```nasm
section .data
    align 16
    vec_a   dd  1.0, 2.0, 3.0, 4.0
    vec_b   dd  5.0, 6.0, 7.0, 8.0

section .bss
    align 16
    resultat resb 16

section .text
    global _start

_start:
    movaps xmm0, [vec_a]    ; charger {1.0, 2.0, 3.0, 4.0}
    movaps xmm1, [vec_b]    ; charger {5.0, 6.0, 7.0, 8.0}
    addps  xmm0, xmm1       ; {6.0, 8.0, 10.0, 12.0}
    movaps [resultat], xmm0

    mov rax, 60
    xor rdi, rdi
    syscall
```

## Solution 2 — Produit scalaire

```nasm
    movaps xmm0, [vec_a]
    movaps xmm1, [vec_b]
    mulps  xmm0, xmm1           ; produits : {5.0, 12.0, 21.0, 32.0}
    ; Réduction : additionner les 4 éléments
    haddps xmm0, xmm0           ; {5+12, 21+32, 5+12, 21+32} = {17, 53, 17, 53}
    haddps xmm0, xmm0           ; {17+53, 17+53, ...} = {70, 70, 70, 70}
    ; xmm0[0] = produit scalaire = 70
```

## Solution 3 — Normalisation

```nasm
    movaps xmm0, [vecteur4d]    ; charger x, y, z, w
    movaps xmm1, xmm0
    mulps  xmm1, xmm1           ; x², y², z², w²
    haddps xmm1, xmm1
    haddps xmm1, xmm1           ; xmm1[0] = x²+y²+z²+w²
    sqrtss xmm2, xmm1           ; xmm2[0] = norme
    shufps xmm2, xmm2, 0        ; diffuser dans tous les lanes
    divps  xmm0, xmm2           ; normaliser
```
