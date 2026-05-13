# Chapitre 4 — Opérations arithmétiques

## 4.1 Addition et soustraction

Les instructions `add` et `sub` modifient le registre destination en place.

```nasm
section .text
global _start

_start:
    mov rax, 10
    add rax, 5      ; rax = 15
    sub rax, 3      ; rax = 12

    ; Opérandes immédiates, registres ou mémoire
    mov rbx, 4
    add rax, rbx    ; rax = rax + rbx
    sub rax, [var]  ; rax = rax - valeur en mémoire
```

`inc` et `dec` incrémentent ou décrémentent de 1 sans affecter le drapeau CF (pratique dans les boucles).

```nasm
    inc rax     ; rax++
    dec rbx     ; rbx--
```

## 4.2 Multiplication

### Multiplication non signée : `mul`

`mul` multiplie **rax** par l'opérande, résultat dans **rdx:rax** (128 bits).

```nasm
    mov rax, 6
    mov rbx, 7
    mul rbx         ; rdx:rax = 6 * 7 = 42 (rdx = 0, rax = 42)
```

### Multiplication signée : `imul`

`imul` supporte plusieurs formes :

```nasm
    imul rbx                ; rdx:rax = rax * rbx (forme 1)
    imul rax, rbx           ; rax = rax * rbx     (forme 2, 64 bits)
    imul rax, rbx, 10       ; rax = rbx * 10      (forme 3, immédiat)
```

La forme à deux ou trois opérandes **tronque à 64 bits** mais est plus pratique.

## 4.3 Division

### Division non signée : `div`

Divise **rdx:rax** par l'opérande. Quotient dans **rax**, reste dans **rdx**.

> **Piège critique :** toujours mettre `rdx` à zéro avant `div`, sinon exception `#DE`.

```nasm
    mov rax, 100
    xor rdx, rdx    ; rdx = 0 (obligatoire !)
    mov rbx, 7
    div rbx         ; rax = 14 (quotient), rdx = 2 (reste)
```

### Division signée : `idiv`

Pour `idiv`, étendre le signe de `rax` vers `rdx` avec l'instruction `cqo` (Convert Quadword to Octword).

```nasm
    mov rax, -100
    cqo             ; signe de rax propagé dans rdx (rdx = 0xFFFF... si négatif)
    mov rbx, 7
    idiv rbx        ; rax = -14, rdx = -2
```

## 4.4 Opérations sur les bits

| Instruction | Effet                          |
|-------------|-------------------------------|
| `and a, b`  | ET bit à bit                  |
| `or  a, b`  | OU bit à bit                  |
| `xor a, b`  | OU exclusif                   |
| `not a`     | Complément (inversion)        |

```nasm
    mov rax, 0xFF
    and rax, 0x0F   ; rax = 0x0F  (masque les 4 bits supérieurs)
    or  rax, 0x30   ; rax = 0x3F
    xor rax, rax    ; rax = 0     (idiome classique pour mettre à zéro)
    not rax         ; rax = 0xFFFFFFFFFFFFFFFF
```

## 4.5 Décalages

```nasm
    mov rax, 8
    shl rax, 2      ; décalage logique gauche  : rax = 32  (× 4)
    shr rax, 1      ; décalage logique droite  : rax = 16  (÷ 2, non signé)
    sar rax, 1      ; décalage arithmétique dr.: préserve le signe
    rol rax, 3      ; rotation gauche
    ror rax, 3      ; rotation droite
```

`shl`/`shr` insèrent des zéros. `sar` propage le bit de signe (division signée par puissance de 2).

## 4.6 Drapeaux affectés (RFLAGS)

| Drapeau | Nom         | Mis à 1 si…                         |
|---------|-------------|--------------------------------------|
| CF      | Carry       | Débordement non signé               |
| OF      | Overflow    | Débordement signé                   |
| ZF      | Zero        | Résultat == 0                       |
| SF      | Sign        | Bit de poids fort du résultat == 1  |
| PF      | Parity      | Nombre pair de bits à 1 (octet bas) |

`add`/`sub` affectent tous ces drapeaux. `inc`/`dec` n'affectent pas CF.

## 4.7 Exemple complet : division euclidienne

```nasm
; Calcule quotient et reste de a / b
; entrée : rdi = a, rsi = b
; sortie : rax = quotient, rdx = reste
divide_unsigned:
    mov rax, rdi
    xor rdx, rdx
    div rsi
    ret
```

## Résumé

- Toujours initialiser `rdx` avant `div` / utiliser `cqo` avant `idiv`.
- `imul` à deux opérandes est plus commode pour la multiplication courante.
- `xor reg, reg` est le moyen le plus rapide de mettre un registre à zéro.
- Les décalages de N bits équivalent à une multiplication/division par 2^N.
