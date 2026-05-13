# Exercices — Chapitre 18 : SIMD

## Exercice 1 — Addition vectorielle

Déclarez deux vecteurs de 4 floats et calculez leur somme élément par élément en utilisant `addps`. Stockez le résultat dans un troisième vecteur.

```nasm
vec_a dd 1.0, 2.0, 3.0, 4.0
vec_b dd 5.0, 6.0, 7.0, 8.0
; résultat attendu : {6.0, 8.0, 10.0, 12.0}
```

## Exercice 2 — Produit scalaire SIMD

Calculez le produit scalaire de deux vecteurs de 4 floats en utilisant `mulps` puis une réduction horizontale :
- `mulps xmm2, xmm0, xmm1` : produits éléments-par-éléments
- Additionner les 4 résultats pour obtenir un scalaire

*Astuce : deux `haddps` suffisent si SSE3 est disponible.*

## Exercice 3 — Normalisation

Écrivez un programme qui normalise un vecteur 4D (float) en utilisant SSE :
1. Calculer la norme : sqrt(x²+y²+z²+w²) — utiliser `mulps`, `haddps`, `sqrtss`
2. Diviser chaque composante par la norme : `divps`

## Exercice 4 — Comparaison du speedup

Implémentez l'addition de 1000 paires de floats avec :
a) Une boucle scalaire classique
b) Une boucle vectorielle avec `addps` (4 floats à la fois)

Observez la différence de nombre d'itérations.
