# Chapitre 15 — Virgule flottante avec SSE2

## 15.1 Rappels IEEE 754

Les processeurs x86-64 utilisent le standard **IEEE 754** pour les flottants.

| Type | NASM | Taille | Précision | Plage approx. |
|------|------|--------|-----------|---------------|
| Simple précision | `dd` / `dword` | 32 bits | ~7 décimales | ±3.4×10³⁸ |
| Double précision | `dq` / `qword` | 64 bits | ~15 décimales | ±1.8×10³⁰⁸ |

Structure d'un `float` 32 bits : 1 bit signe, 8 bits exposant, 23 bits mantisse.

---

## 15.2 Registres XMM

SSE2 introduit 16 registres de 128 bits : `xmm0` à `xmm15`.

Chaque registre peut contenir :
- 1 double (`sd` — scalar double)
- 1 float (`ss` — scalar single)
- 2 doubles (`pd` — packed double)
- 4 floats (`ps` — packed single)

Dans ce chapitre, on se concentre sur les opérations **scalaires**.

### Convention d'appel

- Valeur de retour flottante : `xmm0`
- Arguments flottants : `xmm0`, `xmm1`, ..., `xmm7`
- `xmm0`–`xmm7` sont **caller-saved**

---

## 15.3 Charger et stocker des flottants

```nasm
section .data
    a   dq 3.14         ; double
    b   dd 2.0          ; float
    un  dq 1.0
    zero dq 0.0

section .text
    ; Charger un double
    movsd  xmm0, [a]        ; xmm0 = 3.14 (double)

    ; Charger un float
    movss  xmm1, [b]        ; xmm1 = 2.0 (float)

    ; Stocker
    movsd  [a], xmm0
    movss  [b], xmm1

    ; Copier entre registres XMM
    movsd  xmm2, xmm0       ; xmm2 = xmm0
```

---

## 15.4 Opérations arithmétiques scalaires

### Double précision (suffixe `sd`)

```nasm
addsd  xmm0, xmm1       ; xmm0 += xmm1
subsd  xmm0, xmm1       ; xmm0 -= xmm1
mulsd  xmm0, xmm1       ; xmm0 *= xmm1
divsd  xmm0, xmm1       ; xmm0 /= xmm1
sqrtsd xmm0, xmm1       ; xmm0 = sqrt(xmm1)
```

### Simple précision (suffixe `ss`)

```nasm
addss  xmm0, xmm1
subss  xmm0, xmm1
mulss  xmm0, xmm1
divss  xmm0, xmm1
sqrtss xmm0, xmm1
```

### Exemple : calcul de la distance entre deux points

```nasm
; distance = sqrt((x2-x1)^2 + (y2-y1)^2)
; xmm0=x1, xmm1=y1, xmm2=x2, xmm3=y2
distance:
    subsd  xmm2, xmm0       ; xmm2 = x2 - x1
    subsd  xmm3, xmm1       ; xmm3 = y2 - y1
    mulsd  xmm2, xmm2       ; xmm2 = (x2-x1)^2
    mulsd  xmm3, xmm3       ; xmm3 = (y2-y1)^2
    addsd  xmm2, xmm3       ; xmm2 = (x2-x1)^2 + (y2-y1)^2
    sqrtsd xmm0, xmm2       ; xmm0 = sqrt(...)
    ret
```

---

## 15.5 Conversions

### Entier → double

```nasm
; cvtsi2sd xmm_dst, reg_src
mov       rdi, 42
cvtsi2sd  xmm0, rdi     ; xmm0 = 42.0 (double)
cvtsi2ss  xmm1, rdi     ; xmm1 = 42.0 (float)
```

### Double → entier (troncature vers zéro)

```nasm
; cvttsd2si reg_dst, xmm_src  (double → int64, troncature)
movsd       xmm0, [pi]
cvttsd2si   rax, xmm0   ; rax = 3 (tronqué, pas arrondi)

; cvtsd2si  : arrondi selon mode MXCSR (par défaut : round-to-nearest)
cvtsd2si    rax, xmm0   ; rax = 3 (arrondi)
```

### Double ↔ float

```nasm
cvtsd2ss  xmm0, xmm1    ; double → float (perte de précision possible)
cvtss2sd  xmm0, xmm1    ; float → double
```

---

## 15.6 Comparaisons (`ucomisd`)

`ucomisd` compare deux doubles et met à jour `ZF`, `PF`, `CF` :

```nasm
ucomisd  xmm0, xmm1     ; compare xmm0 et xmm1

; Sauts après ucomisd/ucomiss :
je   .egal              ; xmm0 == xmm1 (ZF=1, PF=0)
jb   .inferieur         ; xmm0 < xmm1  (CF=1)
ja   .superieur         ; xmm0 > xmm1  (CF=0, ZF=0)
jp   .nan               ; NaN détecté  (PF=1)
```

> Utiliser `ucomisd` (unordered compare) plutôt que `comisd` pour gérer correctement les NaN.

### Exemple : maximum de deux doubles

```nasm
; retourne max(xmm0, xmm1) dans xmm0
max_double:
    ucomisd  xmm0, xmm1
    ja       .done          ; xmm0 > xmm1, déjà bon
    movsd    xmm0, xmm1     ; sinon xmm0 = xmm1
.done:
    ret
```

---

## 15.7 Valeurs spéciales IEEE 754

```nasm
section .data
    plus_inf   dq 0x7FF0000000000000  ; +Infini
    minus_inf  dq 0xFFF0000000000000  ; -Infini
    qnan       dq 0x7FF8000000000000  ; NaN (quiet)
    neg_zero   dq 0x8000000000000000  ; -0.0
```

---

## 15.8 Registre MXCSR

`MXCSR` contrôle le mode d'arrondi et les exceptions SSE :

```nasm
stmxcsr [var]       ; lire MXCSR en mémoire
ldmxcsr [var]       ; écrire MXCSR depuis la mémoire
```

---

## Résumé

| Opération | Instruction double | Instruction float |
|-----------|-------------------|------------------|
| Charger | `movsd xmm0, [mem]` | `movss xmm0, [mem]` |
| Addition | `addsd` | `addss` |
| Soustraction | `subsd` | `subss` |
| Multiplication | `mulsd` | `mulss` |
| Division | `divsd` | `divss` |
| Racine carrée | `sqrtsd` | `sqrtss` |
| Comparer | `ucomisd` | `ucomiss` |
| int → dbl | `cvtsi2sd` | `cvtsi2ss` |
| dbl → int | `cvttsd2si` | `cvttss2si` |

- Suffixe `sd` = scalar double (64 bits), `ss` = scalar single (32 bits).
- Déclarer les doubles avec `dq`, les floats avec `dd`.
- Utiliser `ucomisd` + sauts `ja`/`jb` (non signés) pour les comparaisons flottantes.
