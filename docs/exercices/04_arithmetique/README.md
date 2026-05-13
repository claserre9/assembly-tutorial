# Exercices — Chapitre 04 : Arithmétique

## Exercice 1 — Calculatrice simple

Écrivez un programme qui calcule et stocke :
- `a = 100`, `b = 37`
- `somme = a + b`
- `difference = a - b`
- `produit = a * b` (utiliser `imul`)
- `quotient = a / b` (utiliser `div`, ne pas oublier `xor rdx, rdx`)

Quittez avec le code de retour = quotient.

## Exercice 2 — Opérations bit à bit

Sans exécuter le code, calculez manuellement le résultat de chaque opération sur `rax = 0b10110011` :

1. `and rax, 0b00001111` → rax = ?
2. `or  rax, 0b11000000` → rax = ?
3. `xor rax, 0b11111111` → rax = ?
4. `shl rax, 2`          → rax = ? (en binaire et décimal)
5. `shr rax, 1`          → rax = ?

## Exercice 3 — Puissance de 2

Écrivez une procédure `puissance_de_2` qui :
- Prend `rdi` = exposant n (0 ≤ n ≤ 63)
- Retourne `rax` = 2^n
- **N'utilise pas** `mul` — utilisez uniquement `shl`

Testez avec n = 0, 1, 8, 32.
