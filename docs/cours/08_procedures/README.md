# Chapitre 8 — Procédures et conventions d'appel (System V AMD64 ABI)

## 8.1 `call` et `ret`

`call etiquette` pousse l'adresse de l'instruction suivante sur la pile (`rsp -= 8`) puis saute vers l'étiquette.  
`ret` dépile cette adresse et y retourne (`rsp += 8`).

```nasm
call ma_fonction    ; rsp -= 8, puis jmp ma_fonction
; ...
ma_fonction:
    ; corps
    ret             ; reprend après le call
```

---

## 8.2 Convention System V AMD64 ABI

C'est la convention utilisée sur Linux (et macOS) pour les fonctions C et les bibliothèques système.

### Passage des arguments

| Argument | Registre |
|----------|----------|
| 1        | `rdi`    |
| 2        | `rsi`    |
| 3        | `rdx`    |
| 4        | `rcx`    |
| 5        | `r8`     |
| 6        | `r9`     |
| 7+       | sur la pile (droite → gauche) |

### Valeur de retour

- Entier ou pointeur : `rax` (et `rdx` pour les valeurs 128 bits)
- Flottant : `xmm0`

### Registres callee-saved (à préserver dans la fonction appelée)

`rbx`, `rbp`, `r12`, `r13`, `r14`, `r15`

### Registres caller-saved (peuvent être détruits par l'appelée)

`rax`, `rcx`, `rdx`, `rsi`, `rdi`, `r8`, `r9`, `r10`, `r11`

---

## 8.3 Prologue et épilogue de fonction

### Prologue classique (avec frame pointer)

```nasm
ma_fonction:
    push rbp            ; sauvegarder le frame pointer précédent
    mov  rbp, rsp       ; rbp = sommet de pile actuel
    sub  rsp, 32        ; allouer 32 octets pour les variables locales
    ; ... corps ...
```

### Épilogue

```nasm
    mov  rsp, rbp       ; restaurer rsp (libère les variables locales)
    pop  rbp            ; restaurer rbp
    ret
```

Ou avec l'instruction dédiée (équivalent au duo précédent) :

```nasm
    leave               ; mov rsp, rbp + pop rbp
    ret
```

### Sans frame pointer (optimisé)

```nasm
ma_fonction:
    sub  rsp, 8         ; aligner la pile si nécessaire
    ; ... corps ...
    add  rsp, 8
    ret
```

---

## 8.4 Alignement de la pile (règle des 16 octets)

La pile doit être alignée sur **16 octets au moment de tout `call`**. Après un `call`, `rsp` est impair d'un multiple de 8 (car `call` pousse 8 octets). Donc dans la fonction appelée, `rsp` pointe sur un multiple de 8, mais pas de 16 — d'où le besoin d'aligner :

```nasm
; En entrée de fonction, rsp % 16 == 8
; Si on fait un call vers une autre fonction, il faut aligner :
sub rsp, 8      ; rsp % 16 == 0 avant le call imbriqué
call autre
add rsp, 8
```

---

## 8.5 Variables locales

Les variables locales sont allouées sous `rbp` (adresses négatives par rapport à `rbp`) :

```nasm
ma_fonction:
    push rbp
    mov  rbp, rsp
    sub  rsp, 16        ; 2 variables locales de 8 octets

    mov qword [rbp - 8],  0     ; var1 = 0
    mov qword [rbp - 16], 42    ; var2 = 42

    mov rax, [rbp - 8]
    add rax, [rbp - 16]         ; rax = var1 + var2

    leave
    ret
```

---

## 8.6 Sauvegarde des registres callee-saved

Si la fonction utilise `rbx` ou `r12`–`r15`, elle doit les sauvegarder :

```nasm
ma_fonction:
    push rbp
    mov  rbp, rsp
    push rbx            ; sauvegarde callee-saved
    push r12

    mov rbx, rdi        ; utilisation de rbx
    mov r12, rsi

    ; ...

    pop r12             ; restauration (ordre inverse)
    pop rbx
    leave
    ret
```

---

## 8.7 Récursivité

```nasm
; Calcule factorielle(n) — rdi = n, retourne rax
factorielle:
    push rbp
    mov  rbp, rsp
    push rbx            ; rbx = callee-saved, contiendra n

    mov  rbx, rdi       ; sauvegarder n

    cmp  rdi, 1
    jle  .cas_base

    dec  rdi
    call factorielle    ; rax = factorielle(n-1)
    imul rax, rbx       ; rax = n * factorielle(n-1)
    jmp  .fin

.cas_base:
    mov  rax, 1         ; factorielle(0) = factorielle(1) = 1

.fin:
    pop  rbx
    leave
    ret
```

---

## 8.8 Appel vers une fonction C

```nasm
extern printf

section .data
    fmt db "Valeur : %ld", 0x0A, 0

section .text
global main

main:
    push rbp
    mov  rbp, rsp
    and  rsp, -16       ; aligner sur 16 octets

    mov  rdi, fmt       ; argument 1 : format
    mov  rsi, 42        ; argument 2 : valeur
    xor  eax, eax       ; nb registres XMM utilisés = 0 (convention variadique)
    call printf

    xor  eax, eax       ; retourner 0
    leave
    ret
```

---

## Résumé

| Élément | Détail |
|---------|--------|
| Arguments | `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9` |
| Retour | `rax` |
| Callee-saved | `rbx`, `rbp`, `r12`–`r15` |
| Caller-saved | `rax`, `rcx`, `rdx`, `rsi`, `rdi`, `r8`–`r11` |
| Alignement pile | 16 octets avant chaque `call` |
| Prologue | `push rbp` / `mov rbp, rsp` / `sub rsp, N` |
| Épilogue | `leave` + `ret` |
