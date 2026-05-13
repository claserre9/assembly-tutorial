# Annexe C — Assemblage et édition de liens

## Processus de compilation assembleur

```
Fichier source (.asm)
        ↓  NASM
Fichier objet (.o)  [format ELF64]
        ↓  ld (ou gcc)
Exécutable ELF
```

## NASM — Commandes essentielles

### Assemblage de base

```bash
nasm -f elf64 fichier.asm -o fichier.o
```

### Options importantes

| Option | Description |
|--------|-------------|
| `-f elf64` | Format de sortie ELF 64 bits (Linux) |
| `-f elf32` | Format ELF 32 bits |
| `-f win64` | Format PE 64 bits (Windows) |
| `-g -F dwarf` | Informations de débogage DWARF |
| `-D NOM=val` | Définir une constante (comme `%define`) |
| `-l liste.lst` | Générer un fichier listing |
| `-I chemin/` | Répertoire pour `%include` |
| `-o sortie.o` | Nom du fichier de sortie |

### Exemples

```bash
# Compilation normale
nasm -f elf64 main.asm -o main.o

# Avec débogage
nasm -f elf64 -g -F dwarf main.asm -o main.o

# Avec définition de constante
nasm -f elf64 -DDEBUG=1 main.asm -o main.o
```

## Édition de liens avec `ld`

### Programme simple (sans libc)

```bash
ld -o programme main.o
ld -o programme main.o utils.o      # plusieurs fichiers objets
```

### Options de `ld`

| Option | Description |
|--------|-------------|
| `-o nom` | Nom de l'exécutable |
| `-static` | Lier statiquement |
| `-e _start` | Définir le point d'entrée (par défaut : `_start`) |

## Liaison avec `gcc` (accès à la libc)

Si votre programme utilise des fonctions C (printf, malloc, etc.) :

```bash
# Lier avec la libc standard
gcc -no-pie -nostartfiles main.o -o programme

# Avec plusieurs modules et -lmath
gcc -no-pie -nostartfiles main.o utils.o -lm -o programme
```

> `-no-pie` désactive le Position Independent Executable (plus simple pour débuter).  
> `-nostartfiles` évite d'inclure les fichiers de démarrage C (qui appellent `main`).

## Format ELF

L'**Executable and Linkable Format (ELF)** est le format standard des exécutables Linux.

### Sections typiques d'un ELF

| Section | Contenu |
|---------|---------|
| `.text` | Code machine exécutable |
| `.data` | Données initialisées (variables globales) |
| `.rodata` | Données en lecture seule (constantes) |
| `.bss` | Données non initialisées (réservation) |
| `.symtab` | Table des symboles |
| `.strtab` | Table des chaînes de symboles |
| `.debug_*` | Informations de débogage DWARF |

### Inspecter un ELF

```bash
readelf -h programme           # en-tête
readelf -S programme           # sections
readelf -s programme           # symboles
objdump -d -M intel programme  # désassemblage
file programme                 # type du fichier
```

## Multi-fichiers : workflow complet

```bash
# 1. Assembler chaque module
nasm -f elf64 main.asm   -o main.o
nasm -f elf64 utils.asm  -o utils.o
nasm -f elf64 io.asm     -o io.o

# 2. Lier tous les objets
ld -o programme main.o utils.o io.o

# 3. Exécuter
./programme
```

## Automatisation avec Make

```makefile
NASM = nasm
NASMFLAGS = -f elf64 -g -F dwarf
OBJS = main.o utils.o io.o

programme: $(OBJS)
	ld -o $@ $^

%.o: %.asm
	$(NASM) $(NASMFLAGS) $< -o $@

clean:
	rm -f *.o programme
```
