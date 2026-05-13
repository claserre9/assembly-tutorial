; Chapitre 19 — Multi-fichiers : programme principal
; Importe les fonctions du module utils.asm

; Déclarer les symboles importés depuis d'autres modules
extern print_uint
extern print_string
extern print_newline

section .data
    titre   db  "=== Programme multi-fichiers ===", 0
    msg1    db  "Valeur de pi approximee : ", 0
    msg2    db  "Constante N = ", 0
    N       equ 42

section .text
    global _start

_start:
    ; Afficher le titre
    mov rdi, titre
    call print_string
    call print_newline

    ; Afficher un message et une valeur
    mov rdi, msg2
    call print_string
    mov rdi, N
    call print_uint

    ; Appel de print_newline
    call print_newline

    ; Quitter
    mov rax, 60
    xor rdi, rdi
    syscall
