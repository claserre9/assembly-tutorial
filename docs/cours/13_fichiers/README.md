# Chapitre 13 — Fichiers via syscalls Linux

## 13.1 Descripteurs de fichiers

Sous Linux, tout fichier est désigné par un **descripteur** (entier non négatif).

| Valeur | Descripteur standard |
|--------|---------------------|
| 0 | stdin |
| 1 | stdout |
| 2 | stderr |
| ≥ 3 | fichiers ouverts par le programme |

---

## 13.2 `sys_open` — Ouvrir un fichier

```nasm
; int open(const char *pathname, int flags, mode_t mode)
; rax = 2, rdi = chemin, rsi = flags, rdx = mode
; retourne : rax = fd (>= 0) ou erreur (< 0)
```

### Constantes de flags (à définir ou utiliser directement)

```nasm
%define O_RDONLY   0x000    ; lecture seule
%define O_WRONLY   0x001    ; écriture seule
%define O_RDWR     0x002    ; lecture + écriture
%define O_CREAT    0x040    ; créer si inexistant
%define O_TRUNC    0x200    ; tronquer à 0 à l'ouverture
%define O_APPEND   0x400    ; écrire à la fin
```

### Exemple : ouvrir en lecture

```nasm
section .data
    chemin db "/tmp/test.txt", 0

section .text
    mov  rax, 2             ; sys_open
    mov  rdi, chemin        ; chemin nul-terminé
    mov  rsi, 0             ; O_RDONLY
    xor  rdx, rdx           ; mode = 0 (ignoré pour O_RDONLY)
    syscall
    ; rax = fd ou erreur
    mov  r12, rax           ; sauvegarder le fd dans un registre callee-saved
```

### Exemple : créer/tronquer en écriture

```nasm
    mov  rax, 2
    mov  rdi, chemin
    mov  rsi, 0x241         ; O_WRONLY | O_CREAT | O_TRUNC
    mov  rdx, 0o644         ; permissions : rw-r--r--
    syscall
```

---

## 13.3 Vérification d'erreur

Après tout syscall, si `rax` est négatif (entre -4095 et -1), c'est un code d'erreur.

```nasm
    syscall
    test rax, rax
    js   .erreur            ; saut si rax < 0

    mov  r12, rax           ; fd valide
    jmp  .suite

.erreur:
    ; Afficher un message d'erreur sur stderr
    mov  rax, 1
    mov  rdi, 2             ; stderr
    mov  rsi, msg_err
    mov  rdx, msg_err_len
    syscall
    ; Terminer avec code d'erreur
    mov  rax, 60
    mov  rdi, 1
    syscall
```

---

## 13.4 `sys_read` — Lire depuis un fichier

```nasm
; ssize_t read(int fd, void *buf, size_t count)
; rax = 0, rdi = fd, rsi = buffer, rdx = taille_max
; retourne : rax = octets lus (0 = EOF, < 0 = erreur)

section .bss
    buf resb 512

section .text
    mov  rax, 0             ; sys_read
    mov  rdi, r12           ; fd sauvegardé
    mov  rsi, buf
    mov  rdx, 512
    syscall
    ; rax = nombre d'octets effectivement lus
    test rax, rax
    jz   .eof               ; rax == 0 : fin de fichier
    js   .erreur            ; rax < 0  : erreur
    mov  r13, rax           ; sauvegarder la taille lue
```

### Lire un fichier entier en boucle

```nasm
.read_loop:
    mov  rax, 0
    mov  rdi, r12           ; fd
    mov  rsi, buf
    mov  rdx, 512
    syscall
    test rax, rax
    jz   .eof
    js   .erreur
    ; traiter les rax octets dans buf
    ; ...
    jmp  .read_loop
.eof:
```

---

## 13.5 `sys_write` — Écrire dans un fichier

```nasm
; ssize_t write(int fd, const void *buf, size_t count)
; rax = 1, rdi = fd, rsi = buf, rdx = count
; retourne : rax = octets écrits (< 0 = erreur)

    mov  rax, 1
    mov  rdi, r12           ; fd
    mov  rsi, buf
    mov  rdx, r13           ; nombre d'octets à écrire
    syscall
```

---

## 13.6 `sys_lseek` — Déplacer le curseur

```nasm
; off_t lseek(int fd, off_t offset, int whence)
; rax = 8, rdi = fd, rsi = offset, rdx = whence
%define SEEK_SET 0          ; depuis le début
%define SEEK_CUR 1          ; depuis la position courante
%define SEEK_END 2          ; depuis la fin

; Aller au début du fichier
    mov  rax, 8
    mov  rdi, r12
    xor  rsi, rsi           ; offset = 0
    mov  rdx, SEEK_SET
    syscall

; Connaître la taille du fichier (aller à la fin, lire la position)
    mov  rax, 8
    mov  rdi, r12
    xor  rsi, rsi
    mov  rdx, SEEK_END
    syscall
    ; rax = taille du fichier
```

---

## 13.7 `sys_close` — Fermer un fichier

```nasm
; int close(int fd)
; rax = 3, rdi = fd
; retourne : 0 ou -errno

    mov  rax, 3
    mov  rdi, r12           ; fd
    syscall
```

> Toujours fermer les fichiers après utilisation pour libérer les ressources et s'assurer que les buffers noyau sont vidés.

---

## 13.8 Exemple complet : copie de fichier

```nasm
section .data
    src_path  db "source.txt",  0
    dst_path  db "copie.txt",   0

section .bss
    buf resb 4096

section .text
global _start

_start:
    push rbp
    mov  rbp, rsp

    ; Ouvrir la source en lecture
    mov  rax, 2
    mov  rdi, src_path
    xor  rsi, rsi           ; O_RDONLY
    xor  rdx, rdx
    syscall
    test rax, rax
    js   .exit_err
    mov  r12, rax           ; fd source

    ; Ouvrir la destination en écriture (créer/tronquer)
    mov  rax, 2
    mov  rdi, dst_path
    mov  rsi, 0x241         ; O_WRONLY | O_CREAT | O_TRUNC
    mov  rdx, 0o644
    syscall
    test rax, rax
    js   .close_src
    mov  r13, rax           ; fd destination

.copy_loop:
    mov  rax, 0             ; sys_read
    mov  rdi, r12
    mov  rsi, buf
    mov  rdx, 4096
    syscall
    test rax, rax
    jle  .done              ; 0 = EOF, < 0 = erreur

    mov  rdx, rax           ; nb octets à écrire
    mov  rax, 1             ; sys_write
    mov  rdi, r13
    mov  rsi, buf
    syscall
    jmp  .copy_loop

.done:
    mov  rax, 3             ; close destination
    mov  rdi, r13
    syscall
.close_src:
    mov  rax, 3             ; close source
    mov  rdi, r12
    syscall
.exit_err:
    xor  rdi, rdi
    mov  rax, 60
    syscall
```

---

## Résumé

| Syscall | Numéro | Arguments clés |
|---------|--------|----------------|
| `read` | 0 | fd, buf, count |
| `write` | 1 | fd, buf, count |
| `open` | 2 | path, flags, mode |
| `close` | 3 | fd |
| `lseek` | 8 | fd, offset, whence |

- Vérifier `rax < 0` après chaque syscall (utiliser `js` ou `cmp rax, 0`).
- Les permissions (`rdx` de `open`) sont masquées par `umask` du processus.
- Fermer tous les descripteurs ouverts avant de terminer.
