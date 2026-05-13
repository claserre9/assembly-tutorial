# Exercices — Chapitre 03 : Constantes et données

## Exercice 1 — Déclarations de données

Déclarez dans la section `.data` :
- Une chaîne `titre` contenant "Mon titre" + saut de ligne
- Un entier 64 bits `compteur` initialisé à 0
- Un tableau `notes` de 5 entiers 32 bits valant 15, 12, 18, 9, 14
- Calculez la taille de `notes` avec `equ`

## Exercice 2 — Section `.bss`

Écrivez les déclarations `.bss` pour :
- Un tampon de 128 octets nommé `input_buf`
- Un tableau de 10 quadwords nommé `resultats`
- Une variable `temp` de 4 octets

## Exercice 3 — Modifier des données

Écrivez un programme qui :
1. Déclare une variable `valeur dq 42` dans `.data`
2. Multiplie la valeur par 2 (en utilisant `shl` ou `add`)
3. Stocke le résultat dans une variable `.bss` nommée `double_val`
4. Quitte avec comme code de retour la valeur de `double_val` (si ≤ 255)
