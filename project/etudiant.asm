; Projet — Module gestion des étudiants

struc Etudiant
    .nom:       resb 32
    .age:       resb 1
    .padding:   resb 7
    .note:      resq 1
    .taille:
endstruc

MAX_ETUDIANTS equ 50

section .bss
    etudiants       resb Etudiant.taille * MAX_ETUDIANTS
    nb_etudiants    resq 1

section .data
    msg_nom     db  "Nom : ", 0
    msg_age     db  "Age : ", 0
    msg_note    db  "Note : ", 0
    msg_sep     db  "----------------------------", 10, 0
    msg_aucun   db  "Aucun etudiant enregistre.", 10, 0
    msg_etud    db  "Etudiant #", 0
    msg_non_tr  db  "Etudiant non trouve.", 10, 0

section .text
global ajouter_etudiant, afficher_etudiants, rechercher_etudiant
extern print_string, print_uint, print_newline, read_string, strlen_p

; Ajouter un étudiant (saisie interactive)
ajouter_etudiant:
    push rbp
    mov  rbp, rsp

    mov  rax, [nb_etudiants]
    cmp  rax, MAX_ETUDIANTS
    jge  .fin               ; tableau plein

    ; Calculer l'adresse du nouvel étudiant
    imul rax, Etudiant.taille
    lea  rbx, [etudiants + rax]

    ; Lire le nom
    mov  rdi, msg_nom
    call print_string
    lea  rdi, [rbx + Etudiant.nom]
    mov  rsi, 31
    call read_string

    ; Lire la note (lecture simplifiée — un seul chiffre pour l'exemple)
    mov  rdi, msg_note
    call print_string
    lea  rdi, [rbx + Etudiant.nom + 32]  ; tampon temporaire
    mov  rsi, 4
    call read_string
    ; Conversion ASCII → entier (simplifié, un ou deux chiffres)
    lea  rsi, [rbx + Etudiant.nom + 32]
    xor  rax, rax
.conv_note:
    movzx rcx, byte [rsi]
    test  cl, cl
    jz   .fin_conv
    sub   cl, '0'
    imul  rax, 10
    add   rax, rcx
    inc   rsi
    jmp  .conv_note
.fin_conv:
    mov  [rbx + Etudiant.note], rax

    inc  qword [nb_etudiants]
.fin:
    pop  rbp
    ret

; Afficher tous les étudiants
afficher_etudiants:
    push rbp
    mov  rbp, rsp
    push rbx
    push r12

    mov  r12, [nb_etudiants]
    test r12, r12
    jz   .vide

    xor  rbx, rbx           ; i = 0
.boucle:
    cmp  rbx, r12
    jge  .fin

    ; Calculer adresse
    mov  rax, rbx
    imul rax, Etudiant.taille
    lea  rdi, [etudiants + rax]
    push rdi

    ; Afficher le numéro
    mov  rdi, msg_etud
    call print_string
    mov  rdi, rbx
    inc  rdi
    call print_uint
    call print_newline

    ; Afficher le nom
    mov  rdi, msg_nom
    call print_string
    pop  rdi
    push rdi
    call print_string
    call print_newline

    ; Afficher la note
    mov  rdi, msg_note
    call print_string
    pop  rdi
    mov  rdi, [rdi + Etudiant.note]
    call print_uint
    call print_newline

    mov  rdi, msg_sep
    call print_string

    inc  rbx
    jmp  .boucle
    jmp  .fin

.vide:
    mov  rdi, msg_aucun
    call print_string

.fin:
    pop  r12
    pop  rbx
    pop  rbp
    ret

; Rechercher un étudiant par nom (rdi = chaîne nom)
; Retourne rax = pointeur vers Etudiant, ou 0 si non trouvé
rechercher_etudiant:
    push rbp
    mov  rbp, rsp
    push rbx
    push r12
    push r13

    mov  r12, rdi           ; nom recherché
    mov  r13, [nb_etudiants]
    xor  rbx, rbx           ; i = 0

.boucle:
    cmp  rbx, r13
    jge  .non_trouve

    mov  rax, rbx
    imul rax, Etudiant.taille
    lea  rdi, [etudiants + rax + Etudiant.nom]

    ; Comparer les chaînes
    mov  rsi, r12
.cmp_loop:
    movzx rax, byte [rdi]
    movzx rcx, byte [rsi]
    cmp  al, cl
    jne  .pas_egal
    test al, al
    jz   .trouve            ; les deux sont à 0 → égales
    inc  rdi
    inc  rsi
    jmp  .cmp_loop

.pas_egal:
    inc  rbx
    jmp  .boucle

.trouve:
    mov  rax, rbx
    imul rax, Etudiant.taille
    lea  rax, [etudiants + rax]
    jmp  .fin

.non_trouve:
    xor  rax, rax

.fin:
    pop  r13
    pop  r12
    pop  rbx
    pop  rbp
    ret
