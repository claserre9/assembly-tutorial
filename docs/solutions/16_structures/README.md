# Solutions — Chapitre 16 : Structures

## Solution 1 — Procédure aire

```nasm
struc Rectangle
    .largeur:   resq 1
    .hauteur:   resq 1
    .taille:
endstruc

section .data
    rect1:
        istruc Rectangle
            at Rectangle.largeur, dq 10
            at Rectangle.hauteur, dq 5
        iend

section .text
; rdi = pointeur vers Rectangle → rax = aire
aire:
    push rbp
    mov  rbp, rsp
    mov  rax, [rdi + Rectangle.largeur]
    imul rax, [rdi + Rectangle.hauteur]
    pop  rbp
    ret

global _start
_start:
    mov rdi, rect1
    call aire           ; rax = 50

    mov rdi, rax
    mov rax, 60
    syscall
```

## Solution 2 — Somme des aires

```nasm
section .data
    rectangles:
        dq 10, 5    ; 50
        dq  3, 7    ; 21
        dq  6, 4    ; 24
    nb_rects equ 3

_start:
    xor  rbx, rbx           ; somme = 0
    mov  rsi, rectangles
    mov  rcx, nb_rects
.boucle:
    mov  rdi, rsi
    call aire
    add  rbx, rax
    add  rsi, Rectangle.taille
    dec  rcx
    jnz  .boucle
    ; rbx = 50 + 21 + 24 = 95
```

## Solution 3 — Accéder au centre d'un Cercle

```nasm
; rsi = pointeur vers Cercle
; Point2D.x est à l'offset 0 dans Point2D
; Cercle.centre est à l'offset 0 dans Cercle
mov rax, [rsi + Cercle.centre + Point2D.x]
; ou simplement :
mov rax, [rsi]              ; si centre est au début et x est au début de Point2D
```
