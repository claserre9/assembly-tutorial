; Chapitre 12 — Gestion de la pile (stack)

section .data
    msg_avant   db  "Avant l'appel : ", 0
    msg_avant_l equ $ - msg_avant - 1
    msg_apres   db  "Apres l'appel : ", 0
    msg_apres_l equ $ - msg_apres - 1
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

; Démonstration d'un cadre de pile complet
; Arguments : rdi = a, rsi = b
; Retourne : rax = a + b + variable_locale
demo_frame:
    push rbp
    mov  rbp, rsp
    sub  rsp, 16            ; 2 variables locales de 8 octets

    ; Sauvegarder les registres non-volatiles utilisés
    push rbx
    push r12

    ; Copier les arguments dans des registres préservés
    mov  rbx, rdi           ; rbx = a
    mov  r12, rsi           ; r12 = b

    ; Variables locales accessibles via rbp
    mov  qword [rbp - 8],  100  ; local1 = 100
    mov  qword [rbp - 16], 200  ; local2 = 200

    ; Calcul
    mov  rax, rbx
    add  rax, r12
    add  rax, [rbp - 8]     ; + local1

    ; Restaurer les registres préservés
    pop r12
    pop rbx

    mov  rsp, rbp
    pop  rbp
    ret

; Démonstration de push/pop multiple
demo_push_pop:
    push rbp
    mov  rbp, rsp

    push rax                ; empiler rax
    push rbx                ; empiler rbx
    push rcx                ; empiler rcx

    mov  rax, 111
    mov  rbx, 222
    mov  rcx, 333

    ; La pile est LIFO : pop dans l'ordre inverse
    pop rcx                 ; rcx = 333 (valeur originale)
    pop rbx                 ; rbx = 222
    pop rax                 ; rax = 111

    pop  rbp
    ret

_start:
    ; Appeler demo_frame(10, 20) → résultat = 10 + 20 + 100 = 130
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_avant
    mov rdx, msg_avant_l
    syscall

    mov rax, 10             ; sauvegarder pour l'affichage
    push rax
    call print_uint         ; afficher 10

    pop rax

    mov rdi, 10
    mov rsi, 20
    call demo_frame         ; rax = 130

    mov rcx, rax            ; sauvegarder le résultat
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_apres
    mov rdx, msg_apres_l
    syscall

    mov rax, rcx
    call print_uint

    ; Quitter
    mov rax, 60
    xor rdi, rdi
    syscall
