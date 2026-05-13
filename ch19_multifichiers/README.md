# Chapitre 19 — Multi-fichiers et édition de liens

## Concepts abordés

- Déclaration de symboles publics avec `global`
- Importation de symboles externes avec `extern`
- Compilation séparée de plusieurs fichiers `.asm`
- Édition de liens (`ld`) de plusieurs fichiers objets
- Organisation en modules réutilisables

## `global` — Exporter un symbole

```nasm
; Dans utils.asm
global print_uint   ; rendre print_uint visible depuis l'extérieur
global strlen_util

print_uint:
    ; ...
    ret
```

## `extern` — Importer un symbole

```nasm
; Dans main.asm
extern print_uint   ; déclarer que print_uint est défini ailleurs
extern strlen_util

_start:
    mov rdi, 42
    call print_uint  ; appel vers utils.asm
```

## Compilation séparée

```bash
# Compiler chaque fichier séparément
nasm -f elf64 utils.asm -o utils.o
nasm -f elf64 main.asm  -o main.o

# Lier les fichiers objets ensemble
ld -o programme main.o utils.o
```

## Organisation recommandée

```
projet/
├── main.asm          # point d'entrée (_start)
├── io_utils.asm      # fonctions d'entrée/sortie
├── math_utils.asm    # fonctions mathématiques
├── string_utils.asm  # manipulation de chaînes
└── Makefile          # automatisation de la compilation
```

## Fichiers d'en-tête NASM

Pour partager des constantes et macros entre plusieurs fichiers, créer un fichier `.inc` :

```nasm
; constants.inc
%define STDOUT      1
%define SYS_WRITE   1
%define SYS_EXIT    60

%include "constants.inc"    ; dans chaque fichier .asm
```

## Avantages de la séparation en modules

- Compilation incrémentale (recompiler uniquement les fichiers modifiés)
- Réutilisation de code entre projets
- Meilleure organisation et lisibilité
- Parallélisation possible de la compilation
