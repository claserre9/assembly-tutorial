# Chapitre 9 — Tableaux

## 9.1 Déclaration d'un tableau

```nasm
section .data
    ; Tableau de 5 entiers 64 bits initialisés
    tableau dq 10, 20, 30, 40, 50

    ; Tableau d'octets
    octets db 1, 2, 3, 4, 5, 6, 7, 8

section .bss
    ; Tableau de 100 quadwords non initialisés
    buf resq 100
    ; Tableau de 256 octets
    charbuf resb 256
```

---

## 9.2 Adressage indexé (base + index × scale + déplacement)

La syntaxe générale est :

```nasm
[base + index * scale + déplacement]
```

- **base** : registre 64 bits (adresse de début)
- **index** : registre 64 bits (numéro d'élément)
- **scale** : 1, 2, 4 ou 8 (taille de l'élément)
- **déplacement** : constante signée (offset fixe)

```nasm
; Charger tableau[i] dans rax (éléments de 8 octets)
; rsi = adresse du tableau, rcx = i
mov rax, [rsi + rcx*8]

; Stocker rax dans tableau[i]
mov [rsi + rcx*8], rax

; Accéder avec un offset fixe : tableau[2]
mov rax, [tableau + 2*8]

; Octet à l'index i (scale = 1)
movzx rax, byte [rsi + rcx]
```

---

## 9.3 Itération sur un tableau

### Par pointeur (idiome efficace)

```nasm
; Parcourir et sommer un tableau de N qwords
; rdi = adresse, rsi = N
sum_array:
    xor  rax, rax           ; somme = 0
    test rsi, rsi
    jz   .done
.loop:
    add  rax, [rdi]         ; somme += *ptr
    add  rdi, 8             ; ptr += sizeof(qword)
    dec  rsi
    jnz  .loop
.done:
    ret
```

### Par index

```nasm
; Multiplier chaque élément par 2
; rdi = tableau, rsi = N
double_array:
    xor  rcx, rcx           ; i = 0
.loop:
    cmp  rcx, rsi
    jge  .done
    shl  qword [rdi + rcx*8], 1   ; tableau[i] *= 2
    inc  rcx
    jmp  .loop
.done:
    ret
```

---

## 9.4 Tableaux à deux dimensions

Un tableau 2D `A[lignes][colonnes]` est stocké **ligne par ligne** (row-major).

L'élément `A[i][j]` est à l'adresse :

```
base + (i * nb_colonnes + j) * taille_element
```

```nasm
; Accéder à A[i][j] — int64, 4 colonnes
; rdi = base, rsi = i, rdx = j
%define NB_COLS 4

    imul rax, rsi, NB_COLS  ; rax = i * NB_COLS
    add  rax, rdx            ; rax = i * NB_COLS + j
    mov  rax, [rdi + rax*8]  ; charger A[i][j]
```

### Déclaration statique d'un tableau 2D (3×4)

```nasm
section .data
    ; matrice 3×4 de 32 bits
    matrice dd  1,  2,  3,  4, \
                5,  6,  7,  8, \
                9, 10, 11, 12
```

---

## 9.5 Recherche de la valeur maximale

```nasm
; Retourne la valeur maximale d'un tableau de N qwords
; rdi = tableau, rsi = N (>= 1)
max_array:
    mov  rax, [rdi]         ; max = tableau[0]
    mov  rcx, 1             ; i = 1
.loop:
    cmp  rcx, rsi
    jge  .done
    mov  rbx, [rdi + rcx*8]
    cmp  rbx, rax
    cmovg rax, rbx          ; si tableau[i] > max, mettre à jour
    inc  rcx
    jmp  .loop
.done:
    ret
```

---

## 9.6 Copie de tableau

```nasm
; Copier N qwords de src vers dst
; rdi = dst, rsi = src, rdx = N
copy_array:
    test rdx, rdx
    jz   .done
.loop:
    mov  rax, [rsi]
    mov  [rdi], rax
    add  rdi, 8
    add  rsi, 8
    dec  rdx
    jnz  .loop
.done:
    ret
```

> Pour des copies de blocs, l'instruction `rep movsq` (vue au chapitre 10) est plus efficace.

---

## 9.7 Tableaux sur la pile (variables locales)

```nasm
ma_fonction:
    push rbp
    mov  rbp, rsp
    sub  rsp, 40        ; 5 qwords = 40 octets (tableau local)

    ; tableau[0] = 10
    mov  qword [rbp - 8],  10
    ; tableau[1] = 20
    mov  qword [rbp - 16], 20
    ; Accès à tableau[i] : [rbp - 8 - i*8] ou [rbp - (i+1)*8]
    ; Avec un index dans rcx :
    ; [rbp - 8 + rcx * (-8)] — astuce : calculer l'adresse avec lea

    leave
    ret
```

---

## Résumé

| Élément | Syntaxe NASM |
|---------|-------------|
| Déclaration initialisée | `nom dq val1, val2, ...` |
| Déclaration non initialisée | `nom resq N` |
| Accès par index | `[base + index*scale]` |
| Accès 2D | `[base + (i*cols + j)*scale]` |
| Scale autorisés | 1, 2, 4, 8 |
| Itération par pointeur | `add rdi, 8` après chaque accès |
