# Annexe B — Débogage avec GDB

## Compiler avec les symboles de débogage

```bash
nasm -f elf64 -g -F dwarf programme.asm -o programme.o
ld -o programme programme.o
```

L'option `-g -F dwarf` inclut les informations de débogage au format DWARF.

## Commandes GDB essentielles

### Démarrage

```bash
gdb ./programme         # lancer GDB
gdb -tui ./programme    # interface textuelle (TUI)
```

### Dans GDB

| Commande | Abréviation | Action |
|----------|-------------|--------|
| `run` | `r` | Exécuter le programme |
| `run arg1 arg2` | | Exécuter avec arguments |
| `quit` | `q` | Quitter GDB |
| `help` | `h` | Aide |

### Breakpoints (points d'arrêt)

```gdb
break _start            ; arrêt au début
break mon_label         ; arrêt à un label
break *0x401000         ; arrêt à une adresse
info breakpoints        ; lister les breakpoints
delete 1                ; supprimer le breakpoint 1
```

### Exécution pas à pas

| Commande | Action |
|----------|--------|
| `stepi` / `si` | Exécuter une instruction (entre dans les appels) |
| `nexti` / `ni` | Exécuter une instruction (saute les appels) |
| `continue` / `c` | Continuer jusqu'au prochain breakpoint |
| `finish` | Continuer jusqu'au `ret` de la procédure courante |

### Inspecter les registres

```gdb
info registers          ; afficher tous les registres
info registers rax rbx  ; afficher rax et rbx seulement
print $rax              ; valeur de rax en décimal
print/x $rax            ; en hexadécimal
print/t $rax            ; en binaire
```

### Inspecter la mémoire

```gdb
x/10xg $rsp             ; afficher 10 qwords depuis rsp (format hexadécimal)
x/s msg                 ; afficher msg comme chaîne
x/20i $rip              ; désassembler 20 instructions depuis rip
```

Format : `x/[count][format][size] adresse`
- Formats : `x` (hex), `d` (décimal), `s` (string), `i` (instruction)
- Tailles : `b` (byte), `h` (halfword/2), `w` (word/4), `g` (giant/8)

### Modifier des valeurs

```gdb
set $rax = 42           ; modifier rax
set {long}0x601000 = 99 ; modifier la mémoire
```

## Autres outils de débogage

### strace — Tracer les appels système

```bash
strace ./programme
strace -e trace=write,read ./programme   ; filtrer par syscall
```

### ltrace — Tracer les appels de bibliothèque

```bash
ltrace ./programme
```

### objdump — Désassembler un binaire

```bash
objdump -d -M intel programme   ; désassembler (syntaxe Intel)
objdump -s -j .data programme   ; afficher la section .data
```

### readelf — Inspecter l'ELF

```bash
readelf -h programme    ; en-tête ELF
readelf -S programme    ; sections
readelf -s programme    ; table des symboles
```

### valgrind — Détecter les erreurs mémoire

```bash
valgrind --tool=memcheck --leak-check=full ./programme
```

## Exemple de session GDB

```gdb
$ gdb -tui ./hello_world
(gdb) break _start
(gdb) run
(gdb) info registers
(gdb) si                    ; step into
(gdb) x/s msg               ; afficher le message
(gdb) continue
(gdb) quit
```
