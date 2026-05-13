# Chapitre 6 — Conditions et sauts

## 6.1 RFLAGS : le registre d'état

Les instructions arithmétiques et logiques mettent à jour les drapeaux du registre `RFLAGS` :

| Drapeau | Bit | Signification                              |
|---------|-----|--------------------------------------------|
| CF      | 0   | Retenue (carry) — débordement non signé    |
| PF      | 2   | Parité (nombre pair de bits à 1, octet bas)|
| ZF      | 6   | Zéro — résultat nul                        |
| SF      | 7   | Signe — bit de poids fort à 1              |
| OF      | 11  | Débordement signé                          |

## 6.2 `cmp` vs `test`

### `cmp a, b`

Effectue `a - b` en silence (résultat non stocké) et met à jour les drapeaux.

```nasm
    cmp rax, 10     ; compare rax à 10 (calcule rax - 10)
    je  .egal       ; saute si rax == 10
```

### `test a, b`

Effectue `a AND b` en silence. Idéal pour tester si un registre est nul ou vérifier un bit.

```nasm
    test rax, rax   ; ZF=1 si rax == 0
    jz  .nul

    test rax, 1     ; ZF=0 si bit 0 est à 1 (nombre impair)
    jnz .impair
```

## 6.3 Table des sauts conditionnels

### Entiers non signés

| Mnémonique     | Alias | Condition          | Drapeaux        |
|----------------|-------|--------------------|-----------------|
| `je` / `jz`    |       | Égal / Zéro        | ZF=1            |
| `jne` / `jnz`  |       | Différent / Non-zéro | ZF=0          |
| `jb` / `jnae`  | `jc`  | En-dessous (Below) | CF=1            |
| `jae` / `jnb`  | `jnc` | Au-dessus-ou-égal  | CF=0            |
| `jbe`          | `jna` | En-dessous-ou-égal | CF=1 ou ZF=1    |
| `ja` / `jnbe`  |       | Au-dessus (Above)  | CF=0 et ZF=0    |

### Entiers signés

| Mnémonique  | Condition            | Drapeaux              |
|-------------|----------------------|-----------------------|
| `jl` / `jnge` | Inférieur (Less)   | SF ≠ OF               |
| `jge` / `jnl` | Supérieur-ou-égal  | SF = OF               |
| `jle` / `jng` | Inférieur-ou-égal  | ZF=1 ou SF≠OF         |
| `jg` / `jnle` | Supérieur (Greater)| ZF=0 et SF=OF         |

### Sauts inconditionnels

```nasm
    jmp .etiquette  ; saut direct
    jmp rax         ; saut indirect via registre
    jmp [rax]       ; saut indirect via mémoire
```

## 6.4 Patron if/else

```nasm
; if (rdi > rsi) { rax = rdi } else { rax = rsi }
    cmp rdi, rsi
    jle .sinon          ; saut si rdi <= rsi
.alors:
    mov rax, rdi
    jmp .fin
.sinon:
    mov rax, rsi
.fin:
```

## 6.5 Patron if/else if/else

```nasm
; switch-like : tester plusieurs valeurs
    cmp rax, 1
    je  .cas_un
    cmp rax, 2
    je  .cas_deux
    ; défaut
    jmp .defaut
.cas_un:
    ; ...
    jmp .fin
.cas_deux:
    ; ...
    jmp .fin
.defaut:
.fin:
```

## 6.6 `cmov` — déplacement conditionnel

`cmov` évite les sauts en effectuant un `mov` conditionnel (sans casser le pipeline du processeur).

```nasm
; rax = max(rdi, rsi)  — sans saut
    mov rax, rdi
    cmp rsi, rdi
    cmovg rax, rsi      ; si rsi > rdi, rax = rsi
```

| Instruction   | Condition           |
|---------------|---------------------|
| `cmove`       | ZF=1 (égal)         |
| `cmovne`      | ZF=0                |
| `cmovl`       | Inférieur signé     |
| `cmovg`       | Supérieur signé     |
| `cmovb`       | En-dessous non signé|
| `cmova`       | Au-dessus non signé |

## 6.7 Exemple complet : valeur absolue

```nasm
; rax = |rdi|
abs_val:
    mov rax, rdi
    neg rax             ; rax = -rdi
    cmovl rax, rdi      ; si -rdi < 0 (rdi > 0), rax = rdi
    ret
```

Ou plus idiomatiquement :

```nasm
abs_val:
    mov rax, rdi
    test rdi, rdi
    jns .positif        ; saut si SF=0 (non-négatif)
    neg rax
.positif:
    ret
```

## Résumé

- `cmp` soustrait sans stocker ; `test` fait un ET bit à bit sans stocker.
- Utiliser les variantes signées (`jl/jg`) pour les entiers signés, non signées (`jb/ja`) pour les entiers non signés.
- `cmov` élimine les sauts et améliore les performances sur pipelines modernes.
