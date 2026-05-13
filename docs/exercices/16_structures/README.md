# Exercices — Chapitre 16 : Structures

## Exercice 1 — Définir une structure Rectangle

Définissez la structure `Rectangle` avec les champs `largeur` et `hauteur` (entiers 64 bits), puis :
1. Instanciez un `Rectangle` avec largeur=10, hauteur=5
2. Écrivez une procédure `aire` qui prend un pointeur vers Rectangle et retourne largeur × hauteur
3. Testez la procédure

## Exercice 2 — Tableau de structures

Déclarez un tableau de 3 `Rectangle` et écrivez un programme qui calcule la somme des aires.

```nasm
rectangles:
    dq 10, 5    ; rect[0] : 10×5 = 50
    dq  3, 7    ; rect[1] : 3×7  = 21
    dq  6, 4    ; rect[2] : 6×4  = 24
; Somme = 95
```

## Exercice 3 — Structure imbriquée

Définissez :
```nasm
struc Cercle
    .centre:   resb Point2D.taille    ; Point2D embarqué
    .rayon:    resq 1
    .taille:
endstruc
```

Écrivez le code pour accéder au champ `x` du centre d'un cercle depuis un pointeur `rsi`.
