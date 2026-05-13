# Chapitre 18 — SIMD (SSE / AVX)

## Concepts abordés

- SIMD : Single Instruction, Multiple Data
- Registres XMM (128 bits, SSE/SSE2) et YMM (256 bits, AVX)
- Instructions Packed Single (`ps`) et Packed Double (`pd`)
- Chargement aligné et non-aligné (`movaps`, `movups`)
- Opérations vectorielles : `addps`, `mulps`, `minps`, `maxps`
- Permutations : `shufps`, `unpcklps`, `unpckhps`

## Pourquoi SIMD ?

Une seule instruction traite **plusieurs données simultanément** :

```
addps xmm0, xmm1  →  4 additions flottantes en une instruction
addpd xmm0, xmm1  →  2 additions double en une instruction
```

## Registres

| Registre | Taille | Extension |
|----------|--------|-----------|
| `xmm0`–`xmm15` | 128 bits | SSE |
| `ymm0`–`ymm15` | 256 bits | AVX |
| `zmm0`–`zmm31` | 512 bits | AVX-512 |

## Types de données vectorielles

| Suffixe | Données |
|---------|---------|
| `ps` | Packed Single (4 × float 32 bits) |
| `pd` | Packed Double (2 × double 64 bits) |
| `ss` | Scalar Single (1 × float) |
| `sd` | Scalar Double (1 × double) |

## Chargement

```nasm
align 16
vecteur dd 1.0, 2.0, 3.0, 4.0

movaps xmm0, [vecteur]      ; aligned (adresse multiple de 16)
movups xmm0, [vecteur]      ; unaligned (plus lent)
```

## Exemple : addition vectorielle

```nasm
movaps xmm0, [vec_a]    ; charger a[0..3]
movaps xmm1, [vec_b]    ; charger b[0..3]
addps  xmm0, xmm1       ; xmm0[i] += xmm1[i] pour tout i
movaps [resultat], xmm0 ; stocker le résultat
```

## Vérifier le support CPU

Utiliser `cpuid` pour vérifier les extensions disponibles (SSE2, SSE3, AVX, AVX-512) avant de les utiliser.
