; Chapitre 02 — Registres x86-64
; Démonstration de l'utilisation des registres généraux et de leurs sous-parties

section .data
    newline db 10

section .bss
    buf resb 20     ; tampon pour afficher un entier

section .text
    global _start

; Convertit le nombre dans rax en ASCII décimal dans buf, retourne la longueur dans rcx
int_to_str:
    mov rbx, 10         ; diviseur
    mov rcx, 0          ; compteur de chiffres
    lea rdi, [buf + 19] ; pointer vers la fin du tampon
.loop:
    xor rdx, rdx
    div rbx             ; rax = quotient, rdx = reste
    add dl, '0'         ; convertir le chiffre en caractère ASCII
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .loop
    ret

_start:
    ; Registres 64 bits : rax, rbx, rcx, rdx, rsi, rdi, rbp, rsp, r8..r15
    mov rax, 42         ; registre 64 bits entier

    ; Sous-parties du registre rax
    ; rax = 64 bits, eax = 32 bits (bits 0-31)
    ; ax  = 16 bits (bits 0-15)
    ; ah  = 8 bits  (bits 8-15), al = 8 bits (bits 0-7)
    mov eax, 255        ; utilisation de la sous-partie 32 bits
    mov ax,  1000       ; utilisation de la sous-partie 16 bits
    mov al,  65         ; utilisation de l'octet bas

    ; Opérations sur les registres
    mov rax, 100
    mov rbx, 200
    add rax, rbx        ; rax = 100 + 200 = 300

    ; Afficher la valeur de rax
    call int_to_str

    mov rax, 1          ; sys_write
    mov rdi, 1
    mov rsi, rdi        ; rsi pointe déjà vers le bon endroit via rdi... utilisons rbx
    ; rdi contient l'adresse du début de la chaîne depuis int_to_str
    ; rcx contient la longueur

    ; Ré-afficher avec la bonne logique
    mov rax, 300
    call int_to_str

    mov rax, 1
    mov rdi, 1
    ; rdi (adresse début chaine) est dans le registre rdi retourné par int_to_str
    ; on doit sauvegarder rdi avant l'appel système
    push rdi            ; sauvegarder l'adresse du début
    pop rsi             ; restaurer dans rsi (paramètre de write)
    mov rdx, rcx        ; longueur
    syscall

    ; Afficher un saut de ligne
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Quitter
    mov rax, 60
    xor rdi, rdi
    syscall
