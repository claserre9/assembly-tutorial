# Annexe D — Bonnes pratiques en assembleur

## 1. Nommage et lisibilité

### Labels descriptifs

```nasm
; Mauvais
l1:
    jmp l2
l2:
    mov rax, 5

; Bon
boucle_affichage:
    jmp fin_boucle_affichage
fin_boucle_affichage:
    mov rax, 5
```

### Commentaires utiles

```nasm
; Mauvais — décrit ce que fait le code (évident)
mov rax, 1      ; mettre 1 dans rax

; Bon — explique POURQUOI
mov rax, 1      ; sys_write : écrire sur un descripteur
```

### Convention de nommage

- Labels globaux : `snake_case` (`calcul_somme`, `trouver_max`)
- Labels locaux : préfixe `.` (`.boucle`, `.fin`, `.erreur`)
- Constantes : `MAJUSCULES` (`MAX_TAILLE`, `SYS_EXIT`)

## 2. Gestion de la pile

### Toujours maintenir l'alignement sur 16 octets

```nasm
ma_proc:
    push rbp
    mov  rbp, rsp
    sub  rsp, 32    ; espace local — choisir un multiple de 16
    ; ...
    mov  rsp, rbp
    pop  rbp
    ret
```

### Sauvegarder les registres appropriés

```nasm
; Si vous utilisez rbx, r12-r15 dans une procédure :
ma_proc:
    push rbp
    mov  rbp, rsp
    push rbx        ; sauvegarder les callee-saved utilisés
    push r12

    ; ... utiliser rbx, r12 ...

    pop  r12        ; restaurer dans l'ordre inverse
    pop  rbx
    mov  rsp, rbp
    pop  rbp
    ret
```

## 3. Appels système

### Vérifier les valeurs de retour

```nasm
    ; sys_open
    mov rax, 2
    mov rdi, nom_fichier
    mov rsi, 0          ; O_RDONLY
    xor rdx, rdx
    syscall
    test rax, rax
    js   .erreur_open   ; rax < 0 → erreur
    mov  [fd], rax

.erreur_open:
    ; gérer l'erreur...
```

### Ne pas oublier de fermer les fichiers

```nasm
    ; Toujours fermer en fin de programme
    mov rax, 3
    mov rdi, [fd]
    syscall
```

## 4. Arithmétique sécurisée

### Toujours initialiser rdx avant une division

```nasm
; DANGEREUX (rdx contient une valeur inconnue)
mov rax, 100
div rbx             ; comportement indéfini si rdx != 0

; CORRECT
mov rax, 100
xor rdx, rdx        ; ou cqo pour la division signée
div rbx
```

### Utiliser `idiv` pour les entiers signés

```nasm
mov rax, -100
cqo                 ; étend le signe de rax dans rdx:rax
mov rbx, 7
idiv rbx            ; rax = -100 / 7 = -14, rdx = -2
```

## 5. Débogage proactif

### Utiliser des assertions

```nasm
%ifdef DEBUG
%macro assert_nonzero 1
    test %1, %1
    jnz  %%ok
    ; assertion échouée : arrêt
    mov  rax, 60
    mov  rdi, 127
    syscall
%%ok:
%endmacro
%else
%macro assert_nonzero 1
%endmacro
%endif
```

### Inspecter avec GDB

```bash
gdb -ex 'break _start' -ex 'run' -ex 'stepi' ./programme
```

## 6. Performance

### Préférer les registres à la mémoire

```nasm
; Moins efficace
mov [var_temp], rax
; ... plus tard ...
mov rax, [var_temp]

; Plus efficace
push rax            ; ou utiliser un registre callee-saved
; ...
pop  rax
```

### `xor reg, reg` plutôt que `mov reg, 0`

```nasm
xor rax, rax    ; plus court (2 octets) et met les flags à jour
mov rax, 0      ; plus long (7 octets) mais ne change pas les flags
```

### Éviter les dépendances de données inutiles

```nasm
; Crée une dépendance sur rax (faux négatif partiel sur certains CPU)
movzx rax, al

; Mieux si rax doit être mis à 0 d'abord
xor eax, eax
mov al, [octet]
```

## 7. Portabilité et compatibilité

- Vérifier le support CPU avant d'utiliser SSE4/AVX/AVX-512 via `cpuid`
- Documenter les extensions requises en commentaire en tête du fichier
- Utiliser `align 16` pour les données SSE, `align 32` pour AVX
