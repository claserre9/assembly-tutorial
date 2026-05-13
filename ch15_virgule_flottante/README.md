# Chapitre 15 — Virgule flottante (SSE2)

## Concepts abordés

- Registres XMM (`xmm0`–`xmm15`)
- Instructions scalaires SSE2 : `movsd`, `addsd`, `subsd`, `mulsd`, `divsd`
- Instructions simple précision : `movss`, `addss`, etc.
- Comparaison flottante : `ucomisd`
- Conversions : `cvtsi2sd`, `cvttsd2si`
- Format IEEE 754 (32 bits = `float`, 64 bits = `double`)

## Registres XMM

Les registres `xmm0`–`xmm15` font **128 bits** chacun.  
En mode scalaire, seule la moitié basse est utilisée :

| Mode | Instruction | Taille |
|------|-------------|--------|
| Scalaire simple précision | `movss`, `addss`... | 32 bits (float) |
| Scalaire double précision | `movsd`, `addsd`... | 64 bits (double) |
| Vectoriel simple (4 flottants) | `movaps`, `addps`... | 4 × 32 bits |
| Vectoriel double (2 doubles) | `movapd`, `addpd`... | 2 × 64 bits |

## Déclaration de constantes flottantes

```nasm
section .data
    pi      dq  3.14159265358979  ; double précision (64 bits)
    un_half dd  0.5               ; simple précision (32 bits)
```

## Instructions scalaires double précision (SSE2)

```nasm
movsd  xmm0, [pi]       ; charger un double depuis la mémoire
movsd  [resultat], xmm0 ; stocker dans la mémoire
addsd  xmm0, xmm1       ; xmm0 += xmm1
subsd  xmm0, xmm1       ; xmm0 -= xmm1
mulsd  xmm0, xmm1       ; xmm0 *= xmm1
divsd  xmm0, xmm1       ; xmm0 /= xmm1
sqrtsd xmm0, xmm1       ; xmm0 = sqrt(xmm1)
```

## Conversions

```nasm
cvtsi2sd xmm0, rax      ; int64 → double
cvtsi2ss xmm0, eax      ; int32 → float
cvttsd2si rax, xmm0     ; double → int64 (troncature)
cvtsd2ss  xmm0, xmm1    ; double → float
cvtss2sd  xmm0, xmm1    ; float  → double
```

## Comparaison flottante

```nasm
ucomisd xmm0, xmm1      ; compare non signé (gère NaN)
je  egal
jb  inferieur
ja  superieur
```

## Convention d'appel (flottants)

Les arguments flottants sont passés dans `xmm0`–`xmm7`.  
La valeur de retour flottante est dans `xmm0`.
