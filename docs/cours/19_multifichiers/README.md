# Chapitre 19 — Multi-fichiers et édition de liens

## 19.1 Pourquoi diviser en plusieurs fichiers ?

- **Maintenabilité** : chaque fichier est responsable d'un module (I/O, maths, chaînes…)
- **Réutilisabilité** : compiler une fois, lier plusieurs fois
- **Temps de compilation** : ne recompiler que les fichiers modifiés

---

## 19.2 `global` et `extern`

### `global` — Exporter un symbole

`global` rend un symbole (étiquette) visible pour l'éditeur de liens et les autres fichiers objets.

```nasm
; math.asm
section .text

global add_deux      ; rendre add_deux accessible depuis d'autres fichiers
global mul_trois

add_deux:
    mov  rax, rdi
    add  rax, rsi
    ret

mul_trois:
    imul rdi, 3
    mov  rax, rdi
    ret
```

### `extern` — Importer un symbole

`extern` déclare qu'un symbole est défini dans un autre fichier objet.

```nasm
; main.asm
extern add_deux
extern mul_trois
extern printf       ; depuis la bibliothèque C (libc)

section .text
global _start

_start:
    mov  rdi, 10
    mov  rsi, 32
    call add_deux   ; rax = 42

    mov  rdi, 14
    call mul_trois  ; rax = 42
    ...
```

---

## 19.3 Compilation séparée

Chaque fichier `.asm` est assemblé indépendamment en un fichier objet `.o` :

```bash
# Assembler chaque fichier
nasm -f elf64 -o main.o    main.asm
nasm -f elf64 -o math.o    math.asm
nasm -f elf64 -o io.o      io.asm

# Lier tous les fichiers objets
ld -o programme main.o math.o io.o
```

### Lier avec la bibliothèque C

```bash
nasm -f elf64 -o main.o main.asm

# Utiliser gcc comme frontal pour lier avec libc
gcc -nostartfiles -o programme main.o
# Ou avec ld directement :
ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 \
   -lc -o programme main.o
```

---

## 19.4 Fichiers d'en-tête `.inc`

Les fichiers `.inc` contiennent des **définitions partagées** : constantes, macros, déclarations `extern`.

```nasm
; syscalls.inc
%ifndef SYSCALLS_INC
%define SYSCALLS_INC

%define SYS_READ    0
%define SYS_WRITE   1
%define SYS_OPEN    2
%define SYS_CLOSE   3
%define SYS_EXIT    60

%define STDIN       0
%define STDOUT      1
%define STDERR      2

%endif  ; SYSCALLS_INC
```

```nasm
; structs.inc
%include "syscalls.inc"

struc Node
    .value  resq 1
    .next   resq 1
endstruc

extern alloc_node
extern free_node
```

Inclusion dans les fichiers sources :

```nasm
; main.asm
%include "syscalls.inc"
%include "structs.inc"

extern print_int
extern print_str
```

---

## 19.5 Makefile pour un projet multi-fichiers

```makefile
ASM    = nasm
ASMFLAGS = -f elf64
LD     = ld
TARGET = programme

SRCS   = main.asm math.asm io.asm strings.asm
OBJS   = $(SRCS:.asm=.o)

$(TARGET): $(OBJS)
	$(LD) -o $@ $^

%.o: %.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

clean:
	rm -f $(OBJS) $(TARGET)
```

---

## 19.6 Organisation recommandée d'un projet

```
projet/
├── Makefile
├── include/
│   ├── syscalls.inc    # constantes syscall
│   ├── macros.inc      # macros utilitaires
│   └── structs.inc     # définitions de structures
└── src/
    ├── main.asm        # point d'entrée (_start ou main)
    ├── io.asm          # fonctions I/O (print_int, read_line…)
    ├── math.asm        # fonctions mathématiques
    └── strings.asm     # fonctions de chaînes (strlen, strcpy…)
```

---

## 19.7 Variables globales partagées

Une variable définie dans un fichier peut être utilisée dans un autre :

```nasm
; globals.asm
section .data
global erreur_msg
global erreur_len

erreur_msg db "Erreur !", 0x0A
erreur_len equ $ - erreur_msg
```

```nasm
; main.asm
extern erreur_msg
extern erreur_len

    mov  rsi, erreur_msg
    mov  rdx, erreur_len
    ...
```

---

## 19.8 Liaison avec C — Interopérabilité

Depuis un programme C, on peut appeler des fonctions assembleur déclarées avec `global` :

```c
// main.c
#include <stdio.h>

extern long add_deux(long a, long b);   // défini dans math.asm
extern long mul_trois(long n);

int main(void) {
    printf("%ld\n", add_deux(10, 32));  // affiche 42
    printf("%ld\n", mul_trois(14));     // affiche 42
    return 0;
}
```

```bash
nasm -f elf64 -o math.o math.asm
gcc -o programme main.c math.o
```

> Ne pas oublier `push rbp` / `mov rbp, rsp` / `leave` dans les fonctions assembleur appelées depuis C pour respecter la convention ABI.

---

## Résumé

| Directive | Effet |
|-----------|-------|
| `global nom` | Exporte `nom` (visible par l'éditeur de liens) |
| `extern nom` | Déclare `nom` défini ailleurs |
| `%include "f.inc"` | Inclusion textuelle de `f.inc` |
| `%ifndef` ... `%endif` | Protection contre les inclusions multiples |

**Commandes clés :**

```bash
nasm -f elf64 -o fichier.o fichier.asm   # assembler
ld -o programme a.o b.o c.o              # lier
gcc -nostartfiles -o programme *.o       # lier avec libc
make                                     # build automatisé
```

- Protéger chaque `.inc` avec `%ifndef`/`%define`/`%endif` pour éviter les inclusions doubles.
- Utiliser `global` uniquement pour les symboles qui doivent être visibles à l'extérieur du fichier.
- Préférer des noms de symboles explicites et préfixés par module (`io_print_int`, `str_strlen`) pour éviter les conflits de noms.
