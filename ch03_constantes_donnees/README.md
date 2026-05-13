# Chapitre 03 — Constantes et données

## Concepts abordés

- Directive `equ` pour les constantes symboliques
- Sections `.data`, `.bss`, `.rodata`
- Directives de données : `db`, `dw`, `dd`, `dq`
- Directives de réservation : `resb`, `resw`, `resd`, `resq`
- Opérateur `$` pour calculer des tailles

## Directive `equ`

```nasm
MAX     equ 100         ; constante entière
NL      equ 10          ; saut de ligne (ASCII)
msg_len equ $ - msg     ; longueur d'une chaîne
```

`equ` ne réserve pas de mémoire — c'est un alias symbolique résolu à la compilation.

## Sections mémoire

| Section   | Contenu | Modifiable |
|-----------|---------|-----------|
| `.text`   | Code machine | Non |
| `.rodata` | Constantes (chaînes littérales) | Non |
| `.data`   | Variables globales initialisées | Oui |
| `.bss`    | Variables non initialisées | Oui |

## Directives de déclaration de données

```nasm
octet   db  42          ; Define Byte    — 1 octet
mot     dw  1000        ; Define Word    — 2 octets
dword   dd  100000      ; Define Dword   — 4 octets
qword   dq  1000000000  ; Define Qword   — 8 octets
chaine  db  "Bonjour", 0  ; chaîne terminée par null
```

## Directives de réservation (section .bss)

```nasm
tampon  resb 64     ; Reserve Bytes    — 64 octets
valeur  resq 1      ; Reserve Qwords   — 8 octets
```

## Accès mémoire

```nasm
mov rax, [variable]         ; charger 64 bits depuis variable
mov byte [variable], 0xFF   ; stocker 1 octet
mov qword [variable], 0     ; stocker 8 octets
```
