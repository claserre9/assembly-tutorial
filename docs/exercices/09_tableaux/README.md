# Exercices — Chapitre 09 : Tableaux

## Exercice 1 — Trouver le minimum

Écrivez un programme avec une procédure `trouver_min` qui :
- Prend `rdi` = adresse d'un tableau de quadwords, `rsi` = nombre d'éléments
- Retourne `rax` = valeur minimale du tableau

Testez avec `[42, 7, 99, 3, 55]` — réponse attendue : 3.

## Exercice 2 — Inverser un tableau

Écrivez une procédure `inverser_tableau` qui inverse en place un tableau d'entiers 64 bits :
- `rdi` = adresse du tableau
- `rsi` = nombre d'éléments

Exemple : `[1, 2, 3, 4, 5]` → `[5, 4, 3, 2, 1]`

## Exercice 3 — Tableau 2D

Déclarez un tableau 2D de 3×3 quadwords et écrivez un programme qui calcule la somme de la diagonale principale (éléments [0][0], [1][1], [2][2]).

```nasm
; Tableau 3x3 (3 lignes × 3 colonnes)
matrice dq  1, 2, 3,   \
            4, 5, 6,   \
            7, 8, 9
; Accès à [ligne][colonne] : [matrice + (ligne*3 + colonne)*8]
; Diagonale : 1 + 5 + 9 = 15
```
