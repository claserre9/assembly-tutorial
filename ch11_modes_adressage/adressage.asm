; Chapitre 11 — Modes d'adressage x86-64

section .data
    tableau     dq  100, 200, 300, 400, 500
    valeur      dq  42
    newline     db  10

section .bss
    result_buf  resb 32

section .text
    global _start

print_uint:
    push rbp
    mov  rbp, rsp
    sub  rsp, 32
    mov  rbx, 10
    mov  rcx, 0
    lea  rdi, [rsp + 31]
    mov  byte [rdi], 10
    dec  rdi
.loop:
    xor  rdx, rdx
    div  rbx
    add  dl, '0'
    mov  [rdi], dl
    dec  rdi
    inc  rcx
    test rax, rax
    jnz  .loop
    inc  rdi
    inc  rcx
    mov  rax, 1
    mov  rsi, rdi
    mov  rdx, rcx
    mov  rdi, 1
    syscall
    mov  rsp, rbp
    pop  rbp
    ret

_start:
    ; === 1. Adressage immédiat (valeur directe dans l'instruction) ===
    mov rax, 42             ; rax = 42 (valeur immédiate)

    ; === 2. Adressage par registre ===
    mov rbx, rax            ; rbx = rax (copie registre → registre)

    ; === 3. Adressage direct (adresse absolue) ===
    mov rax, [valeur]       ; rax = contenu de la variable valeur
    mov [valeur], rbx       ; stocker rbx à l'adresse valeur

    ; === 4. Adressage indirect (via registre pointeur) ===
    mov rsi, tableau        ; rsi = adresse de base du tableau
    mov rax, [rsi]          ; rax = tableau[0] (déréférencement)
    mov rax, [rsi + 8]      ; rax = tableau[1]

    ; === 5. Adressage indexé avec déplacement ===
    mov rcx, 2
    mov rax, [tableau + rcx * 8]        ; rax = tableau[2] = 300

    ; === 6. Adressage base + index + déplacement ===
    mov rsi, tableau
    mov rcx, 1
    mov rax, [rsi + rcx * 8 + 8]       ; rax = tableau[rcx + 1] = tableau[2] = 300

    ; === 7. Adressage relatif (LEA — Load Effective Address) ===
    lea rdi, [tableau + 2 * 8]          ; rdi = adresse de tableau[2]
    mov rax, [rdi]                      ; rax = tableau[2]
    call print_uint

    ; === 8. Adressage basé sur rbp (variables locales) ===
    push rbp
    mov  rbp, rsp
    sub  rsp, 16

    mov  qword [rbp - 8], 77    ; variable locale à -8(rbp)
    mov  rax, [rbp - 8]         ; relire la variable locale
    call print_uint

    mov  rsp, rbp
    pop  rbp

    ; Quitter
    mov rax, 60
    xor rdi, rdi
    syscall
