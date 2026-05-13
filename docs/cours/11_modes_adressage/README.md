# Chapitre 11 — Modes d'adressage x86-64

## 11.1 Vue d'ensemble

Le mode d'adressage décrit **comment l'opérande d'une instruction est localisé**. x86-64 offre six modes principaux.

---

## 11.2 Immédiat

La valeur est encodée directement dans l'instruction.

```nasm
mov  rax, 42            ; rax = 42
add  rbx, 100           ; rbx += 100
cmp  rcx, 0
```

> Les immédiats 64 bits nécessitent `mov` (seule instruction supportant un immédiat 64 bits). Les autres instructions se limitent à 32 bits signe-étendu.

```nasm
mov  rax, 0x123456789ABCDEF0    ; OK : mov supporte 64 bits
; add rax, 0x123456789          ; ERREUR : trop grand pour add
```

---

## 11.3 Registre

L'opérande est un registre.

```nasm
mov  rax, rbx           ; rax = rbx
add  rcx, rdx
xor  rsi, rsi
```

---

## 11.4 Mémoire directe (direct / absolute)

L'adresse mémoire est une étiquette (constante à l'assemblage).

```nasm
section .data
    valeur dq 42

section .text
    mov  rax, [valeur]      ; charger 8 octets à l'adresse de 'valeur'
    mov  [valeur], rbx      ; stocker rbx à cette adresse
    movzx rax, byte [valeur]  ; charger 1 octet avec extension zéro
```

---

## 11.5 Mémoire indirecte (indirect par registre)

L'adresse est contenue dans un registre.

```nasm
    mov  rdi, tableau       ; rdi = adresse du tableau
    mov  rax, [rdi]         ; charger la valeur à l'adresse rdi
    mov  [rdi], rbx         ; stocker rbx à l'adresse rdi
    add  rdi, 8             ; avancer le pointeur
    mov  rcx, [rdi]         ; charger l'élément suivant
```

---

## 11.6 Mémoire indexée : base + index × scale + déplacement

Forme complète :

```nasm
[base + index*scale + disp]
```

- **base** : n'importe quel registre 64 bits
- **index** : n'importe quel registre 64 bits **sauf `rsp`**
- **scale** : 1, 2, 4 ou 8
- **disp** : déplacement signé sur 8 ou 32 bits

```nasm
; tableau[i] où éléments = 8 octets, base=rdi, index=rcx
mov  rax, [rdi + rcx*8]

; struct.champ à l'offset 16, dans un tableau de structs de 32 octets
mov  rbx, [rdi + rcx*32 + 16]

; Accès à une matrice 2D
; A[i][j], colonnes=4, éléments de 4 octets :
; adresse = base + (i*4 + j)*4
imul rax, rsi, 4
add  rax, rdx
mov  eax, [rdi + rax*4]
```

### Combinaisons valides

| Forme | Exemple |
|-------|---------|
| `[base]` | `[rdi]` |
| `[base + disp]` | `[rsp + 8]` |
| `[base + index*scale]` | `[rbx + rcx*4]` |
| `[base + index*scale + disp]` | `[rbx + rcx*4 + 8]` |
| `[index*scale + disp]` | `[rcx*8 + tableau]` |
| `[disp]` (absolu) | `[0x600000]` |

---

## 11.7 RIP-relative (position-independante)

En mode 64 bits, les accès à des données statiques utilisent un adressage **relatif à `rip`** (registre d'instruction). Cela permet de produire du code indépendant de la position (PIC).

```nasm
; NASM génère automatiquement des références RIP-relative
; pour les étiquettes dans la même section
mov  rax, [rel valeur]    ; explicite : RIP-relative
lea  rdi, [rel message]   ; charger l'adresse de 'message'
```

NASM utilise l'option `default rel` pour rendre tous les accès relatifs par défaut :

```nasm
default rel

section .data
    pi dq 3.14159

section .text
    movsd xmm0, [pi]        ; RIP-relative automatiquement
```

---

## 11.8 `lea` — Load Effective Address

`lea` calcule l'**adresse** selon un mode d'adressage quelconque et la stocke dans un registre, **sans accéder à la mémoire**. C'est un outil arithmétique puissant.

```nasm
; Charger l'adresse d'un tableau
lea  rdi, [tableau]         ; rdi = adresse de 'tableau'

; Arithmétique efficace : rax = rbx + rcx*4 + 8
lea  rax, [rbx + rcx*4 + 8]

; Multiplication par 3 sans mul
lea  rax, [rax + rax*2]     ; rax = rax + rax*2 = rax*3

; Multiplication par 5
lea  rax, [rax + rax*4]     ; rax = rax * 5

; Copier et additionner sans modifier les drapeaux
lea  rdx, [rdi + 1]         ; rdx = rdi + 1, aucun flag modifié
```

---

## 11.9 Spécificateurs de taille

Quand la taille n'est pas déduite du registre, utiliser un spécificateur explicite :

```nasm
mov  byte  [rdi], 0     ; écrire 1 octet
mov  word  [rdi], 0     ; écrire 2 octets
mov  dword [rdi], 0     ; écrire 4 octets
mov  qword [rdi], 0     ; écrire 8 octets
```

---

## Résumé

| Mode | Exemple | Accès mémoire |
|------|---------|---------------|
| Immédiat | `mov rax, 5` | Non |
| Registre | `mov rax, rbx` | Non |
| Direct | `mov rax, [label]` | Oui |
| Indirect | `mov rax, [rdi]` | Oui |
| Base+offset | `mov rax, [rdi+8]` | Oui |
| Indexé | `mov rax, [rdi+rcx*8]` | Oui |
| Indexé+disp | `mov rax, [rdi+rcx*8+16]` | Oui |
| RIP-relative | `mov rax, [rel label]` | Oui |
| `lea` | `lea rax, [rdi+rcx*4]` | Non |
