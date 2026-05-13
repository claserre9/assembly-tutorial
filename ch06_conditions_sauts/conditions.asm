; Chapitre 06 — Conditions et sauts

section .data
    msg_pos     db  "Nombre positif", 10
    msg_pos_len equ $ - msg_pos
    msg_neg     db  "Nombre negatif ou nul", 10
    msg_neg_len equ $ - msg_neg
    msg_egal    db  "Les valeurs sont egales", 10
    msg_egal_len equ $ - msg_egal
    msg_diff    db  "Les valeurs sont differentes", 10
    msg_diff_len equ $ - msg_diff

section .text
    global _start

_start:
    ; --- Saut inconditionnel ---
    jmp debut_programme

zone_inaccessible:
    ; ce code ne sera jamais exécuté
    mov rax, 99

debut_programme:
    ; --- Comparaison et saut conditionnel ---
    mov rax, 42

    ; Tester si rax > 0
    cmp rax, 0          ; set flags : rax - 0
    jle est_negatif     ; sauter si rax <= 0 (Jump if Less or Equal)

est_positif:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_pos
    mov rdx, msg_pos_len
    syscall
    jmp suite_cmp

est_negatif:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_neg
    mov rdx, msg_neg_len
    syscall

suite_cmp:
    ; --- Comparaison d'égalité ---
    mov rax, 10
    mov rbx, 10
    cmp rax, rbx
    jne valeurs_differentes

valeurs_egales:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_egal
    mov rdx, msg_egal_len
    syscall
    jmp fin_egalite

valeurs_differentes:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_diff
    mov rdx, msg_diff_len
    syscall

fin_egalite:
    ; --- Test direct avec TEST (AND sans stocker le résultat) ---
    mov rax, 0b00001010
    test rax, 0b00000001    ; tester si le bit 0 est à 1
    jnz bit_zero_actif      ; ZF=0 si le résultat est non nul
    jmp bit_zero_inactif

bit_zero_actif:
    jmp fin_test

bit_zero_inactif:
    ; bit 0 est à 0

fin_test:
    ; Quitter
    mov rax, 60
    xor rdi, rdi
    syscall
