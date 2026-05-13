# Chapitre 14 — Macros NASM

## Concepts abordés

- Directive `%define` (substitution textuelle)
- Macros multi-lignes avec `%macro` / `%endmacro`
- Arguments de macro (`%1`, `%2`, ...)
- Labels locaux dans une macro (`%%label`)
- `%ifdef`, `%ifndef`, `%if` (compilation conditionnelle)
- Inclusion de fichiers avec `%include`

## `%define` — Constantes et substitutions

```nasm
%define STDOUT    1
%define SYS_WRITE 1
%define NULL      0

; Utilisation
mov rdi, STDOUT     ; équivalent à : mov rdi, 1
```

## `%macro` — Macros multi-lignes

```nasm
; Définition
%macro nom_macro nb_arguments
    ; corps (utiliser %1, %2, ... pour les arguments)
%endmacro

; Exemple : macro print(adresse, longueur)
%macro print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

; Appel
print msg, msg_len
```

## Labels locaux avec `%%`

```nasm
%macro boucle_n 1
    mov rcx, %1
%%debut:
    ; corps
    loop %%debut        ; %%debut est unique à chaque expansion
%endmacro
```

## Compilation conditionnelle

```nasm
%define DEBUG 1

%ifdef DEBUG
    ; code de débogage uniquement
%endif

%if MAX_SIZE > 100
    ; code alternatif
%endif
```

## Inclusion de fichiers

```nasm
%include "macros_communs.asm"   ; inclure un fichier de macros partagées
```

## Macro utile : `defstr`

```nasm
%macro defstr 2
    %1      db  %2
    %1_len  equ $ - %1
%endmacro

; Utilisation
defstr msg, "Bonjour!", 10
; Génère : msg db "Bonjour!", 10
;          msg_len equ ...
```
