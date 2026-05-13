# Chapitre 16 — Structures avec NASM

## 16.1 `struc` / `endstruc` — Définir une structure

NASM permet de définir des structures grâce aux directives `struc` et `endstruc`. Cela crée des **constantes d'offset** pour chaque champ.

```nasm
struc Point
    .x  resq 1     ; offset 0  — double (8 octets)
    .y  resq 1     ; offset 8  — double (8 octets)
endstruc           ; Point_size = 16
```

Accéder aux champs via `NomStructure.champ` :

```nasm
; Point.x = 0, Point.y = 8, Point_size = 16
mov rax, Point.x    ; rax = 0
mov rax, Point.y    ; rax = 8
```

---

## 16.2 Instantiation statique avec `istruc` / `iend`

```nasm
section .data
    origine:
        istruc Point
            at Point.x, dq 0.0
            at Point.y, dq 0.0
        iend

    p1:
        istruc Point
            at Point.x, dq 3.5
            at Point.y, dq -2.0
        iend
```

---

## 16.3 Instantiation dans `.bss`

```nasm
section .bss
    mon_point resb Point_size    ; réserver de la place pour un Point
    points    resb Point_size * 10  ; tableau de 10 Points
```

---

## 16.4 Accéder aux champs d'une structure

```nasm
; rdi = adresse d'un Point
; Lire x
movsd  xmm0, [rdi + Point.x]

; Écrire y
movsd  [rdi + Point.y], xmm1

; Accéder via l'étiquette directe
movsd  xmm0, [p1 + Point.x]
```

---

## 16.5 Structure avec champs de types variés

```nasm
struc Personne
    .age    resd 1     ; offset 0  — int32 (4 octets)
    .pad    resb 4     ; offset 4  — 4 octets de padding (alignement)
    .salaire resq 1    ; offset 8  — int64 (8 octets)
    .nom    resb 64    ; offset 16 — tableau de 64 octets
endstruc               ; Personne_size = 80
```

> **Alignement** : placer les champs les plus larges en premier (ou insérer du padding) pour éviter les accès non alignés qui sont lents voire interdits sur certains types (SSE).

---

## 16.6 Tableaux de structures

```nasm
section .bss
    equipe resb Personne_size * 5   ; tableau de 5 Personnes

; Accéder à equipe[i].salaire
; rdi = adresse de equipe, rcx = i
    imul rax, rcx, Personne_size    ; rax = i * taille_structure
    mov  rbx, [rdi + rax + Personne.salaire]
```

---

## 16.7 Structures imbriquées

```nasm
struc Rectangle
    .coin_hg   resb Point_size   ; offset 0  — Point (16 octets)
    .coin_bd   resb Point_size   ; offset 16 — Point (16 octets)
    .couleur   resd 1            ; offset 32 — int32
    .pad       resb 4            ; offset 36 — padding
endstruc                          ; Rectangle_size = 40

; Accéder à rect.coin_hg.x :
; offset = Rectangle.coin_hg + Point.x = 0 + 0 = 0
movsd  xmm0, [rdi + Rectangle.coin_hg + Point.x]
; Accéder à rect.coin_bd.y :
; offset = Rectangle.coin_bd + Point.y = 16 + 8 = 24
movsd  xmm1, [rdi + Rectangle.coin_bd + Point.y]
```

---

## 16.8 Pointeur vers structure (passage en argument)

Selon la convention System V AMD64 ABI, les structures sont souvent passées **par pointeur** (dans `rdi`).

```nasm
; Fonction : calcule la distance d'un Point à l'origine
; rdi = adresse du Point
; retourne xmm0 = distance
distance_origine:
    movsd  xmm0, [rdi + Point.x]
    movsd  xmm1, [rdi + Point.y]
    mulsd  xmm0, xmm0           ; x^2
    mulsd  xmm1, xmm1           ; y^2
    addsd  xmm0, xmm1           ; x^2 + y^2
    sqrtsd xmm0, xmm0           ; sqrt(...)
    ret
```

---

## 16.9 Exemple complet

```nasm
struc Node
    .valeur  resq 1     ; offset 0
    .suivant resq 1     ; offset 8 (pointeur)
endstruc

section .bss
    noeud1 resb Node_size
    noeud2 resb Node_size

section .text
global _start

_start:
    ; Initialiser noeud1 : valeur=10, suivant=noeud2
    mov  qword [noeud1 + Node.valeur],  10
    mov  qword [noeud1 + Node.suivant], noeud2

    ; Initialiser noeud2 : valeur=20, suivant=NULL
    mov  qword [noeud2 + Node.valeur],  20
    mov  qword [noeud2 + Node.suivant], 0

    ; Lire la valeur du premier noeud
    mov  rax, [noeud1 + Node.valeur]   ; rax = 10

    ; Suivre le pointeur vers le noeud suivant
    mov  rdi, [noeud1 + Node.suivant]  ; rdi = adresse de noeud2
    mov  rax, [rdi + Node.valeur]      ; rax = 20

    mov  rax, 60
    xor  rdi, rdi
    syscall
```

---

## Résumé

| Directive | Rôle |
|-----------|------|
| `struc NomStruct` | Début de définition de structure |
| `.champ resX N` | Déclare un champ (crée l'offset `NomStruct.champ`) |
| `endstruc` | Fin (crée `NomStruct_size`) |
| `istruc NomStruct` | Instanciation statique avec données |
| `at NomStruct.champ, dX val` | Initialiser un champ dans `istruc` |
| `iend` | Fin d'`istruc` |
| `resb NomStruct_size` | Réserver de la place en `.bss` |

- Insérer du padding explicite pour garantir l'alignement des champs.
- Accéder aux champs avec `[registre + NomStruct.champ]`.
