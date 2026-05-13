# Projet Final — Gestionnaire d'Étudiants en Assembleur

## Description

Ce projet capstone implémente un gestionnaire simple d'étudiants en assembleur x86-64, en appliquant les concepts des 19 chapitres du tutoriel.

## Fonctionnalités

1. **Ajouter un étudiant** — saisir nom, âge et note
2. **Afficher tous les étudiants** — liste complète avec numérotation
3. **Rechercher par nom** — recherche linéaire dans la liste
4. **Calculer la moyenne** — moyenne des notes de tous les étudiants
5. **Trouver le meilleur** — étudiant avec la note la plus haute
6. **Sauvegarder dans un fichier** — export des données en texte

## Structure du projet

```
project/
├── main.asm          # Point d'entrée et menu principal
├── etudiant.asm      # Gestion des données étudiants
├── io_utils.asm      # Fonctions E/S (print_string, print_uint, read_string)
├── math_utils.asm    # Calculs (moyenne, recherche max)
└── README.md
```

## Structure de données Étudiant

```nasm
struc Etudiant
    .nom:       resb 32     ; nom de l'étudiant (null-terminé)
    .age:       resb 1      ; âge (octet)
    .padding:   resb 7      ; alignement
    .note:      resq 1      ; note sur 100 (entier 64 bits)
    .taille:
endstruc

MAX_ETUDIANTS equ 50
```

## Compilation

```bash
nasm -f elf64 main.asm      -o main.o
nasm -f elf64 etudiant.asm  -o etudiant.o
nasm -f elf64 io_utils.asm  -o io_utils.o
nasm -f elf64 math_utils.asm -o math_utils.o
ld -o gestionnaire main.o etudiant.o io_utils.o math_utils.o
./gestionnaire
```

## Concepts mis en pratique

| Chapitre | Concept appliqué |
|---------|-----------------|
| 01–03 | Structure des sections, constantes, données |
| 04 | Calcul de la moyenne (addition, division) |
| 05 | Saisie clavier et affichage |
| 06–07 | Menu interactif (boucle + conditions) |
| 08 | Fonctions modulaires par module |
| 09–10 | Tableau d'étudiants, manipulation de chaînes |
| 11 | Adressage des champs de structure |
| 12 | Gestion du cadre de pile |
| 13 | Sauvegarde dans un fichier |
| 14 | Macros pour les syscalls courants |
| 16 | Structure `Etudiant` avec `struc` |
| 19 | Compilation multi-fichiers |
