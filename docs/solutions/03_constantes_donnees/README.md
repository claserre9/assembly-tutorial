# Solutions — Chapitre 03 : Constantes et données

## Solution 1 — Déclarations de données

```nasm
section .data
    titre       db  "Mon titre", 10
    titre_len   equ $ - titre

    compteur    dq  0

    notes       dd  15, 12, 18, 9, 14
    notes_taille equ ($ - notes) / 4   ; 5 éléments de 4 octets
```

## Solution 2 — Section `.bss`

```nasm
section .bss
    input_buf   resb 128    ; 128 × 1 octet
    resultats   resq 10     ; 10 × 8 octets = 80 octets
    temp        resd 1      ; 1 × 4 octets
```

## Solution 3 — Modifier des données

```nasm
section .data
    valeur      dq  42

section .bss
    double_val  resq 1

section .text
    global _start

_start:
    ; Charger et doubler
    mov rax, [valeur]       ; rax = 42
    shl rax, 1              ; rax = 42 * 2 = 84 (décalage gauche = × 2)
    ; Ou : add rax, rax     ; équivalent

    ; Stocker le résultat
    mov [double_val], rax

    ; Quitter avec double_val comme code de retour
    mov rdi, rax
    mov rax, 60
    syscall
; Code de retour = 84
```
