# Solutions — Chapitre 11 : Modes d'adressage

## Solution 1 — Identifier les modes

```
mov rax, 42                      ; Immédiat
mov rax, rbx                     ; Registre
mov rax, [variable]              ; Mémoire directe (adresse absolue)
mov rax, [rsi]                   ; Mémoire indirecte (via registre)
mov rax, [rsi + 8]               ; Mémoire indirecte avec déplacement
mov rax, [tableau + rcx * 8]     ; Mémoire indexée (base + index × scale)
mov rax, [rbp - 16]              ; Mémoire relative à rbp (variable locale)
lea rdi, [tableau + rcx * 4]     ; LEA — calcul d'adresse (pas de déréférencement)
```

## Solution 2 — Calcul avec LEA

```nasm
; rax = rbx * 3
lea rax, [rbx + rbx * 2]        ; rax = rbx + rbx*2 = rbx*3

; rax = rbx * 5
lea rax, [rbx + rbx * 4]        ; rax = rbx + rbx*4 = rbx*5

; rax = rbx * 9
lea rax, [rbx + rbx * 8]        ; rax = rbx + rbx*8 = rbx*9

; rax = rbx * 10
lea rax, [rbx + rbx * 4]        ; rax = rbx*5
lea rax, [rax + rax]            ; rax = rax*2 = rbx*10
; Ou : lea rax, [rbx*2 + rbx*8] — invalide (scale max = 8)
; Ou : imul rax, rbx, 10        ; une seule instruction si acceptable
```

## Solution 3 — Accès via pointeur à une structure

```nasm
; rsi = pointeur vers Point (x à offset 0, y à offset 8)

; 1. Charger x dans rax
mov rax, [rsi + Point2D.x]      ; ou [rsi + 0]

; 2. Charger y dans rbx
mov rbx, [rsi + Point2D.y]      ; ou [rsi + 8]

; 3. Calculer x + y
add rax, rbx                    ; rax = x + y

; 4. Stocker dans y
mov [rsi + Point2D.y], rax
```
