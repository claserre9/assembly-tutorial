; Chapitre 18 — SIMD : SSE/AVX
; Traitement vectoriel de données en parallèle

section .data
    ; Vecteurs de 4 flottants 32 bits (alignés sur 16 octets)
    align 16
    vec_a       dd  1.0, 2.0, 3.0, 4.0     ; 4 floats
    vec_b       dd  5.0, 6.0, 7.0, 8.0

    ; Vecteurs de 2 doubles 64 bits
    align 16
    vec_da      dq  1.5, 2.5
    vec_db      dq  3.5, 4.5

    msg_ok      db  "SIMD operations complete", 10
    msg_ok_len  equ $ - msg_ok

section .bss
    align 16
    resultat_ps resb 16     ; résultat de 4 floats
    resultat_pd resb 16     ; résultat de 2 doubles

section .text
    global _start

_start:
    ; === Opérations SSE sur 4 floats en parallèle (Packed Single) ===
    movaps xmm0, [vec_a]    ; charger 4 floats (aligned)
    movaps xmm1, [vec_b]

    ; Addition vectorielle : xmm0[i] = vec_a[i] + vec_b[i] pour i=0..3
    addps  xmm2, xmm0       ; initialiser xmm2 = xmm0
    movaps xmm2, xmm0
    addps  xmm2, xmm1       ; xmm2 = {6.0, 8.0, 10.0, 12.0}

    ; Multiplication vectorielle
    movaps xmm3, xmm0
    mulps  xmm3, xmm1       ; xmm3 = {5.0, 12.0, 21.0, 32.0}

    ; Stocker le résultat
    movaps [resultat_ps], xmm2

    ; === Opérations SSE2 sur 2 doubles (Packed Double) ===
    movapd xmm4, [vec_da]
    movapd xmm5, [vec_db]

    addpd  xmm4, xmm5       ; xmm4 = {5.0, 7.0}
    movapd [resultat_pd], xmm4

    ; === Mélanger/permuter des éléments (shuffle) ===
    movaps xmm0, [vec_a]    ; {1.0, 2.0, 3.0, 4.0}
    shufps xmm0, xmm0, 0b00_01_10_11   ; inverser l'ordre : {4.0, 3.0, 2.0, 1.0}

    ; === Min/Max vectoriels ===
    movaps xmm0, [vec_a]
    movaps xmm1, [vec_b]
    minps  xmm2, xmm0       ; xmm2[i] = min(xmm0[i], xmm1[i])
    movaps xmm2, xmm0
    minps  xmm2, xmm1
    maxps  xmm3, xmm0
    movaps xmm3, xmm0
    maxps  xmm3, xmm1

    ; === Horizontal add (SSE3) ===
    ; haddps xmm0, xmm1 : {a0+a1, a2+a3, b0+b1, b2+b3}

    ; Confirmation
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_ok
    mov rdx, msg_ok_len
    syscall

    ; Quitter
    mov rax, 60
    xor rdi, rdi
    syscall
