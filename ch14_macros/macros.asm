; Chapitre 14 — Macros NASM

; Macro simple : sys_exit avec un code
%macro exit 1
    mov rax, 60
    mov rdi, %1
    syscall
%endmacro

; Macro pour sys_write
%macro print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

; Macro avec génération de labels locaux (%%label)
%macro print_nl 0
    push rax
    push rdi
    push rsi
    push rdx
    mov rax, 1
    mov rdi, 1
    mov rsi, %%newline_data
    mov rdx, 1
    syscall
    pop rdx
    pop rsi
    pop rdi
    pop rax
    jmp %%skip_data
%%newline_data: db 10
%%skip_data:
%endmacro

; Macro de définition de chaîne avec sa longueur
%macro defstr 2
    %1      db  %2
    %1_len  equ $ - %1
%endmacro

section .data
    defstr msg1, "Macro NASM : print", 10
    defstr msg2, "Macro avec arguments multiples", 10
    defstr msg3, "Fin du programme", 10

; %define pour les constantes (substitution textuelle)
%define STDOUT  1
%define SYS_WRITE 1
%define SYS_EXIT  60

section .text
    global _start

_start:
    ; Utilisation de la macro print
    print msg1, msg1_len
    print msg2, msg2_len

    ; Utilisation de %define
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, msg3
    mov rdx, msg3_len
    syscall

    ; Fin via la macro exit
    exit 0
