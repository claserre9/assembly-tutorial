# Chapitre 02 — Registres x86-64

## Concepts abordés

- Les 16 registres généraux 64 bits
- Sous-parties des registres (32, 16, 8 bits)
- Registres spéciaux : `rsp`, `rbp`, `rip`, `rflags`
- Registres de segment : `cs`, `ds`, `ss`, `es`, `fs`, `gs`

## Tableau des registres généraux

| 64 bits | 32 bits | 16 bits | 8 bits (haut) | 8 bits (bas) | Usage conventionnel |
|---------|---------|---------|---------------|--------------|---------------------|
| `rax`   | `eax`   | `ax`    | `ah`          | `al`         | Valeur de retour, accumulateur |
| `rbx`   | `ebx`   | `bx`    | `bh`          | `bl`         | Registre de base (préservé) |
| `rcx`   | `ecx`   | `cx`    | `ch`          | `cl`         | Compteur (boucles) |
| `rdx`   | `edx`   | `dx`    | `dh`          | `dl`         | Données, extension de rax |
| `rsi`   | `esi`   | `si`    | —             | `sil`        | 2e argument, source |
| `rdi`   | `edi`   | `di`    | —             | `dil`        | 1er argument, destination |
| `rbp`   | `ebp`   | `bp`    | —             | `bpl`        | Pointeur de base de pile (préservé) |
| `rsp`   | `esp`   | `sp`    | —             | `spl`        | Pointeur de pile |
| `r8`    | `r8d`   | `r8w`   | —             | `r8b`        | 5e argument |
| `r9`    | `r9d`   | `r9w`   | —             | `r9b`        | 6e argument |
| `r10`–`r15` | ... | ...  | —             | ...          | Usage libre |

## Exemple d'utilisation

```nasm
mov rax, 1000       ; 64 bits
mov eax, 1000       ; 32 bits (met les 32 bits supérieurs à 0)
mov ax,  1000       ; 16 bits (ne modifie pas les bits supérieurs)
mov al,  42         ; 8 bits bas
mov ah,  42         ; 8 bits haut (bits 8-15)
```

## Registres spéciaux

- **`rsp`** : Stack Pointer — pointe toujours vers le sommet de la pile
- **`rbp`** : Base Pointer — référence du cadre de pile courant
- **`rip`** : Instruction Pointer — adresse de la prochaine instruction
- **`rflags`** : drapeaux d'état (ZF, CF, OF, SF, PF...)

## Rappel important

Écrire dans `eax` met automatiquement les 32 bits supérieurs de `rax` à zéro.
Écrire dans `ax`, `ah`, ou `al` ne modifie pas les bits non ciblés.
