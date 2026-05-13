; Chapitre 16 — Structures avec NASM (struc/istruc)

; Définition d'une structure "Etudiant"
struc Etudiant
    .nom:       resb 32     ; 32 octets pour le nom
    .age:       resb 1      ; 1 octet pour l'âge
    .note:      resq 1      ; 8 octets (double) pour la note
    .taille:                ; taille totale de la structure
endstruc

; Définition d'une structure "Point2D"
struc Point2D
    .x:     resq 1          ; coordonnée x (entier 64 bits)
    .y:     resq 1          ; coordonnée y (entier 64 bits)
    .taille:
endstruc

section .data
    msg_struct  db  "Structure initialisee", 10
    msg_len     equ $ - msg_struct

    ; Instanciation statique d'un Point2D
    point1:
        istruc Point2D
            at Point2D.x, dq 10
            at Point2D.y, dq 20
        iend

    ; Tableau de deux points
    points:
        dq  5,  3      ; point[0] : x=5, y=3
        dq  8, 11      ; point[1] : x=8, y=11

section .bss
    ; Instanciation dans .bss (valeurs nulles par défaut)
    etudiant1   resb Etudiant.taille

section .text
    global _start

_start:
    ; === Initialiser les champs de etudiant1 ===
    ; Copier "Alice" dans etudiant1.nom
    mov byte [etudiant1 + Etudiant.nom],     'A'
    mov byte [etudiant1 + Etudiant.nom + 1], 'l'
    mov byte [etudiant1 + Etudiant.nom + 2], 'i'
    mov byte [etudiant1 + Etudiant.nom + 3], 'c'
    mov byte [etudiant1 + Etudiant.nom + 4], 'e'
    mov byte [etudiant1 + Etudiant.nom + 5], 0   ; null terminator

    mov byte  [etudiant1 + Etudiant.age],  20
    ; Note : 15.5 en double IEEE 754 = 0x402F000000000000
    mov qword [etudiant1 + Etudiant.note], 0x402F000000000000

    ; === Lire les champs ===
    mov rax, [point1 + Point2D.x]      ; rax = 10
    mov rbx, [point1 + Point2D.y]      ; rbx = 20

    ; === Parcourir un tableau de structures ===
    mov rsi, points         ; adresse du premier Point2D
    mov rcx, 2              ; nombre de points

boucle_points:
    mov rax, [rsi + Point2D.x]     ; charger x
    mov rbx, [rsi + Point2D.y]     ; charger y
    add rsi, Point2D.taille        ; passer au point suivant
    dec rcx
    jnz boucle_points

    ; Afficher confirmation
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_struct
    mov rdx, msg_len
    syscall

    ; Quitter
    mov rax, 60
    xor rdi, rdi
    syscall
