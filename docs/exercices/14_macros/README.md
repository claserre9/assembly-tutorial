# Exercices — Chapitre 14 : Macros

## Exercice 1 — Macro sys_exit

Créez une macro `sys_exit` qui prend un argument (code de retour) et génère le code pour terminer le programme.

```nasm
; Utilisation souhaitée :
sys_exit 0      ; quitter avec code 0
sys_exit 1      ; quitter avec code 1
```

## Exercice 2 — Macro print_msg

Créez une macro `print_msg` qui prend une chaîne littérale en argument, la définit automatiquement dans `.data` (avec un label unique via `%%`), et l'affiche sur stdout.

```nasm
; Utilisation souhaitée :
print_msg "Bonjour!"
print_msg "Au revoir!"
```

## Exercice 3 — Macro de boucle

Créez une macro `repeter` qui répète un bloc N fois :

```nasm
; Utilisation souhaitée :
repeter 5, {
    ; corps à répéter
}
```

*Note : NASM ne supporte pas les blocs inline, adaptez la macro pour appeler une procédure ou utilisez un compteur + jump.*

## Exercice 4 — Compilation conditionnelle

Utilisez `%define` et `%ifdef` pour créer du code de débogage conditionnel :

```nasm
; Si DEBUG est défini, afficher chaque valeur importante
; nasm -DDEBUG -f elf64 programme.asm ...
```
