; Chapitre 15 — Virgule flottante avec SSE2
; Liaison avec : gcc -no-pie -nostartfiles flottants.o -lm

section .data
    ; Constantes flottantes en double précision (64 bits)
    pi          dq  3.14159265358979323846
    deux        dq  2.0
    zero        dq  0.0

    msg_res     db  "Calcul flottant effectue", 10
    msg_res_len equ $ - msg_res

    ; Format pour printf (si liaison avec libc)
    fmt_double  db  "Resultat : %f", 10, 0

section .bss
    resultat    resq 1      ; stocker un double

section .text
    global _start

_start:
    ; === Charger des valeurs dans les registres XMM ===
    movsd xmm0, [pi]            ; xmm0 = π (double précision)
    movsd xmm1, [deux]          ; xmm1 = 2.0

    ; === Opérations arithmétiques SSE2 (scalaire double) ===
    addsd  xmm0, xmm1           ; xmm0 = π + 2.0
    subsd  xmm0, xmm1           ; xmm0 = π + 2.0 - 2.0 = π
    mulsd  xmm0, xmm1           ; xmm0 = π * 2.0 = 2π
    divsd  xmm0, xmm1           ; xmm0 = 2π / 2.0 = π

    ; === Stocker le résultat en mémoire ===
    movsd [resultat], xmm0

    ; === Comparaison flottante ===
    movsd xmm0, [pi]
    movsd xmm1, [deux]
    ucomisd xmm0, xmm1          ; comparer xmm0 et xmm1 (non signé)
    ja  pi_plus_grand
    jmp pi_plus_petit_ou_egal

pi_plus_grand:
    ; π > 2.0
    jmp suite_flottants

pi_plus_petit_ou_egal:
    ; π <= 2.0

suite_flottants:
    ; === Conversion entier ↔ flottant ===
    mov  rax, 42
    cvtsi2sd xmm2, rax          ; convertir entier 64 bits → double
    cvttsd2si rax, xmm2         ; convertir double → entier (tronqué)

    ; === Valeur absolue (effacer le bit de signe) ===
    ; Technique : AND avec masque 0x7FFFFFFFFFFFFFFF
    ; (manipuler les bits du double directement)

    ; Afficher un message de confirmation
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_res
    mov rdx, msg_res_len
    syscall

    ; Quitter
    mov rax, 60
    xor rdi, rdi
    syscall
