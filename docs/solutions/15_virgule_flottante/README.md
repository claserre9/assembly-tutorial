# Solutions — Chapitre 15 : Virgule flottante

## Solution 1 — Conversion Celsius → Fahrenheit

```nasm
section .data
    celsius     dq  100.0
    neuf_cinq   dq  1.8         ; 9/5 = 1.8
    trente_deux dq  32.0

section .bss
    fahrenheit  resq 1

section .text
    global _start

_start:
    movsd xmm0, [celsius]
    mulsd xmm0, [neuf_cinq]     ; xmm0 = 100.0 * 1.8 = 180.0
    addsd xmm0, [trente_deux]   ; xmm0 = 180.0 + 32.0 = 212.0
    movsd [fahrenheit], xmm0

    mov rax, 60
    xor rdi, rdi
    syscall
```

## Solution 2 — Distance euclidienne

```nasm
; xmm0=x1, xmm1=y1, xmm2=x2, xmm3=y2 → xmm0 = distance
distance:
    push rbp
    mov  rbp, rsp

    subsd xmm2, xmm0        ; dx = x2 - x1
    subsd xmm3, xmm1        ; dy = y2 - y1
    mulsd xmm2, xmm2        ; dx²
    mulsd xmm3, xmm3        ; dy²
    addsd xmm2, xmm3        ; dx² + dy²
    sqrtsd xmm0, xmm2       ; sqrt(dx² + dy²)

    pop  rbp
    ret
```

## Solution 3 — Comparaison avec epsilon

```nasm
section .data
    epsilon     dq  1.0e-9
    val_a       dq  1.0000000001
    val_b       dq  1.0

section .text
_start:
    movsd xmm0, [val_a]
    movsd xmm1, [val_b]
    subsd xmm0, xmm1            ; xmm0 = a - b
    ; valeur absolue (effacer le bit de signe)
    mov   rax, 0x7FFFFFFFFFFFFFFF
    movq  xmm1, rax
    andpd xmm0, xmm1            ; xmm0 = |a - b|

    movsd xmm1, [epsilon]
    ucomisd xmm0, xmm1
    jb   .egal                  ; |a-b| < epsilon
    ; ...
.egal:
    ; ...
```
