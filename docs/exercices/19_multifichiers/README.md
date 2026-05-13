# Exercices — Chapitre 19 : Multi-fichiers

## Exercice 1 — Créer un module mathématique

Créez deux fichiers :

**math_utils.asm** — module avec les fonctions suivantes (toutes `global`) :
- `puissance` : rdi=base, rsi=exposant, retourne rax=base^exposant
- `est_premier` : rdi=n, retourne rax=1 si premier, 0 sinon
- `pgcd` : rdi=a, rsi=b, retourne rax=PGCD(a,b) (algorithme d'Euclide)

**main.asm** — programme principal qui :
- Importe les 3 fonctions via `extern`
- Les appelle avec des valeurs test
- Affiche les résultats

## Exercice 2 — Makefile

Écrivez un `Makefile` pour compiler les fichiers de l'exercice 1 :
- Cible `all` : compile et lie math_utils.o et main.o
- Cible `clean` : supprime les .o et le binaire
- Cible `run` : exécute le binaire

## Exercice 3 — Fichier d'en-tête partagé

Créez un fichier `constantes.inc` contenant :
- Les numéros de syscall (`SYS_WRITE`, `SYS_READ`, `SYS_EXIT`, `SYS_OPEN`, `SYS_CLOSE`)
- Des macros utilitaires (`exit`, `print`)
- Les flags de fichiers (`O_RDONLY`, `O_WRONLY`, `O_CREAT`)

Refactorisez ensuite les fichiers de l'exercice 1 pour utiliser `%include "constantes.inc"`.
