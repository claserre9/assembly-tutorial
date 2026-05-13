# Exercices — Chapitre 06 : Conditions et sauts

## Exercice 1 — Classification de nombre

Écrivez un programme qui prend une valeur dans `rax` et affiche :
- "Positif" si rax > 0
- "Négatif" si rax < 0
- "Zéro" si rax = 0

## Exercice 2 — Maximum de trois nombres

Écrivez une procédure `max3` qui :
- Prend trois arguments : `rdi`, `rsi`, `rdx`
- Retourne dans `rax` la valeur maximale des trois

```nasm
; Test :
mov rdi, 15
mov rsi, 42
mov rdx, 7
call max3
; rax doit valoir 42
```

## Exercice 3 — Déduction des sauts

Pour chaque code C suivant, écrivez la version assembleur équivalente :

**a)**
```c
if (a == b) { x = 1; } else { x = 2; }
```

**b)**
```c
if (a > 0 && b > 0) { c = a + b; }
```

**c)**
```c
int max = (a > b) ? a : b;
```
Utilisez `cmovg` pour l'exercice c).
