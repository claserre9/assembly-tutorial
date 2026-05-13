# Chapitre 16 — Structures

## Concepts abordés

- Directive `struc` / `endstruc` pour définir une structure
- Directive `istruc` / `iend` pour instancier statiquement
- Accès aux champs via les offsets symboliques
- Alignement mémoire des structures
- Tableaux de structures

## Définir une structure

```nasm
struc NomStruct
    .champ1:    resb 1      ; offset = 0
    .champ2:    resw 1      ; offset = 1
    .champ3:    resd 1      ; offset = 3
    .champ4:    resq 1      ; offset = 7
    .taille:                ; taille totale de la structure
endstruc
```

Les noms `.champ` sont des constantes représentant l'**offset** depuis le début de la structure.

## Instancier une structure (statique)

```nasm
section .data
mon_point:
    istruc Point2D
        at Point2D.x, dq 10
        at Point2D.y, dq 20
    iend
```

## Instancier dans `.bss`

```nasm
section .bss
etudiant1   resb Etudiant.taille    ; réserver l'espace nécessaire
```

## Accéder aux champs

```nasm
; Lecture
mov rax, [mon_point + Point2D.x]

; Écriture
mov qword [mon_point + Point2D.y], 99

; Via un registre pointeur
mov rsi, mon_point
mov rax, [rsi + Point2D.x]
```

## Tableau de structures

```nasm
; Itérer sur un tableau de Point2D
mov rsi, tableau_points
mov rcx, nb_points
.boucle:
    mov rax, [rsi + Point2D.x]
    mov rbx, [rsi + Point2D.y]
    add rsi, Point2D.taille     ; avancer au prochain élément
    dec rcx
    jnz .boucle
```

## Alignement

Pour de meilleures performances, aligner chaque champ sur sa taille naturelle :
- `db` (1 octet) → pas de contrainte
- `dw` (2 octets) → aligner sur 2
- `dd` (4 octets) → aligner sur 4
- `dq` (8 octets) → aligner sur 8

Utiliser `alignb` pour insérer du padding si nécessaire.
