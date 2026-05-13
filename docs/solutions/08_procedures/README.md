# Solutions — Chapitre 08 : Procédures

## Solution 1 — min/max

```nasm
minimum:
    push rbp
    mov  rbp, rsp
    mov  rax, rdi
    cmp  rsi, rax
    jge  .fin
    mov  rax, rsi
.fin:
    pop  rbp
    ret

maximum:
    push rbp
    mov  rbp, rsp
    mov  rax, rdi
    cmp  rsi, rax
    jle  .fin
    mov  rax, rsi
.fin:
    pop  rbp
    ret
```

## Solution 2 — Fibonacci récursif

```nasm
fibonacci:
    push rbp
    mov  rbp, rsp
    push rbx

    cmp  rdi, 1
    jle  .cas_base      ; F(0) = 0, F(1) = 1

    mov  rbx, rdi       ; sauvegarder n
    dec  rdi
    call fibonacci      ; rax = F(n-1)
    mov  rcx, rax

    mov  rdi, rbx
    sub  rdi, 2
    call fibonacci      ; rax = F(n-2)
    add  rax, rcx       ; rax = F(n-1) + F(n-2)
    jmp  .fin

.cas_base:
    mov  rax, rdi       ; F(0)=0, F(1)=1 → rax = rdi

.fin:
    pop  rbx
    pop  rbp
    ret
```

## Solution 3 — somme_tableau avec variables locales

```nasm
; rdi = tableau, rsi = nombre d'éléments
somme_tableau:
    push rbp
    mov  rbp, rsp
    sub  rsp, 16        ; [rbp-8] = i, [rbp-16] = somme

    mov  qword [rbp - 8],  0    ; i = 0
    mov  qword [rbp - 16], 0    ; somme = 0

.boucle:
    mov  rax, [rbp - 8]
    cmp  rax, rsi
    jge  .fin

    mov  rdx, [rdi + rax * 8]
    add  [rbp - 16], rdx        ; somme += tableau[i]

    inc  qword [rbp - 8]        ; i++
    jmp  .boucle

.fin:
    mov  rax, [rbp - 16]
    mov  rsp, rbp
    pop  rbp
    ret
```
