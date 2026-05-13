; Chapitre 13 — Opérations sur les fichiers (syscalls)

section .data
    nom_fichier     db  "/tmp/test_asm.txt", 0
    contenu         db  "Ligne 1 : Tutoriel Assembleur x86-64", 10
    contenu_len     equ $ - contenu
    contenu2        db  "Ligne 2 : Ecriture dans un fichier", 10
    contenu2_len    equ $ - contenu2
    msg_ok          db  "Fichier ecrit avec succes!", 10
    msg_ok_len      equ $ - msg_ok
    msg_lu          db  "Contenu lu :", 10
    msg_lu_len      equ $ - msg_lu

    ; Flags pour open (O_WRONLY|O_CREAT|O_TRUNC = 0x241)
    O_RDONLY        equ 0
    O_WRONLY        equ 1
    O_RDWR          equ 2
    O_CREAT         equ 0x40
    O_TRUNC         equ 0x200
    ; Permissions 0644 en octal
    MODE_644        equ 0o644

section .bss
    tampon_lecture  resb 256
    fd_var          resq 1      ; descripteur de fichier

section .text
    global _start

_start:
    ; === Ouvrir/créer un fichier en écriture ===
    ; sys_open(pathname, flags, mode)
    mov rax, 2                              ; sys_open
    mov rdi, nom_fichier                    ; chemin du fichier
    mov rsi, O_WRONLY | O_CREAT | O_TRUNC  ; flags
    mov rdx, MODE_644                       ; permissions
    syscall
    ; rax = descripteur de fichier (fd), ou négatif si erreur
    mov [fd_var], rax

    ; === Écrire dans le fichier ===
    mov rdi, [fd_var]   ; fd
    mov rax, 1          ; sys_write
    mov rsi, contenu
    mov rdx, contenu_len
    syscall

    mov rdi, [fd_var]
    mov rax, 1
    mov rsi, contenu2
    mov rdx, contenu2_len
    syscall

    ; === Fermer le fichier ===
    mov rax, 3          ; sys_close
    mov rdi, [fd_var]
    syscall

    ; Confirmer l'écriture
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_ok
    mov rdx, msg_ok_len
    syscall

    ; === Ouvrir le fichier en lecture ===
    mov rax, 2
    mov rdi, nom_fichier
    mov rsi, O_RDONLY
    xor rdx, rdx
    syscall
    mov [fd_var], rax

    ; === Lire le contenu ===
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_lu
    mov rdx, msg_lu_len
    syscall

    mov rax, 0          ; sys_read
    mov rdi, [fd_var]
    mov rsi, tampon_lecture
    mov rdx, 255
    syscall
    ; rax = nombre d'octets lus

    mov rdx, rax        ; longueur à afficher
    mov rax, 1
    mov rdi, 1
    mov rsi, tampon_lecture
    syscall

    ; === Fermer le fichier ===
    mov rax, 3
    mov rdi, [fd_var]
    syscall

    ; Quitter
    mov rax, 60
    xor rdi, rdi
    syscall
