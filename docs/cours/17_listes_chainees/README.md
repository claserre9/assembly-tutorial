# Chapitre 17 — Listes chaînées en assembleur

## 17.1 Structure d'un nœud

Une liste chaînée simple est composée de **nœuds** contenant une valeur et un pointeur vers le nœud suivant.

```nasm
struc Node
    .value  resq 1   ; offset 0 : valeur (int64)
    .next   resq 1   ; offset 8 : pointeur vers le prochain nœud (ou NULL = 0)
endstruc             ; Node_size = 16
```

**Convention** : un pointeur `next = 0` signifie la fin de la liste (`NULL`).

---

## 17.2 Allocation de nœuds

En assembleur bas niveau, on utilise un **pool statique** de nœuds en `.bss` pour éviter d'appeler `malloc` :

```nasm
%define MAX_NODES 64

section .bss
    node_pool  resb Node_size * MAX_NODES
    pool_index resq 1     ; prochain nœud libre

section .data
    head       dq 0       ; tête de liste (NULL = liste vide)
```

```nasm
; Allouer un nouveau nœud — retourne rax = adresse du nœud
alloc_node:
    mov  rax, [pool_index]
    cmp  rax, MAX_NODES
    jge  .overflow          ; pool plein

    imul rcx, rax, Node_size
    lea  rax, [node_pool + rcx]   ; adresse = pool + index * taille

    mov  rbx, [pool_index]
    inc  rbx
    mov  [pool_index], rbx
    ret

.overflow:
    xor  rax, rax           ; retourner NULL en cas d'erreur
    ret
```

---

## 17.3 Insertion en tête

```nasm
; insert_head(rdi = valeur)
; Modifie la variable globale 'head'
insert_head:
    push rbx
    push r12

    mov  r12, rdi           ; sauvegarder la valeur

    call alloc_node
    test rax, rax
    jz   .done              ; allocation échouée

    mov  rbx, rax           ; rbx = nouveau nœud

    ; Initialiser le nœud
    mov  [rbx + Node.value], r12     ; nœud.value = valeur
    mov  rcx, [head]
    mov  [rbx + Node.next],  rcx     ; nœud.next = ancienne tête

    ; Mettre à jour la tête
    mov  [head], rbx

.done:
    pop  r12
    pop  rbx
    ret
```

---

## 17.4 Insertion en queue

```nasm
; insert_tail(rdi = valeur)
insert_tail:
    push rbx
    push r12
    push r13

    mov  r12, rdi

    call alloc_node
    test rax, rax
    jz   .done

    mov  r13, rax
    mov  [r13 + Node.value], r12
    mov  qword [r13 + Node.next], 0   ; next = NULL

    ; Cas liste vide
    cmp  qword [head], 0
    jne  .find_tail
    mov  [head], r13
    jmp  .done

.find_tail:
    mov  rbx, [head]        ; rbx = nœud courant
.loop:
    mov  rcx, [rbx + Node.next]
    test rcx, rcx
    jz   .insert            ; rcx == NULL : rbx est la queue
    mov  rbx, rcx
    jmp  .loop

.insert:
    mov  [rbx + Node.next], r13   ; dernier.next = nouveau nœud

.done:
    pop  r13
    pop  r12
    pop  rbx
    ret
```

---

## 17.5 Parcours de la liste

```nasm
; print_list — affiche chaque valeur (suppose une fonction print_int)
print_list:
    mov  rbx, [head]        ; rbx = nœud courant
.loop:
    test rbx, rbx
    jz   .done              ; NULL : fin de liste

    mov  rdi, [rbx + Node.value]
    call print_int          ; afficher la valeur

    mov  rbx, [rbx + Node.next]   ; avancer au nœud suivant
    jmp  .loop

.done:
    ret
```

---

## 17.6 Suppression en tête

```nasm
; delete_head — supprime le premier nœud
; retourne rax = valeur supprimée (ou 0 si liste vide)
delete_head:
    mov  rbx, [head]
    test rbx, rbx
    jz   .empty             ; liste vide

    mov  rax, [rbx + Node.value]   ; valeur à retourner
    mov  rcx, [rbx + Node.next]    ; successeur
    mov  [head], rcx               ; nouvelle tête
    ret

.empty:
    xor  rax, rax
    ret
```

---

## 17.7 Recherche d'une valeur

```nasm
; search(rdi = valeur) — retourne rax = adresse du nœud ou NULL
search:
    mov  rbx, [head]
.loop:
    test rbx, rbx
    jz   .not_found
    cmp  [rbx + Node.value], rdi
    je   .found
    mov  rbx, [rbx + Node.next]
    jmp  .loop
.found:
    mov  rax, rbx
    ret
.not_found:
    xor  rax, rax
    ret
```

---

## 17.8 Suppression d'un nœud par valeur

```nasm
; delete_value(rdi = valeur)
delete_value:
    push rbx
    push r12

    ; Cas tête
    mov  rbx, [head]
    test rbx, rbx
    jz   .done

    cmp  [rbx + Node.value], rdi
    jne  .search_middle
    mov  rax, [rbx + Node.next]
    mov  [head], rax
    jmp  .done

.search_middle:
    mov  r12, rbx               ; r12 = nœud précédent
    mov  rbx, [rbx + Node.next] ; rbx = nœud courant
.loop:
    test rbx, rbx
    jz   .done                  ; valeur non trouvée

    cmp  [rbx + Node.value], rdi
    je   .remove

    mov  r12, rbx
    mov  rbx, [rbx + Node.next]
    jmp  .loop

.remove:
    mov  rcx, [rbx + Node.next]
    mov  [r12 + Node.next], rcx  ; précédent.next = suivant

.done:
    pop  r12
    pop  rbx
    ret
```

---

## Résumé

| Opération | Complexité | Clé |
|-----------|-----------|-----|
| Insertion tête | O(1) | Mettre à jour `head` |
| Insertion queue | O(n) | Parcourir jusqu'à `next == NULL` |
| Suppression tête | O(1) | `head = head.next` |
| Suppression valeur | O(n) | Relier `prev.next = curr.next` |
| Recherche | O(n) | Parcourir jusqu'à correspondance |

- Toujours vérifier `NULL` avant de déréférencer un pointeur (`test rbx, rbx`).
- Utiliser des registres callee-saved (`rbx`, `r12`–`r15`) pour les pointeurs persistants entre les instructions.
- Un pool statique simplifie la gestion mémoire sans syscall `mmap`.
