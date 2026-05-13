# Chapitre 11 — Modes d'adressage

## Concepts abordés

- Adressage immédiat, par registre, direct, indirect
- Adressage indexé avec scale et déplacement
- Instruction `lea` (Load Effective Address)
- Adressage relatif à `rbp` pour les variables locales

## Résumé des modes d'adressage x86-64

### 1. Immédiat

```nasm
mov rax, 42             ; rax = 42 (constante dans l'instruction)
```

### 2. Registre

```nasm
mov rbx, rax            ; rbx = rax
```

### 3. Mémoire directe (adresse absolue)

```nasm
mov rax, [variable]     ; rax = *variable
mov [variable], rax     ; *variable = rax
```

### 4. Indirect (via registre)

```nasm
mov rsi, adresse        ; rsi = &tableau
mov rax, [rsi]          ; rax = tableau[0]
mov rax, [rsi + 8]      ; rax = tableau[1]
```

### 5. Indexé

```nasm
; [base + index * scale + déplacement]
mov rax, [tableau + rcx * 8]         ; tableau[rcx]
mov rax, [rsi + rcx * 4 + 16]        ; *(rsi + rcx*4 + 16)
```

Valeurs valides pour `scale` : **1, 2, 4, 8**

### 6. Relatif à `rbp` (variables locales sur la pile)

```nasm
push rbp
mov  rbp, rsp
sub  rsp, 32

mov qword [rbp - 8],  valeur1   ; 1re variable locale
mov qword [rbp - 16], valeur2   ; 2e variable locale
```

## `LEA` vs déréférencement

```nasm
mov rax, [tableau + 2]  ; charge la valeur en mémoire (déréférence)
lea rax, [tableau + 2]  ; charge l'adresse (tableau + 2), sans déréférencer
```

`lea` est souvent utilisé comme multiplication/addition rapide :

```nasm
lea rax, [rcx * 4 + rcx]   ; rax = rcx * 5 (en une instruction)
```
