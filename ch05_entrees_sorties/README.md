# Chapitre 05 — Entrées/Sorties (appels système)

## Concepts abordés

- Appel système `sys_write` (numéro 1)
- Appel système `sys_read` (numéro 0)
- Descripteurs de fichiers standards : stdin (0), stdout (1), stderr (2)
- Passage des paramètres via les registres

## Convention des appels système Linux x86-64

| Registre | Rôle |
|----------|------|
| `rax`    | Numéro du syscall |
| `rdi`    | 1er argument |
| `rsi`    | 2e argument |
| `rdx`    | 3e argument |
| `r10`    | 4e argument |
| `r8`     | 5e argument |
| `r9`     | 6e argument |

La valeur de retour est placée dans `rax`. Une valeur négative indique une erreur.

## Écrire sur stdout

```nasm
mov rax, 1          ; sys_write
mov rdi, 1          ; fd = stdout
mov rsi, msg        ; adresse du message
mov rdx, msg_len    ; nombre d'octets
syscall
```

## Lire depuis stdin

```nasm
mov rax, 0          ; sys_read
mov rdi, 0          ; fd = stdin
mov rsi, tampon     ; tampon de réception
mov rdx, taille     ; nombre max d'octets
syscall
; rax = nombre d'octets réellement lus
```

## Numéros de syscall courants

| Numéro | Nom | Description |
|--------|-----|-------------|
| 0 | `read` | Lire depuis un descripteur |
| 1 | `write` | Écrire vers un descripteur |
| 2 | `open` | Ouvrir un fichier |
| 3 | `close` | Fermer un descripteur |
| 60 | `exit` | Terminer le processus |

> La liste complète est dans `/usr/include/asm/unistd_64.h` ou via `man 2 syscall`.
