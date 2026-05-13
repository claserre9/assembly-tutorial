# Tutoriel Assembleur x86-64 — Du débutant à l'expert

Parcours progressif en **3 niveaux** pour maîtriser le langage assembleur x86-64 sous Linux, des instructions de base jusqu'au SIMD, aux structures et à la liaison multi-fichiers.

Cible : **x86-64 Linux**, **NASM 2.15+**. Outils : `nasm`, `ld`, `gdb`, `objdump`, `strace`, `readelf`.

## Structure du projet

```
assembly-tutorial/
├── ch01_introduction/       # Code source + README par chapitre
├── ch02_registres/
├── ...
├── ch19_multifichiers/
├── project/                 # Projet final capstone
├── docs/                    # Documentation MkDocs
├── Makefile
└── mkdocs.yml
```

## Sommaire

### Niveau 1 — Fondamentaux

| # | Chapitre | Thèmes abordés |
|---|----------|----------------|
| 1 | [Introduction — Hello World](ch01_introduction/README.md) | Structure d'un programme NASM, sections, `syscall`, compilation, `ld` |
| 2 | [Registres x86-64](ch02_registres/README.md) | Registres généraux, pointeurs, flags, conventions de nommage |
| 3 | [Constantes et données](ch03_constantes_donnees/README.md) | `db`, `dw`, `dd`, `dq`, `equ`, section `.data` / `.bss` |
| 4 | [Opérations arithmétiques](ch04_arithmetique/README.md) | `ADD`, `SUB`, `MUL`, `DIV`, `IMUL`, `IDIV`, overflow, flags |
| 5 | [Entrées/Sorties](ch05_entrees_sorties/README.md) | Appels système `read`/`write`, numéros syscall, registres de passage |
| 6 | [Conditions et sauts](ch06_conditions_sauts/README.md) | `CMP`, `TEST`, sauts conditionnels (`JE`, `JNE`, `JL`, `JG`...) |
| 7 | [Boucles](ch07_boucles/README.md) | `LOOP`, `DEC`/`JNZ`, compteurs, boucles imbriquées |

### Niveau 2 — Intermédiaire

| # | Chapitre | Thèmes abordés |
|---|----------|----------------|
| 8 | [Procédures et conventions d'appel](ch08_procedures/README.md) | `CALL`/`RET`, stack frame, System V AMD64 ABI, `rbp`/`rsp` |
| 9 | [Tableaux](ch09_tableaux/README.md) | Adressage indexé, itération, tableaux 2D, allocation `.bss` |
| 10 | [Chaînes de caractères](ch10_chaines/README.md) | `MOVS`, `CMPS`, `SCAS`, préfixe `REP`, longueur, copie |
| 11 | [Modes d'adressage](ch11_modes_adressage/README.md) | Immédiat, direct, indirect, base+offset, indexé avec échelle |
| 12 | [Gestion de la pile](ch12_pile/README.md) | `PUSH`/`POP`, alignement 16 octets, variables locales, red zone |
| 13 | [Fichiers](ch13_fichiers/README.md) | Syscalls `open`/`read`/`write`/`close`, descripteurs, flags `O_*` — **Projet : parseur de logs** |

### Niveau 3 — Avancé

| # | Chapitre | Thèmes abordés |
|---|----------|----------------|
| 14 | [Macros NASM](ch14_macros/README.md) | `%macro`, `%define`, paramètres, macros multi-lignes, `%rep` |
| 15 | [Virgule flottante SSE2](ch15_virgule_flottante/README.md) | Registres XMM, `MOVSS`/`MOVSD`, `ADDSS`, `MULSS`, conversions |
| 16 | [Structures](ch16_structures/README.md) | `struc`/`endstruc`, `istruc`, champs, alignement mémoire |
| 17 | [Listes chaînées](ch17_listes_chainees/README.md) | Allocation dynamique (`mmap`), pointeurs, parcours, libération |
| 18 | [SIMD — SSE/AVX](ch18_simd/README.md) | Registres YMM/ZMM, `VMOVAPS`, `VADDPS`, vectorisation, alignement |
| 19 | [Multi-fichiers et édition de liens](ch19_multifichiers/README.md) | `extern`/`global`, `ld`, bibliothèques statiques `.a`, `ar` — **Projet : bibliothèque utilitaire** |

## Prérequis

- **Assembleur** : NASM 2.15+ — `nasm --version`
- **Éditeur de liens** : `ld` (binutils) ou `gcc`
- **OS** : Linux x86-64
- **Débogueur** : GDB (recommandé)

## Installation rapide

```bash
# Ubuntu/Debian
sudo apt install nasm binutils gdb

# Fedora/RHEL
sudo dnf install nasm binutils gdb

# Arch
sudo pacman -S nasm binutils gdb

# Vérifier
nasm --version   # >= 2.15
ld --version
```

## Compilation et exécution

```bash
# Compiler un fichier assembleur
nasm -f elf64 hello_world.asm -o hello_world.o

# Lier
ld -o hello_world hello_world.o

# Exécuter
./hello_world

# Compiler tous les chapitres via Makefile
make
make clean
```

## Outils de débogage

- **GDB** : `gdb ./programme` — débogueur interactif
- **strace** : `strace ./programme` — tracer les appels système
- **objdump** : `objdump -d programme` — désassembler un binaire
- **readelf** : `readelf -a programme` — inspecter le format ELF

## Parcours recommandé

1. Lire le README du chapitre
2. Étudier et exécuter le code source `.asm`
3. Modifier, expérimenter, casser — c'est ainsi qu'on apprend l'assembleur
4. Ne pas sauter les encadrés "Piège courant" et "Sous le capot"

## Licence

MIT — Clifford