# Chapitre 08 — Procédures et conventions d'appel

## Concepts abordés

- Instructions `call` et `ret`
- Convention d'appel System V AMD64 ABI (Linux)
- Prologue et épilogue d'une procédure (`push rbp` / `pop rbp`)
- Passage d'arguments dans les registres
- Valeur de retour dans `rax`
- Récursivité

## Convention System V AMD64 ABI

### Passage des arguments (dans l'ordre)

| Position | Entier/Pointeur | Flottant |
|----------|-----------------|---------|
| 1er | `rdi` | `xmm0` |
| 2e  | `rsi` | `xmm1` |
| 3e  | `rdx` | `xmm2` |
| 4e  | `rcx` | `xmm3` |
| 5e  | `r8`  | `xmm4` |
| 6e  | `r9`  | `xmm5` |
| 7e+ | pile  | pile   |

### Valeur de retour

- Entier/pointeur : `rax` (et `rdx` pour 128 bits)
- Flottant : `xmm0`

### Registres préservés (callee-saved)

`rbx`, `rbp`, `r12`, `r13`, `r14`, `r15` — doivent être restaurés avant `ret`.

### Registres librement modifiables (caller-saved)

`rax`, `rcx`, `rdx`, `rsi`, `rdi`, `r8`, `r9`, `r10`, `r11`

## Structure standard d'une procédure

```nasm
ma_procedure:
    push rbp            ; sauvegarder le cadre appelant
    mov  rbp, rsp       ; établir le nouveau cadre
    sub  rsp, 16        ; espace pour les variables locales (multiple de 16)

    ; corps de la procédure

    mov  rsp, rbp       ; restaurer la pile
    pop  rbp
    ret
```

## Alignement de la pile

La pile **doit être alignée sur 16 octets** au moment de l'instruction `call`.  
`call` empile l'adresse de retour (8 octets), donc juste avant le `call` la pile doit être à `16n + 8`.
