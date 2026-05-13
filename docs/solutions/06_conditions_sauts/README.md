# Solutions — Chapitre 06 : Conditions et sauts

## Solution 1 — Classification de nombre

```nasm
section .data
    msg_pos     db  "Positif", 10
    msg_pos_l   equ $ - msg_pos
    msg_neg     db  "Negatif", 10
    msg_neg_l   equ $ - msg_neg
    msg_zero    db  "Zero", 10
    msg_zero_l  equ $ - msg_zero

section .text
    global _start

_start:
    mov rax, 42         ; valeur à tester

    test rax, rax       ; plus rapide que cmp rax, 0
    jz  .est_zero
    js  .est_negatif    ; SF = 1 si bit de signe = 1

.est_positif:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_pos
    mov rdx, msg_pos_l
    syscall
    jmp .fin

.est_negatif:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_neg
    mov rdx, msg_neg_l
    syscall
    jmp .fin

.est_zero:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_zero
    mov rdx, msg_zero_l
    syscall

.fin:
    mov rax, 60
    xor rdi, rdi
    syscall
```

## Solution 2 — Maximum de trois nombres

```nasm
max3:
    push rbp
    mov  rbp, rsp
    mov  rax, rdi       ; rax = a (candidat initial)
    cmp  rsi, rax
    jle  .check_rdx
    mov  rax, rsi       ; rsi > rax
.check_rdx:
    cmp  rdx, rax
    jle  .fin
    mov  rax, rdx
.fin:
    pop  rbp
    ret
```

## Solution 3 — Traductions C → assembleur

**a)**
```nasm
cmp rax, rbx        ; a == b ?
jne .sinon
mov rcx, 1          ; x = 1
jmp .fin_if
.sinon:
mov rcx, 2          ; x = 2
.fin_if:
```

**b)**
```nasm
test rax, rax
jle .fin            ; a <= 0 : court-circuit
test rbx, rbx
jle .fin            ; b <= 0 : court-circuit
mov rcx, rax
add rcx, rbx        ; c = a + b
.fin:
```

**c)**
```nasm
mov rax, rbx        ; rax = b (default)
cmp rax_a, rbx_b    ; comparer a et b
cmovg rax, rax_a    ; si a > b, rax = a
```
