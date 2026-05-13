# Chapitre 18 — SIMD avec SSE/SSE2/AVX

## 18.1 Pourquoi le SIMD ?

Le SIMD (Single Instruction, Multiple Data) permet d'appliquer **une seule instruction à plusieurs données en parallèle**. Exemple : additionner 4 floats en une seule instruction au lieu de 4.

```
Sans SIMD (scalaire) :  a0+b0, a1+b1, a2+b2, a3+b3  → 4 instructions
Avec SIMD (SSE) :       [a0,a1,a2,a3] + [b0,b1,b2,b3] → 1 instruction
```

---

## 18.2 Registres et jeux d'instructions

| Jeu | Registres | Largeur | Éléments max |
|-----|-----------|---------|-------------|
| SSE | `xmm0`–`xmm15` | 128 bits | 4×float ou 2×double |
| AVX | `ymm0`–`ymm15` | 256 bits | 8×float ou 4×double |
| AVX-512 | `zmm0`–`zmm31` | 512 bits | 16×float ou 8×double |

Chaque registre `ymm` contient le `xmm` correspondant dans sa moitié basse.

---

## 18.3 Suffixes de type

| Suffixe | Signification | Exemple |
|---------|--------------|---------|
| `ps` | Packed Single (4 floats/xmm) | `addps` |
| `pd` | Packed Double (2 doubles/xmm) | `addpd` |
| `ss` | Scalar Single (1 float) | `addss` |
| `sd` | Scalar Double (1 double) | `addsd` |
| `epi32` | Packed int32 | `paddd` |

---

## 18.4 Chargement et stockage

### SSE — alignement 16 octets

```nasm
section .data
align 16
    a4  dd 1.0, 2.0, 3.0, 4.0   ; tableau de 4 floats, aligné 16 octets
    b4  dd 5.0, 6.0, 7.0, 8.0

section .text
    movaps  xmm0, [a4]      ; Move Aligned Packed Single — REQUIERT alignement 16
    movaps  xmm1, [b4]

    movups  xmm2, [a4]      ; Move Unaligned Packed Single — fonctionne toujours
```

> `movaps` est plus rapide mais génère une exception si l'adresse n'est pas alignée sur 16 octets. Utiliser `movups` si l'alignement n'est pas garanti.

### AVX — alignement 32 octets

```nasm
section .data
align 32
    c8  dd 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0

section .text
    vmovaps  ymm0, [c8]     ; 8 floats en une fois (AVX)
    vmovups  ymm1, [c8]     ; version non-alignée
```

---

## 18.5 Opérations arithmétiques packed

```nasm
; Additionner 4 paires de floats
    movaps  xmm0, [a4]      ; xmm0 = [a0, a1, a2, a3]
    movaps  xmm1, [b4]      ; xmm1 = [b0, b1, b2, b3]
    addps   xmm0, xmm1      ; xmm0 = [a0+b0, a1+b1, a2+b2, a3+b3]
    movaps  [result], xmm0

; Multiplier puis additionner (FMA avec AVX2)
    vfmadd213ps ymm0, ymm1, ymm2  ; ymm0 = ymm1*ymm0 + ymm2

; Opérations SSE courantes
    subps   xmm0, xmm1      ; soustraction packed
    mulps   xmm0, xmm1      ; multiplication packed
    divps   xmm0, xmm1      ; division packed
    sqrtps  xmm0, xmm1      ; racine carrée packed
    minps   xmm0, xmm1      ; minimum élément par élément
    maxps   xmm0, xmm1      ; maximum élément par élément
    rcpps   xmm0, xmm1      ; réciproque approchée (1/x)
    rsqrtps xmm0, xmm1      ; 1/sqrt(x) approchée
```

---

## 18.6 `shufps` — Mélanger les éléments

```nasm
; shufps xmm_dst, xmm_src, imm8
; imm8 = 4 paires de 2 bits sélectionnant les indices source

    shufps  xmm0, xmm0, 0b00011011  ; inverser l'ordre : [3,2,1,0] → [0,1,2,3]
    shufps  xmm0, xmm0, 0x00        ; broadcast xmm0[0] dans tous les éléments
```

---

## 18.7 Opérations bit à bit sur les registres XMM

```nasm
    andps   xmm0, xmm1      ; ET bit à bit (utile pour masques)
    orps    xmm0, xmm1      ; OU bit à bit
    xorps   xmm0, xmm1      ; XOR bit à bit
    andnps  xmm0, xmm1      ; AND NOT : xmm0 = (~xmm0) AND xmm1
```

Mise à zéro rapide :

```nasm
    xorps   xmm0, xmm0      ; xmm0 = 0 (idiome classique)
```

---

## 18.8 Comparaisons packed

```nasm
    cmpps   xmm0, xmm1, 0   ; EQ  : masque 0xFFFFFFFF si a[i]==b[i], sinon 0
    cmpps   xmm0, xmm1, 1   ; LT
    cmpps   xmm0, xmm1, 2   ; LE
    ; Résultat : masque de bits à utiliser avec andps
```

---

## 18.9 Exemple complet : produit scalaire de deux vecteurs (4 floats)

```nasm
; dot_product — calcule a·b = a0*b0 + a1*b1 + a2*b2 + a3*b3
; rdi = adresse de a (16 octets alignés), rsi = adresse de b
; retourne xmm0 = résultat scalaire

dot_product:
    movaps  xmm0, [rdi]     ; xmm0 = [a0, a1, a2, a3]
    movaps  xmm1, [rsi]     ; xmm1 = [b0, b1, b2, b3]
    mulps   xmm0, xmm1      ; xmm0 = [a0*b0, a1*b1, a2*b2, a3*b3]

    ; Réduction horizontale : sommer les 4 éléments
    movaps  xmm2, xmm0
    shufps  xmm2, xmm0, 0b01001110  ; xmm2 = [a2*b2, a3*b3, a0*b0, a1*b1]
    addps   xmm0, xmm2      ; xmm0 = [s01, s23, s01, s23] (partiels)
    movaps  xmm2, xmm0
    shufps  xmm2, xmm0, 0b10110001  ; permuter les deux paires
    addss   xmm0, xmm2      ; xmm0[0] = somme complète
    ret
```

---

## 18.10 Alignement mémoire

| Instruction | Alignement requis |
|-------------|------------------|
| `movaps` (SSE) | 16 octets |
| `movapd` (SSE2) | 16 octets |
| `vmovaps` (AVX) | 32 octets |
| `movups` / `movupd` / `vmovups` | Aucun (plus lent) |

```nasm
; Forcer l'alignement avec la directive NASM :
align 16
    tableau dd 1.0, 2.0, 3.0, 4.0
```

---

## Résumé

| Aspect | SSE | AVX |
|--------|-----|-----|
| Registres | `xmm0`–`xmm15` (128 bits) | `ymm0`–`ymm15` (256 bits) |
| Floats/registre | 4 | 8 |
| Doubles/registre | 2 | 4 |
| Alignement | 16 octets | 32 octets |
| Préfixe instructions | Aucun | `v` (ex. `vmovaps`) |
| Instruction set requis | Tout x86-64 | `-mavx` à la compilation |

- Préférer `movups`/`vmovups` si l'alignement n'est pas garanti.
- `xorps xmm0, xmm0` est l'idiome le plus rapide pour mettre un registre XMM à zéro.
- Les instructions AVX (préfixe `v`) mettent à zéro la moitié haute du registre YMM correspondant, évitant les pénalités de transition SSE↔AVX.
