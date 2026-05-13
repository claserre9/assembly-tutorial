# Cours 03 — Constantes et données

## Directive `equ` — Constantes symboliques

`equ` définit une **constante symbolique** résolue à la compilation. Elle ne réserve pas de mémoire.

```nasm
MAX_SIZE    equ 256
SYS_WRITE   equ 1
NEWLINE     equ 10       ; code ASCII du saut de ligne
msg_len     equ $ - msg  ; taille d'une chaîne ($ = adresse courante)
```

## Sections de données

### `.data` — Variables globales initialisées

```nasm
section .data
    compteur    dq  0
    pi          dq  3.14159265358979
    message     db  "Bonjour", 10, 0    ; chaîne + '\n' + null
    flag        db  1
```

### `.bss` — Variables non initialisées

Réservation d'espace mémoire initialisé à zéro par le noyau :

```nasm
section .bss
    tampon      resb 256    ; 256 octets
    table       resq 10     ; 10 × 8 = 80 octets
```

### `.rodata` — Constantes en lecture seule

```nasm
section .rodata
    titre       db  "Mon programme", 10
    titre_len   equ $ - titre
```

## Directives de données

| Directive | Signification | Taille |
|-----------|---------------|--------|
| `db` | Define Byte | 1 octet |
| `dw` | Define Word | 2 octets |
| `dd` | Define Dword | 4 octets |
| `dq` | Define Qword | 8 octets |
| `resb n` | Reserve Bytes | n × 1 octet |
| `resw n` | Reserve Words | n × 2 octets |
| `resd n` | Reserve Dwords | n × 4 octets |
| `resq n` | Reserve Qwords | n × 8 octets |

## Opérateur `$`

`$` représente l'**adresse de la position courante** dans la section. Utilisé pour calculer des tailles :

```nasm
msg     db  "Bonjour"
msg_len equ $ - msg     ; $ = adresse après "Bonjour", donc longueur = 7
```

## Voir aussi

Fichiers sources : `ch03_constantes_donnees/constantes.asm` et `donnees.asm`
