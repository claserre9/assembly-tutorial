# Chapitre 17 — Listes chaînées

## Concepts abordés

- Représentation d'un nœud avec `struc`
- Pointeurs `NULL` (valeur 0 en assembleur)
- Parcours d'une liste (traversal)
- Insertion en tête et en queue
- Suppression d'un nœud

## Structure d'un nœud

```nasm
struc Noeud
    .valeur:    resq 1      ; données
    .suivant:   resq 1      ; pointeur vers le nœud suivant
    .taille:
endstruc
```

## Parcourir une liste

```nasm
; rbx = pointeur vers le premier nœud (ou 0 si liste vide)
.boucle:
    test rbx, rbx           ; vérifier si NULL
    jz   .fin_liste

    mov rax, [rbx + Noeud.valeur]   ; accéder à la valeur
    ; ... traiter rax ...

    mov rbx, [rbx + Noeud.suivant]  ; avancer au nœud suivant
    jmp .boucle
.fin_liste:
```

## Insertion en tête

```nasm
; rdi = adresse du nouveau nœud, rbx = pointeur tête actuelle
mov [rdi + Noeud.suivant], rbx  ; nouveau.suivant = ancienne tête
mov rbx, rdi                    ; tête = nouveau nœud
```

## Suppression d'un nœud

Pour supprimer `noeud_a_supprimer` dont le prédécesseur est `pred` :

```nasm
mov rax, [pred + Noeud.suivant]         ; rax = noeud_a_supprimer
mov rcx, [rax + Noeud.suivant]          ; rcx = noeud_suivant
mov [pred + Noeud.suivant], rcx         ; pred.suivant = noeud_suivant
; (libérer la mémoire si allouée dynamiquement via brk/mmap)
```

## Allouer de la mémoire dynamiquement

En assembleur pur Linux, on peut utiliser `sys_brk` (syscall 12) ou `sys_mmap` (syscall 9) pour allouer de la mémoire pour les nœuds dynamiques. Dans la pratique, on se lie souvent à la `libc` pour utiliser `malloc`.
