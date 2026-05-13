# Exercices — Chapitre 17 : Listes chaînées

## Exercice 1 — Longueur d'une liste

Écrivez une procédure `longueur_liste` qui :
- Prend `rdi` = pointeur vers le premier nœud (ou 0 si liste vide)
- Retourne `rax` = nombre de nœuds

## Exercice 2 — Recherche dans une liste

Écrivez une procédure `chercher` qui :
- Prend `rdi` = pointeur vers la tête, `rsi` = valeur à chercher
- Retourne `rax` = pointeur vers le premier nœud ayant cette valeur, ou 0 si non trouvé

## Exercice 3 — Inverser une liste

Écrivez une procédure `inverser_liste` qui inverse en place une liste chaînée statique et retourne le nouveau pointeur de tête.

Schéma :
```
Avant : noeud1(10) → noeud2(20) → noeud3(30) → NULL
Après : noeud3(30) → noeud2(20) → noeud1(10) → NULL
```

## Exercice 4 — Insérer en ordre trié

Écrivez une procédure qui insère un nouveau nœud (adresse dans `rdi`, valeur dans `rsi`) dans une liste triée par ordre croissant.
