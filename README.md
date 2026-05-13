# Tutoriel Assembleur x86-64 Complet

Un parcours d'apprentissage structuré du langage assembleur x86-64 (NASM, Linux), organisé en trois niveaux progressifs avec 19 chapitres et un projet final.

## Structure du tutoriel

### Niveau 1 — Fondamentaux (Chapitres 1–7)

| Chapitre | Sujet |
|----------|-------|
| 01 | Introduction (Hello World) |
| 02 | Registres x86-64 |
| 03 | Constantes et données |
| 04 | Opérations arithmétiques |
| 05 | Entrées/Sorties (appels système) |
| 06 | Conditions et sauts |
| 07 | Boucles |

### Niveau 2 — Intermédiaire (Chapitres 8–13)

| Chapitre | Sujet |
|----------|-------|
| 08 | Procédures et conventions d'appel |
| 09 | Tableaux |
| 10 | Chaînes de caractères |
| 11 | Modes d'adressage |
| 12 | Gestion de la pile |
| 13 | Fichiers (appels système) |

### Niveau 3 — Avancé (Chapitres 14–19)

| Chapitre | Sujet |
|----------|-------|
| 14 | Macros NASM |
| 15 | Virgule flottante (SSE2) |
| 16 | Structures |
| 17 | Listes chaînées |
| 18 | SIMD / SSE / AVX |
| 19 | Multi-fichiers et édition de liens |

## Prérequis

- **Assembleur** : NASM 2.15+
- **Éditeur de liens** : ld (binutils) ou gcc
- **OS** : Linux x86-64
- **Débogueur** : GDB (recommandé)

## Installation de NASM

```bash
# Ubuntu/Debian
sudo apt install nasm

# Fedora/RHEL
sudo dnf install nasm

# Arch
sudo pacman -S nasm
```

## Compilation et exécution

```bash
# Compiler un fichier assembleur
nasm -f elf64 hello_world.asm -o hello_world.o

# Lier (sans bibliothèque C)
ld -o hello_world hello_world.o

# Exécuter
./hello_world
```

## Utiliser le Makefile

```bash
# Compiler tous les chapitres
make

# Compiler un chapitre spécifique
make ch01_hello_world

# Nettoyer les fichiers compilés
make clean
```

Les exécutables sont générés dans le dossier `prog/`.

## Structure des fichiers

```
assembly-tutorial/
├── ch01_introduction/       # Code source + README par chapitre
├── ch02_registres/
├── ...
├── ch19_multifichiers/
├── project/                 # Projet final capstone
├── docs/
│   ├── cours/               # Leçons détaillées
│   ├── exercices/           # Exercices pratiques
│   ├── solutions/           # Corrections annotées
│   └── annexes/             # Références et bonnes pratiques
├── Makefile
└── mkdocs.yml
```

## Outils recommandés

- **GDB** : `gdb ./programme` — débogueur interactif
- **strace** : `strace ./programme` — tracer les appels système
- **objdump** : `objdump -d programme` — désassembler un binaire
- **readelf** : `readelf -a programme` — inspecter le format ELF

## Normes de qualité

- Commentaires obligatoires pour chaque instruction non triviale
- Noms de labels descriptifs en `snake_case`
- Respect des conventions d'appel System V AMD64 ABI
- Vérification des appels système via `rax < 0` (valeur de retour négative = erreur)
