# Solutions — Chapitre 04 : Arithmétique

## Solution 1 — Calculatrice simple

```nasm
section .bss
    somme       resq 1
    difference  resq 1
    produit     resq 1
    quotient    resq 1

section .text
    global _start

_start:
    mov rax, 100
    mov rbx, 37

    ; Somme
    mov rcx, rax
    add rcx, rbx
    mov [somme], rcx        ; somme = 137

    ; Différence
    mov rcx, rax
    sub rcx, rbx
    mov [difference], rcx   ; différence = 63

    ; Produit
    mov rax, 100
    imul rax, rbx            ; rax = 100 * 37 = 3700
    mov [produit], rax

    ; Division
    mov rax, 100
    xor rdx, rdx            ; rdx = 0 obligatoire avant div
    mov rbx, 37
    div rbx                 ; rax = 100 / 37 = 2, rdx = 26
    mov [quotient], rax

    ; Quitter avec code = quotient (2)
    mov rdi, rax
    mov rax, 60
    syscall
```

## Solution 2 — Opérations bit à bit (rax initial = 0b10110011 = 179)

1. `and rax, 0b00001111` → rax = 0b00000011 = **3**
2. `or  rax, 0b11000000` → rax = 0b11000011 = **195** (depuis valeur initiale)
3. `xor rax, 0b11111111` → rax = 0b01001100 = **76**
4. `shl rax, 2`          → rax = 0b101100 1100 = **716** (peut dépasser 8 bits)
5. `shr rax, 1`          → rax = divise par 2

## Solution 3 — Puissance de 2

```nasm
; puissance_de_2(rdi) → rax = 2^rdi
puissance_de_2:
    push rbp
    mov  rbp, rsp
    mov  rax, 1         ; 2^0 = 1
    test rdi, rdi
    jz   .fin           ; cas de base : 2^0 = 1
    shl  rax, cl        ; rax = 1 << rdi (cl = partie basse de rcx)
    ; Mais on doit d'abord copier rdi dans rcx
    mov  rcx, rdi
    mov  rax, 1
    shl  rax, cl        ; 2^n
.fin:
    pop  rbp
    ret
```
