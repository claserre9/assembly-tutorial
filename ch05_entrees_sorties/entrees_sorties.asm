; Chapitre 05 — Entrées/Sorties via appels système Linux

section .data
    prompt      db  "Entrez un caractère : ", 0
    prompt_len  equ $ - prompt - 1
    msg_lu      db  "Vous avez saisi : ", 0
    msg_lu_len  equ $ - msg_lu - 1
    newline     db  10

section .bss
    car         resb 2      ; tampon pour lire 1 caractère + saut de ligne

section .text
    global _start

_start:
    ; --- sys_write : écrire sur stdout ---
    mov rax, 1              ; sys_write
    mov rdi, 1              ; fd = stdout
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    ; --- sys_read : lire depuis stdin ---
    mov rax, 0              ; sys_read
    mov rdi, 0              ; fd = stdin
    mov rsi, car            ; tampon de réception
    mov rdx, 2              ; lire au maximum 2 octets
    syscall
    ; rax contient le nombre d'octets lus

    ; --- Afficher le caractère lu ---
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_lu
    mov rdx, msg_lu_len
    syscall

    ; Afficher le caractère lu (premier octet du tampon)
    mov rax, 1
    mov rdi, 1
    mov rsi, car
    mov rdx, 1
    syscall

    ; Saut de ligne
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; --- sys_write : écrire sur stderr (fd=2) ---
    mov rax, 1
    mov rdi, 2              ; fd = stderr
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    ; Quitter
    mov rax, 60
    xor rdi, rdi
    syscall
