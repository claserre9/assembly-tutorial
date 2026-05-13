# Chapitre 04 — Opérations arithmétiques

## Concepts abordés

- Addition (`add`), soustraction (`sub`)
- Incrément (`inc`), décrément (`dec`)
- Multiplication entière non signée (`mul`) et signée (`imul`)
- Division entière non signée (`div`) et signée (`idiv`)
- Opérations bit à bit : `and`, `or`, `xor`, `not`
- Décalages : `shl`, `shr`, `sar`, `rol`, `ror`

## Instructions arithmétiques de base

```nasm
add rax, rbx        ; rax = rax + rbx
sub rax, rbx        ; rax = rax - rbx
inc rax             ; rax = rax + 1
dec rax             ; rax = rax - 1
neg rax             ; rax = -rax (complément à deux)
```

## Multiplication

```nasm
; Multiplication non signée
mov rax, 12
mov rbx, 10
mul rbx             ; résultat 128 bits dans rdx:rax

; Multiplication signée (forme à 3 opérandes)
imul rax, rbx, 5    ; rax = rbx * 5
```

> `mul` utilise implicitement `rax` comme premier opérande et stocke le résultat dans `rdx:rax`.

## Division

```nasm
mov rax, 100        ; dividende (partie basse)
xor rdx, rdx        ; rdx = 0 (partie haute — OBLIGATOIRE)
mov rbx, 7
div rbx             ; rax = quotient (14), rdx = reste (2)
```

> Oublier d'initialiser `rdx` avant `div` provoque des résultats incorrects ou une exception.

## Opérations bit à bit

```nasm
and rax, 0x0F       ; masque : ne garde que les 4 bits bas
or  rax, 0x80       ; active le bit 7
xor rax, rax        ; met rax à 0 (plus rapide que mov rax, 0)
not rax             ; inverse tous les bits

shl rax, 2          ; décale à gauche de 2 (multiplie par 4)
shr rax, 1          ; décale à droite de 1 (divise par 2, non signé)
sar rax, 1          ; décale à droite arithmétique (préserve le signe)
```
