# Cours 02 — Registres x86-64

## Qu'est-ce qu'un registre ?

Un registre est une **petite mémoire ultra-rapide intégrée au processeur**. Les opérations arithmétiques et logiques se font exclusivement sur des registres. Les données sont chargées depuis la mémoire dans les registres, traitées, puis éventuellement re-stockées en mémoire.

## Les 16 registres généraux (64 bits)

| Registre | Sous-parties | Convention d'appel |
|----------|-------------|-------------------|
| `rax` | `eax`, `ax`, `ah`, `al` | Valeur de retour, accumulateur |
| `rbx` | `ebx`, `bx`, `bh`, `bl` | Préservé (callee-saved) |
| `rcx` | `ecx`, `cx`, `ch`, `cl` | 4e argument, compteur |
| `rdx` | `edx`, `dx`, `dh`, `dl` | 3e argument, données |
| `rsi` | `esi`, `si`, `sil` | 2e argument, source |
| `rdi` | `edi`, `di`, `dil` | 1er argument, destination |
| `rbp` | `ebp`, `bp`, `bpl` | Pointeur de cadre (préservé) |
| `rsp` | `esp`, `sp`, `spl` | Pointeur de pile |
| `r8`  | `r8d`, `r8w`, `r8b` | 5e argument |
| `r9`  | `r9d`, `r9w`, `r9b` | 6e argument |
| `r10`–`r11` | ... | Temporaires (caller-saved) |
| `r12`–`r15` | ... | Préservés (callee-saved) |

## Sous-parties d'un registre

```
rax (64 bits)
┌────────────────────────────────────────┐
│                  rax                   │
├──────────────────────┬─────────────────┤
│                      │      eax        │
├──────────────────────┬────────┬────────┤
│                      │        │   ax   │
├──────────────────────┬────────┬────┬───┤
│                      │        │ ah │ al│
└──────────────────────┴────────┴────┴───┘
```

## Registres spéciaux

- **`rip`** : Instruction Pointer — ne peut pas être accédé directement, mais peut être lu via `lea rax, [rel label]`
- **`rflags`** : Registre d'état — bits : ZF (zéro), CF (retenue), SF (signe), OF (dépassement), PF (parité)

## Comportement particulier avec les sous-parties

```nasm
mov rax, 0xFFFFFFFFFFFFFFFF  ; rax = tous les bits à 1
mov eax, 0                   ; rax = 0 (les 32 bits supérieurs sont AUSSI mis à 0)
mov ax,  0                   ; rax = 0xFFFFFFFF0000FFFF (bits 63-16 et 15 inchangés)
mov al,  0                   ; rax = 0xFFFFFFFFFFFF00FF (seul l'octet bas est modifié)
```

> **Règle importante** : Écrire dans `eXX` (32 bits) met à zéro les 32 bits supérieurs. Écrire dans `XX`, `Xh`, `Xl` (16 ou 8 bits) ne modifie pas les bits non ciblés.

## Exemple de code

Voir `ch02_registres/registres.asm` pour un programme démontrant l'utilisation des registres et de leurs sous-parties.
