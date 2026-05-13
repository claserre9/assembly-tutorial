# Solutions — Chapitre 12 : Gestion de la pile

## Solution 1 — Tracer la pile

```
rsp initial = 0x7FFF1000

push rax  (rax=100) → rsp = 0x7FFEFF8 ; [0x7FFEFF8] = 100
push rbx  (rbx=200) → rsp = 0x7FFEFF0 ; [0x7FFEFF0] = 200
push rcx  (rcx=300) → rsp = 0x7FFEFE8 ; [0x7FFEFE8] = 300

pop rax  → rax = 300, rsp = 0x7FFEFF0
pop rbx  → rbx = 200, rsp = 0x7FFEFF8
pop rcx  → rcx = 100, rsp = 0x7FFF1000
```

## Solution 2 — produit_scalaire

```nasm
; rdi = vecteur A, rsi = vecteur B → rax = A·B
produit_scalaire:
    push rbp
    mov  rbp, rsp
    sub  rsp, 16                ; [rbp-8] = somme, [rbp-16] = i

    mov  qword [rbp - 8],  0   ; somme = 0
    mov  qword [rbp - 16], 0   ; i = 0

.boucle:
    mov  rcx, [rbp - 16]
    cmp  rcx, 3
    jge  .fin

    mov  rax, [rdi + rcx * 8]
    imul rax, [rsi + rcx * 8]
    add  [rbp - 8], rax

    inc  qword [rbp - 16]
    jmp  .boucle

.fin:
    mov  rax, [rbp - 8]
    mov  rsp, rbp
    pop  rbp
    ret
```

## Solution 3 — Bug de pile

```nasm
ma_fonction:
    push rbp
    mov  rbp, rsp
    sub  rsp, 8         ; 1 variable locale

    push rbx
    mov  rbx, rdi

    mov  rax, rbx

    pop  rbx
    mov  rsp, rbp       ; ← MANQUAIT cette ligne pour restaurer rsp
    pop  rbp
    ret
```

**Explication** : Après `sub rsp, 8`, `rsp` pointe 8 octets plus bas que `rbp`. Sans `mov rsp, rbp`, le `pop rbp` lirait la mauvaise valeur de la pile et `ret` retournerait vers une adresse incorrecte.
