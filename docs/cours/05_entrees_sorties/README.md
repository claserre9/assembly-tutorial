# Chapitre 5 — Entrées/Sorties via syscalls Linux

## 5.1 Convention d'appel système (syscall)

Sous Linux x86-64, un appel système s'effectue avec l'instruction `syscall`. Les arguments sont passés dans des registres précis :

| Rôle            | Registre |
|-----------------|----------|
| Numéro syscall  | `rax`    |
| Argument 1      | `rdi`    |
| Argument 2      | `rsi`    |
| Argument 3      | `rdx`    |
| Argument 4      | `r10`    |
| Argument 5      | `r8`     |
| Argument 6      | `r9`     |
| Valeur retour   | `rax`    |

> `syscall` écrase les registres `rcx` et `r11` — à sauvegarder si nécessaire.

## 5.2 Descripteurs de fichiers standard

| Descripteur | Constante   | Usage        |
|-------------|-------------|--------------|
| 0           | `stdin`     | Entrée       |
| 1           | `stdout`    | Sortie       |
| 2           | `stderr`    | Erreurs      |

## 5.3 Numéros de syscalls essentiels

| Syscall    | Numéro (`rax`) |
|------------|---------------|
| `sys_read` | 0             |
| `sys_write`| 1             |
| `sys_exit` | 60            |

## 5.4 Écriture avec `sys_write`

```nasm
; ssize_t write(int fd, const void *buf, size_t count)
; rdi = fd, rsi = adresse buffer, rdx = nombre d'octets
```

### Exemple : afficher un message

```nasm
section .data
    message db "Bonjour, monde !", 0x0A  ; 0x0A = retour à la ligne
    msg_len equ $ - message              ; longueur calculée automatiquement

section .text
global _start

_start:
    ; write(1, message, msg_len)
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, message    ; adresse du message
    mov rdx, msg_len    ; longueur
    syscall

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall
```

### Écriture sur stderr

```nasm
    mov rax, 1
    mov rdi, 2          ; stderr (fd = 2)
    mov rsi, erreur
    mov rdx, err_len
    syscall
```

## 5.5 Lecture avec `sys_read`

```nasm
; ssize_t read(int fd, void *buf, size_t count)
; rdi = fd, rsi = adresse buffer, rdx = taille max
; rax = nombre d'octets effectivement lus (0 = EOF, <0 = erreur)
```

### Exemple : lire une saisie au clavier

```nasm
section .bss
    buffer resb 64      ; réserve 64 octets non initialisés

section .text
global _start

_start:
    ; read(0, buffer, 64)
    mov rax, 0          ; sys_read
    mov rdi, 0          ; stdin
    mov rsi, buffer
    mov rdx, 64
    syscall
    ; rax = nombre d'octets lus (inclut le '\n' final)

    ; réécrire ce qui a été lu sur stdout
    mov rdx, rax        ; longueur = ce qui a été lu
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
```

## 5.6 Vérification des erreurs

Après tout syscall, `rax` contient la valeur de retour. Une valeur négative (entre -1 et -4095) indique une erreur (code errno en valeur absolue).

```nasm
    syscall
    test rax, rax
    js .erreur          ; saut si rax < 0 (bit de signe mis à 1)
    jmp .ok
.erreur:
    ; gestion de l'erreur
```

## 5.7 Afficher un entier (exemple utilitaire)

```nasm
; Affiche rdi (entier non signé) sur stdout
print_uint:
    mov rax, rdi
    mov rcx, 10
    lea rsi, [buffer + 19]  ; fin du buffer
    mov byte [rsi], 0x0A    ; '\n'
    dec rsi
.loop:
    xor rdx, rdx
    div rcx                  ; rax = quotient, rdx = chiffre
    add dl, '0'
    mov [rsi], dl
    dec rsi
    test rax, rax
    jnz .loop
    inc rsi                  ; premier chiffre
    lea rdx, [buffer + 20]
    sub rdx, rsi             ; longueur
    mov rax, 1
    mov rdi, 1
    syscall
    ret
```

## Résumé

- Les syscalls Linux x86-64 utilisent `rax` pour le numéro et `rdi/rsi/rdx` pour les trois premiers arguments.
- `sys_write` = 1, `sys_read` = 0, `sys_exit` = 60.
- Toujours vérifier `rax` après un syscall (`js` ou `cmp rax, 0`).
- `rcx` et `r11` sont détruits par `syscall`.
