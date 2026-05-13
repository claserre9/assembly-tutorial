; Chapitre 01 — Introduction : Hello World en assembleur x86-64
; Assembleur : NASM
; OS         : Linux x86-64
; Compilation : nasm -f elf64 hello_world.asm -o hello_world.o
;               ld -o hello_world hello_world.o
; Exécution  : ./hello_world

section .data
    msg     db  "Bonjour, monde!", 10   ; message + saut de ligne
    msg_len equ $ - msg                 ; longueur calculée à la compilation

section .text
    global _start

_start:
    ; appel système write(1, msg, msg_len)
    mov rax, 1          ; numéro de syscall : sys_write
    mov rdi, 1          ; descripteur : stdout (fd=1)
    mov rsi, msg        ; adresse du message
    mov rdx, msg_len    ; nombre d'octets à écrire
    syscall

    ; appel système exit(0)
    mov rax, 60         ; numéro de syscall : sys_exit
    xor rdi, rdi        ; code de retour : 0
    syscall
