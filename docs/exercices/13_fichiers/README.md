# Exercices — Chapitre 13 : Fichiers

## Exercice 1 — Copier un fichier

Écrivez un programme qui :
1. Ouvre `/tmp/source.txt` en lecture
2. Ouvre `/tmp/destination.txt` en écriture (créer si absent, tronquer si existant)
3. Lit le fichier source par blocs de 64 octets
4. Écrit chaque bloc dans le fichier destination
5. Continue jusqu'à la fin du fichier (sys_read retourne 0)
6. Ferme les deux fichiers

## Exercice 2 — Compter les lignes

Écrivez un programme qui lit `/etc/passwd` et compte le nombre de lignes (caractères `\n`). Affichez le résultat sur stdout.

## Exercice 3 — Fichier de log

Écrivez un programme qui :
1. Ouvre `/tmp/log.txt` en mode append (O_WRONLY | O_CREAT | O_APPEND = `0x401`)
2. Écrit une ligne de log : "Programme démarré\n"
3. Ferme le fichier
4. Vérifie chaque appel système et affiche "Erreur: open" ou "Erreur: write" en cas d'échec
