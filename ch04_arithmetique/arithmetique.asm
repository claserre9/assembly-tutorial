; Chapitre 04 — Opérations arithmétiques

section .data
    msg_add     db  "Addition : ", 0
    msg_sub     db  "Soustraction : ", 0
    msg_mul     db  "Multiplication : ", 0
    msg_div     db  "Division : ", 0
    newline     db  10

section .bss
    result_buf  resb 32

section .text
    global _start

; Imprime un entier non signé contenu dans rax
; Modifie : rax, rbx, rcx, rdx, rdi
print_uint:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [result_buf + 31]
    mov byte [rdi], 10          ; saut de ligne à la fin
    dec rdi
.convert:
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rdi], dl
    dec rdi
    inc rcx
    test rax, rax
    jnz .convert
    inc rdi                     ; rdi pointe sur le premier chiffre
    inc rcx                     ; compter le saut de ligne
    mov rax, 1
    mov rsi, rdi
    mov rdx, rcx
    mov rdi, 1
    syscall
    ret

_start:
    ; --- Addition ---
    mov rax, 150
    mov rbx, 75
    add rax, rbx                ; rax = 225

    push rax
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_add
    mov rdx, 11
    syscall
    pop rax
    call print_uint

    ; --- Soustraction ---
    mov rax, 200
    mov rbx, 88
    sub rax, rbx                ; rax = 112

    push rax
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_sub
    mov rdx, 15
    syscall
    pop rax
    call print_uint

    ; --- Multiplication (mul) ---
    mov rax, 12
    mov rbx, 15
    mul rbx                     ; rdx:rax = rax * rbx = 180

    push rax
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_mul
    mov rdx, 17
    syscall
    pop rax
    call print_uint

    ; --- Division entière (div) ---
    mov rax, 100
    xor rdx, rdx                ; rdx = 0 (partie haute du dividende)
    mov rbx, 7
    div rbx                     ; rax = 100 / 7 = 14, rdx = 100 % 7 = 2

    push rax
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_div
    mov rdx, 10
    syscall
    pop rax
    call print_uint

    ; --- Opérations bit à bit ---
    mov rax, 0b11001100
    and rax, 0b11110000         ; AND : rax = 0b11000000 = 192
    or  rax, 0b00001111         ; OR  : rax = 0b11001111 = 207
    xor rax, 0b00000001         ; XOR : rax = 0b11001110 = 206
    not rax                     ; NOT : inverse tous les bits
    shl rax, 1                  ; décalage gauche de 1
    shr rax, 1                  ; décalage droite de 1

    ; Quitter
    mov rax, 60
    xor rdi, rdi
    syscall
