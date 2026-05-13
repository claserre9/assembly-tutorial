# Exercices — Chapitre 10 : Chaînes de caractères

## Exercice 1 — Implémenter strcmp

Écrivez une procédure `strcmp_asm` qui compare deux chaînes null-terminées :
- `rdi` = adresse de chaîne 1
- `rsi` = adresse de chaîne 2
- Retourne `rax` = 0 si égales, -1 si str1 < str2, 1 si str1 > str2

## Exercice 2 — Inverser une chaîne

Écrivez une procédure `inverser_chaine` qui inverse une chaîne null-terminée en place :
- `rdi` = adresse de la chaîne

Exemple : "Bonjour" → "ruojnoB"

## Exercice 3 — Majuscule

Écrivez une procédure `vers_majuscules` qui convertit une chaîne en majuscules :
- `rdi` = adresse de la chaîne (null-terminée)
- Modifier la chaîne en place
- Les lettres minuscules ('a'-'z') ont le code ASCII 97-122
- Les majuscules ('A'-'Z') ont le code ASCII 65-90
- Différence : 32 (soustraction)

## Exercice 4 — Utiliser REPNE SCASB

Réécrivez votre implémentation de `strlen` en utilisant `repne scasb` au lieu d'une boucle explicite. Vérifiez que les deux implémentations donnent le même résultat.
