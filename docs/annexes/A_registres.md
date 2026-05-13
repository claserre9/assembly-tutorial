# Annexe A — Registres x86-64

## Registres généraux

| 64 bits | 32 bits | 16 bits | 8 bits haut | 8 bits bas | Convention |
|---------|---------|---------|-------------|------------|-----------|
| `rax`   | `eax`   | `ax`    | `ah`        | `al`       | Valeur de retour, accumulateur |
| `rbx`   | `ebx`   | `bx`    | `bh`        | `bl`       | **Préservé** (callee-saved) |
| `rcx`   | `ecx`   | `cx`    | `ch`        | `cl`       | 4e argument, compteur |
| `rdx`   | `edx`   | `dx`    | `dh`        | `dl`       | 3e argument, extension de rax |
| `rsi`   | `esi`   | `si`    | —           | `sil`      | 2e argument, source |
| `rdi`   | `edi`   | `di`    | —           | `dil`      | 1er argument, destination |
| `rbp`   | `ebp`   | `bp`    | —           | `bpl`      | **Préservé**, pointeur de cadre |
| `rsp`   | `esp`   | `sp`    | —           | `spl`      | Pointeur de pile |
| `r8`    | `r8d`   | `r8w`   | —           | `r8b`      | 5e argument |
| `r9`    | `r9d`   | `r9w`   | —           | `r9b`      | 6e argument |
| `r10`   | `r10d`  | `r10w`  | —           | `r10b`     | Temporaire |
| `r11`   | `r11d`  | `r11w`  | —           | `r11b`     | Temporaire |
| `r12`   | `r12d`  | `r12w`  | —           | `r12b`     | **Préservé** |
| `r13`   | `r13d`  | `r13w`  | —           | `r13b`     | **Préservé** |
| `r14`   | `r14d`  | `r14w`  | —           | `r14b`     | **Préservé** |
| `r15`   | `r15d`  | `r15w`  | —           | `r15b`     | **Préservé** |

## Registres spéciaux

| Registre | Nom | Description |
|----------|-----|-------------|
| `rip` | Instruction Pointer | Adresse de la prochaine instruction |
| `rflags` | Flags | ZF, CF, OF, SF, PF, DF, IF... |
| `rsp` | Stack Pointer | Sommet de la pile (pointe toujours vers le dernier push) |
| `rbp` | Base Pointer | Référence du cadre de pile courant |

## Registres de segment

| Registre | Usage |
|----------|-------|
| `cs` | Code Segment |
| `ds` | Data Segment |
| `ss` | Stack Segment |
| `es`, `fs`, `gs` | Extra Segments (fs/gs utilisés par les OS pour TLS) |

## Registres flottants / SIMD

| Registre | Taille | Extension |
|----------|--------|-----------|
| `xmm0`–`xmm15` | 128 bits | SSE/SSE2 |
| `ymm0`–`ymm15` | 256 bits | AVX |
| `zmm0`–`zmm31` | 512 bits | AVX-512 |
| `mm0`–`mm7` | 64 bits | MMX (obsolète) |
| `st(0)`–`st(7)` | 80 bits | x87 FPU (flottant étendu) |

## Drapeaux RFLAGS

| Bit | Drapeau | Nom | Signification |
|-----|---------|-----|---------------|
| 0 | CF | Carry Flag | Retenue (non signé) |
| 2 | PF | Parity Flag | Parité du résultat |
| 4 | AF | Auxiliary Carry | Retenue BCD |
| 6 | ZF | Zero Flag | Résultat = 0 |
| 7 | SF | Sign Flag | Résultat négatif |
| 8 | TF | Trap Flag | Mode pas à pas (débogage) |
| 9 | IF | Interrupt Flag | Interruptions activées |
| 10 | DF | Direction Flag | Direction des instructions de chaîne |
| 11 | OF | Overflow Flag | Dépassement signé |

## Résumé : callee-saved vs caller-saved

**Callee-saved (préservés par la procédure appelée)** : `rbx`, `rbp`, `r12`, `r13`, `r14`, `r15`

**Caller-saved (à sauvegarder avant l'appel si nécessaire)** : `rax`, `rcx`, `rdx`, `rsi`, `rdi`, `r8`, `r9`, `r10`, `r11`

> `syscall` détruit `rcx` et `r11` — les sauvegarder si nécessaire.
