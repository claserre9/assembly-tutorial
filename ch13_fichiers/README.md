# Chapitre 13 — Fichiers (appels système)

## Concepts abordés

- `sys_open` (2) : ouvrir ou créer un fichier
- `sys_read` (0) : lire depuis un descripteur
- `sys_write` (1) : écrire vers un descripteur
- `sys_close` (3) : fermer un descripteur
- `sys_lseek` (8) : déplacer le curseur dans un fichier
- Flags d'ouverture et permissions (mode octal)

## Flags d'ouverture

```nasm
O_RDONLY  equ 0        ; lecture seule
O_WRONLY  equ 1        ; écriture seule
O_RDWR    equ 2        ; lecture/écriture
O_CREAT   equ 0x40     ; créer si inexistant
O_TRUNC   equ 0x200    ; tronquer à 0 octets à l'ouverture
O_APPEND  equ 0x400    ; ajouter à la fin
```

## Ouvrir un fichier

```nasm
; sys_open(pathname, flags, mode)
mov rax, 2
mov rdi, nom_fichier        ; pointeur vers la chaîne (null-terminée)
mov rsi, O_WRONLY | O_CREAT | O_TRUNC
mov rdx, 0o644              ; permissions Unix
syscall
; rax = fd si >= 0, errno si < 0
```

## Écrire / lire

```nasm
; sys_write(fd, buf, count)
mov rax, 1
mov rdi, fd
mov rsi, buffer
mov rdx, longueur
syscall

; sys_read(fd, buf, count)
mov rax, 0
mov rdi, fd
mov rsi, buffer
mov rdx, taille_max
syscall
; rax = octets lus (0 = fin de fichier)
```

## Fermer un fichier

```nasm
mov rax, 3
mov rdi, fd
syscall
```

## Vérification des erreurs

```nasm
syscall
test rax, rax
js   erreur         ; rax < 0 signifie une erreur (valeur = -errno)
```
