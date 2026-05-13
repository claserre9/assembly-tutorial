# Chapitre 06 — Conditions et sauts

## Concepts abordés

- Instruction `cmp` et drapeaux du registre `rflags`
- Sauts inconditionnels (`jmp`)
- Sauts conditionnels (`je`, `jne`, `jl`, `jg`, `jle`, `jge`...)
- Instruction `test` (AND sans stocker le résultat)
- Instruction `cmov` (déplacement conditionnel)

## Drapeaux importants (RFLAGS)

| Drapeau | Nom | Mis à 1 quand... |
|---------|-----|------------------|
| `ZF` | Zero Flag | Résultat = 0 |
| `SF` | Sign Flag | Résultat négatif |
| `CF` | Carry Flag | Retenue (non signé) |
| `OF` | Overflow Flag | Dépassement (signé) |
| `PF` | Parity Flag | Parité du résultat |

## Instruction `cmp`

```nasm
cmp rax, rbx    ; calcule rax - rbx et positionne les drapeaux
                ; ne modifie pas rax ni rbx
```

## Sauts conditionnels

| Instruction | Condition | Signé/Non signé |
|-------------|-----------|-----------------|
| `je` / `jz` | égal / zéro | — |
| `jne` / `jnz` | différent / non zéro | — |
| `jl` / `jnge` | inférieur strict | signé |
| `jle` / `jng` | inférieur ou égal | signé |
| `jg` / `jnle` | supérieur strict | signé |
| `jge` / `jnl` | supérieur ou égal | signé |
| `jb` / `jnae` | inférieur strict | non signé |
| `jbe` / `jna` | inférieur ou égal | non signé |
| `ja` / `jnbe` | supérieur strict | non signé |
| `jae` / `jnb` | supérieur ou égal | non signé |

## Exemple : if/else

```nasm
    cmp rax, 0
    jg  est_positif
    ; bloc "else"
    jmp fin
est_positif:
    ; bloc "if"
fin:
```

## Instruction `test`

```nasm
test rax, rax       ; met ZF=1 si rax == 0 (plus rapide que cmp rax, 0)
test rax, 1         ; teste si le bit 0 est actif
jz  valeur_nulle
```
