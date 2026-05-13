# Exercices — Chapitre 15 : Virgule flottante

## Exercice 1 — Conversion de températures

Écrivez un programme qui convertit 100.0°C en Fahrenheit :
- Formule : F = C × 9/5 + 32
- Utilisez des registres XMM et les instructions SSE2 scalaires
- Stockez le résultat dans une variable `.bss`

Valeur attendue : 212.0

## Exercice 2 — Distance euclidienne

Écrivez une procédure `distance` qui calcule la distance entre deux points 2D :
- Arguments : `xmm0` = x1, `xmm1` = y1, `xmm2` = x2, `xmm3` = y2
- Retour : `xmm0` = sqrt((x2-x1)² + (y2-y1)²)
- Utilisez `subsd`, `mulsd`, `addsd`, `sqrtsd`

## Exercice 3 — Comparaison de flottants

Écrivez un programme qui compare deux doubles et affiche "Egal", "Superieur" ou "Inferieur".

*Important* : La comparaison directe de flottants peut être imprécise à cause de l'arrondi IEEE 754. Utilisez une tolérance `epsilon = 1e-9` :
```
|a - b| < epsilon → considérer comme égaux
```

## Exercice 4 — Vecteur additionneur (SSE scalaire)

Écrivez un programme qui calcule la somme de 4 flottants 32 bits stockés en mémoire en utilisant des additions scalaires SSE (`addss`).
