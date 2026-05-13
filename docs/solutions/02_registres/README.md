# Solutions — Chapitre 02 : Registres

## Solution 1 — Valeurs des registres

```nasm
mov rax, 0xFFFFFFFFFFFFFFFF   ; rax = 0xFFFFFFFFFFFFFFFF
mov eax, 1                    ; rax = 0x0000000000000001  (32 bits supérieurs mis à 0)
mov ax,  0x1234               ; rax = 0x0000000000001234  (16 bits bas = 0x1234)
mov al,  0xFF                 ; rax = 0x00000000000012FF  (octet bas = 0xFF)
mov ah,  0x00                 ; rax = 0x00000000000000FF  (bits 8-15 = 0)
```

## Solution 2 — Échange de valeurs sans variable temporaire

```nasm
; Méthode 1 : instruction xchg
xchg rax, rbx

; Méthode 2 : XOR swap
xor rax, rbx
xor rbx, rax
xor rax, rbx
```

La méthode `xchg` est plus lisible. Le XOR swap fonctionne car :
- Après `xor rax, rbx` : rax = a XOR b
- Après `xor rbx, rax` : rbx = b XOR (a XOR b) = a
- Après `xor rax, rbx` : rax = (a XOR b) XOR a = b

## Solution 3 — Opérations sur sous-registres

```nasm
section .data
    valeur_hex  dq  0x1122334455667788

section .text
    global _start

_start:
    ; Étape 1 : charger la valeur
    mov rax, [valeur_hex]       ; rax = 0x1122334455667788

    ; Étape 2 : extraire ah (bits 8-15 = 0x77)
    mov rbx, 0
    mov bh, ah                  ; rbx = 0x7700 (ah = 0x77)
    ; Ou : mov rbx, rax; shr rbx, 8; and rbx, 0xFF

    ; Étape 3 : mettre à zéro les bits 8-15 de rax
    and rax, 0xFFFFFFFFFFFF00FF ; masque = tous les bits sauf 8-15

    ; Étape 4 : quitter (rdi = valeur basse de rax pour vérification)
    mov rdi, rax
    and rdi, 0xFF               ; garder seulement l'octet bas (≤255 pour $?)
    mov rax, 60
    syscall
```
