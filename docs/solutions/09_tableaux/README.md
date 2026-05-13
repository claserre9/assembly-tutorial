# Solutions — Chapitre 09 : Tableaux

## Solution 1 — trouver_min

```nasm
; rdi = tableau, rsi = nb_elements → rax = minimum
trouver_min:
    push rbp
    mov  rbp, rsp
    mov  rax, [rdi]         ; min = tableau[0]
    mov  rcx, 1             ; i = 1
.boucle:
    cmp  rcx, rsi
    jge  .fin
    mov  rdx, [rdi + rcx * 8]
    cmp  rdx, rax
    jge  .pas_min
    mov  rax, rdx           ; nouveau minimum
.pas_min:
    inc  rcx
    jmp  .boucle
.fin:
    pop  rbp
    ret
```

## Solution 2 — inverser_tableau

```nasm
; rdi = tableau, rsi = nb_elements
inverser_tableau:
    push rbp
    mov  rbp, rsp
    push rbx

    mov  rbx, 0             ; gauche = 0
    mov  rcx, rsi
    dec  rcx                ; droite = n - 1

.boucle:
    cmp  rbx, rcx
    jge  .fin               ; arrêt quand gauche >= droite

    ; Échanger [rdi + rbx*8] et [rdi + rcx*8]
    mov  rax, [rdi + rbx * 8]
    mov  rdx, [rdi + rcx * 8]
    mov  [rdi + rbx * 8], rdx
    mov  [rdi + rcx * 8], rax

    inc  rbx
    dec  rcx
    jmp  .boucle
.fin:
    pop  rbx
    pop  rbp
    ret
```

## Solution 3 — Diagonale 3×3

```nasm
section .data
    matrice dq  1, 2, 3, 4, 5, 6, 7, 8, 9

section .text
    global _start

_start:
    xor  rax, rax
    ; [0][0] = matrice[0*3+0] = matrice[0]
    add  rax, [matrice + 0 * 8]
    ; [1][1] = matrice[1*3+1] = matrice[4]
    add  rax, [matrice + 4 * 8]
    ; [2][2] = matrice[2*3+2] = matrice[8]
    add  rax, [matrice + 8 * 8]
    ; rax = 1 + 5 + 9 = 15

    mov  rdi, rax
    mov  rax, 60
    syscall
```
