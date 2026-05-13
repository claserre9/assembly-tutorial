# Exercices — Chapitre 05 : Entrées/Sorties

## Exercice 1 — Écho de saisie

Écrivez un programme qui :
1. Affiche le message "Entrez du texte : "
2. Lit jusqu'à 64 caractères depuis stdin
3. Affiche "Vous avez saisi : " puis le texte lu
4. Affiche le nombre d'octets lus (code de retour de `sys_read`)

## Exercice 2 — Ecriture sur stderr

Modifiez le programme suivant pour que le message d'erreur parte sur stderr (fd=2) et non stdout :

```nasm
; Actuellement incorrect : le message d'erreur va sur stdout
mov rax, 1
mov rdi, 1          ; ← corriger ici
mov rsi, msg_erreur
mov rdx, msg_len
syscall
```

## Exercice 3 — Lire un fichier

Écrivez un programme qui :
1. Ouvre le fichier `/etc/hostname` en lecture seule
2. Lit son contenu dans un tampon de 64 octets
3. Affiche le contenu sur stdout
4. Ferme le fichier
5. Vérifie que `sys_open` n'a pas retourné d'erreur (rax < 0 → afficher "Erreur" et quitter avec code 1)
