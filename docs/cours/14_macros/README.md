# Chapitre 14 — Macros NASM

## 14.1 `%define` — Constantes et substitutions textuelles

`%define` effectue une **substitution textuelle** à la compilation (comparable à `#define` en C).

```nasm
%define STDOUT      1
%define SYS_WRITE   1
%define SYS_EXIT    60
%define NEWLINE     0x0A
%define NULL        0

; Utilisation
mov  rax, SYS_WRITE
mov  rdi, STDOUT
```

`%define` peut aussi définir des expressions avec paramètres :

```nasm
%define ALIGN16(n)  (((n) + 15) & ~15)

; rsp -= ALIGN16(24) → rsp -= 32
sub  rsp, ALIGN16(24)
```

### `%xdefine` — Expansion immédiate

`%xdefine` évalue les macros en cours de définition (évite les récursions) :

```nasm
%define  A  10
%define  B  A         ; B = A (évalué plus tard)
%xdefine C  A         ; C = 10 maintenant (figé)
%define  A  20
; B vaut maintenant 20, C vaut toujours 10
```

---

## 14.2 `%macro` / `%endmacro` — Macros multi-lignes

```nasm
%macro nom_macro nb_arguments
    ; corps (utilise %1, %2, ... pour les arguments)
%endmacro
```

### Exemple : macro d'appel système

```nasm
%macro syscall3 4       ; 4 arguments : numéro, arg1, arg2, arg3
    mov  rax, %1
    mov  rdi, %2
    mov  rsi, %3
    mov  rdx, %4
    syscall
%endmacro

; Utilisation :
syscall3 1, 1, message, msg_len     ; write(stdout, message, msg_len)
```

### Exemple : macro exit

```nasm
%macro exit 1           ; 1 argument : code de retour
    mov  rax, 60
    mov  rdi, %1
    syscall
%endmacro

; Utilisation :
exit 0
exit 1
```

---

## 14.3 Étiquettes locales dans les macros (`%%label`)

Les étiquettes ordinaires dans une macro causeraient des conflits si la macro est utilisée plusieurs fois. Utiliser `%%` pour créer des étiquettes uniques automatiquement.

```nasm
%macro print_if_nonzero 2   ; %1 = registre, %2 = adresse message
    test %1, %1
    jz   %%skip             ; %%skip devient .skip@N unique
    mov  rax, 1
    mov  rdi, 1
    mov  rsi, %2
    mov  rdx, 20
    syscall
%%skip:
%endmacro

; Utilisation répétée sans conflit d'étiquettes :
print_if_nonzero rax, msg1
print_if_nonzero rbx, msg2
```

---

## 14.4 Macros avec nombre variable d'arguments

```nasm
%macro PUSH_ALL 0
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
%endmacro

%macro POP_ALL 0
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    pop  rax
%endmacro
```

---

## 14.5 `%include` — Inclure un fichier

```nasm
%include "syscalls.inc"     ; inclure des définitions depuis un fichier
%include "macros.inc"
```

Cela fonctionne comme un copier-coller textuel. Idéal pour partager des constantes et macros entre plusieurs fichiers.

**Exemple `syscalls.inc` :**

```nasm
%define SYS_READ    0
%define SYS_WRITE   1
%define SYS_OPEN    2
%define SYS_CLOSE   3
%define SYS_LSEEK   8
%define SYS_EXIT    60

%define STDIN       0
%define STDOUT      1
%define STDERR      2
```

---

## 14.6 Compilation conditionnelle

### `%ifdef` / `%ifndef` / `%else` / `%endif`

```nasm
%define DEBUG       ; décommenter pour activer le debug

%ifdef DEBUG
    ; Code de débogage uniquement
    mov  rax, 1
    mov  rdi, 2
    mov  rsi, dbg_msg
    mov  rdx, dbg_len
    syscall
%endif
```

### `%if` — Conditions numériques

```nasm
%define VERSION 2

%if VERSION >= 2
    ; code pour version >= 2
%elif VERSION == 1
    ; code pour version 1
%else
    ; code par défaut
%endif
```

---

## 14.7 `%assign` — Compteur à l'assemblage

```nasm
%assign i 0
%rep 4
    mov  dword [tableau + i*4], i
    %assign i i+1
%endrep
; Génère : mov [tableau+0], 0 ; mov [tableau+4], 1 ; etc.
```

---

## 14.8 Exemple complet : bibliothèque de macros I/O

```nasm
; io_macros.inc

%define SYS_WRITE   1
%define SYS_EXIT    60
%define STDOUT      1

%macro print 2          ; %1 = adresse, %2 = longueur
    push rax
    push rdi
    push rsi
    push rdx
    mov  rax, SYS_WRITE
    mov  rdi, STDOUT
    mov  rsi, %1
    mov  rdx, %2
    syscall
    pop  rdx
    pop  rsi
    pop  rdi
    pop  rax
%endmacro

%macro println 2        ; print avec newline
    print %1, %2
    push rax
    push rdi
    push rsi
    push rdx
    mov  rax, SYS_WRITE
    mov  rdi, STDOUT
    mov  rsi, _newline
    mov  rdx, 1
    syscall
    pop  rdx
    pop  rsi
    pop  rdi
    pop  rax
%endmacro

section .data
    _newline db 0x0A
```

---

## Résumé

| Directive | Usage |
|-----------|-------|
| `%define NOM val` | Constante / substitution textuelle |
| `%xdefine NOM val` | Expansion immédiate (figée) |
| `%macro nom nb_args` ... `%endmacro` | Macro multi-lignes |
| `%%label` | Étiquette locale dans une macro |
| `%include "fichier"` | Inclusion textuelle |
| `%ifdef` / `%if` | Compilation conditionnelle |
| `%assign i expr` | Compteur à l'assemblage |
| `%rep N` ... `%endrep` | Répétition de blocs |
