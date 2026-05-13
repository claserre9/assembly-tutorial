# Solutions — Chapitre 10 : Chaînes de caractères

## Solution 1 — strcmp_asm

```nasm
; rdi = str1, rsi = str2 → rax = 0/-1/1
strcmp_asm:
    push rbp
    mov  rbp, rsp
.boucle:
    movzx rax, byte [rdi]
    movzx rcx, byte [rsi]
    cmp  al, cl
    jl   .str1_inferieure
    jg   .str1_superieure
    test al, al
    jz   .egal          ; les deux sont à 0 → égales
    inc  rdi
    inc  rsi
    jmp  .boucle
.egal:
    xor  rax, rax
    jmp  .fin
.str1_inferieure:
    mov  rax, -1
    jmp  .fin
.str1_superieure:
    mov  rax, 1
.fin:
    pop  rbp
    ret
```

## Solution 2 — inverser_chaine

```nasm
; rdi = chaîne null-terminée
inverser_chaine:
    push rbp
    mov  rbp, rsp
    push rbx
    push r12

    ; Trouver la fin
    mov  rbx, rdi
    xor  rax, rax
.find_end:
    cmp  byte [rbx + rax], 0
    je   .start_reverse
    inc  rax
    jmp  .find_end
.start_reverse:
    ; rbx = début, rax = longueur
    mov  r12, rax
    dec  r12                ; r12 = indice dernier char
    xor  rcx, rcx           ; rcx = indice premier char
.reverse_loop:
    cmp  rcx, r12
    jge  .fin
    ; Échanger [rbx+rcx] et [rbx+r12]
    mov  al, [rbx + rcx]
    mov  dl, [rbx + r12]
    mov  [rbx + rcx], dl
    mov  [rbx + r12], al
    inc  rcx
    dec  r12
    jmp  .reverse_loop
.fin:
    pop  r12
    pop  rbx
    pop  rbp
    ret
```

## Solution 3 — vers_majuscules

```nasm
vers_majuscules:
    push rbp
    mov  rbp, rsp
.boucle:
    movzx rax, byte [rdi]
    test  al, al
    jz    .fin
    cmp   al, 'a'
    jl    .pas_minuscule
    cmp   al, 'z'
    jg    .pas_minuscule
    sub   al, 32            ; 'a'-'A' = 32
    mov   [rdi], al
.pas_minuscule:
    inc   rdi
    jmp   .boucle
.fin:
    pop  rbp
    ret
```

## Solution 4 — strlen avec REPNE SCASB

```nasm
strlen_scas:
    push rbp
    mov  rbp, rsp
    mov  rcx, -1            ; compteur max (0xFFFFFFFFFFFFFFFF)
    xor  al, al             ; chercher 0
    repne scasb             ; rdi avance, rcx décroît
    not  rcx
    dec  rcx                ; longueur dans rcx
    mov  rax, rcx
    pop  rbp
    ret
```
