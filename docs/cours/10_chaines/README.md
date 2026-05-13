# Chapitre 10 — Chaînes de caractères

## 10.1 Représentation des chaînes

En assembleur x86 (comme en C), les chaînes sont des séquences d'octets terminées par un **octet nul** (`0x00`).

```nasm
section .data
    salut  db "Bonjour", 0       ; chaîne null-terminée
    ligne  db "Hello", 0x0A, 0   ; avec retour à la ligne
    vide   db 0                  ; chaîne vide
```

---

## 10.2 Instructions de chaîne (string instructions)

Les instructions de chaîne opèrent sur les paires de registres pointeurs :
- **Source** : `rsi` (RSI = source index)
- **Destination** : `rdi` (RDI = destination index)
- **Compteur** : `rcx`

Après chaque opération, `rsi` et/ou `rdi` sont **automatiquement incrémentés ou décrémentés** selon le drapeau de direction `DF` :
- `DF = 0` (après `cld`) : auto-incrément
- `DF = 1` (après `std`) : auto-décrément

**Toujours utiliser `cld` en début de fonction** pour assurer `DF = 0`.

### Tableau des instructions de chaîne

| Instruction | Action par élément | Taille |
|-------------|-------------------|--------|
| `movsb/w/d/q` | `[rdi] = [rsi]`, avance rsi et rdi | 1/2/4/8 |
| `stosb/w/d/q` | `[rdi] = al/ax/eax/rax`, avance rdi | 1/2/4/8 |
| `lodsb/w/d/q` | `al/ax/eax/rax = [rsi]`, avance rsi | 1/2/4/8 |
| `scasb/w/d/q` | compare `al/ax/eax/rax` à `[rdi]`, avance rdi | 1/2/4/8 |
| `cmpsb/w/d/q` | compare `[rsi]` à `[rdi]`, avance les deux | 1/2/4/8 |

---

## 10.3 Préfixes de répétition

```nasm
rep     ; répéter rcx fois (movsb, stosb, lodsb)
repe    ; répéter tant que ZF=1 et rcx > 0 (cmpsb, scasb)
repne   ; répéter tant que ZF=0 et rcx > 0 (scasb pour chercher un octet)
```

---

## 10.4 Implémentation de `strlen`

```nasm
; strlen(rdi) — retourne rax = longueur (sans le '\0')
strlen:
    cld
    xor  rcx, rcx           ; rcx = 0 (compteur)
    xor  al, al             ; chercher l'octet 0x00
    mov  rdi, rdi           ; (rdi = adresse de la chaîne, déjà en place)
    not  rcx                ; rcx = -1 (= 0xFFFFFFFFFFFFFFFF pour repne)
    repne scasb             ; décrémenter rcx jusqu'à trouver al=0
    not  rcx                ; rcx = nombre d'octets parcourus (y compris '\0')
    dec  rcx                ; retirer le '\0'
    mov  rax, rcx
    ret
```

Ou version manuelle plus lisible :

```nasm
strlen_simple:
    xor  rax, rax           ; rax = 0 (index)
.loop:
    cmp  byte [rdi + rax], 0
    je   .done
    inc  rax
    jmp  .loop
.done:
    ret
```

---

## 10.5 Implémentation de `strcpy`

```nasm
; strcpy(rdi = dst, rsi = src) — copie src dans dst
strcpy:
    cld
.loop:
    lodsb                   ; al = [rsi], rsi++
    stosb                   ; [rdi] = al, rdi++
    test al, al
    jnz  .loop              ; continuer jusqu'à l'octet nul
    ret
```

---

## 10.6 Implémentation de `strcat`

```nasm
; strcat(rdi = dst, rsi = src) — concatène src à la fin de dst
strcat:
    cld
    ; 1. Trouver la fin de dst
.find_end:
    cmp  byte [rdi], 0
    je   .copy
    inc  rdi
    jmp  .find_end
    ; 2. Copier src (y compris le '\0' final)
.copy:
    lodsb
    stosb
    test al, al
    jnz  .copy
    ret
```

---

## 10.7 Implémentation de `memset`

```nasm
; memset(rdi = dst, rsi = valeur, rdx = n)
memset:
    cld
    mov  al, sil            ; octet à répéter (byte de rsi)
    mov  rcx, rdx           ; nombre d'octets
    rep  stosb              ; [rdi+i] = al pour i=0..rcx-1
    ret
```

---

## 10.8 Implémentation de `memcpy`

```nasm
; memcpy(rdi = dst, rsi = src, rdx = n)
memcpy:
    cld
    mov  rcx, rdx
    rep  movsb              ; copier rcx octets de [rsi] vers [rdi]
    ret
```

Pour copier des quadwords (plus rapide sur les grandes zones) :

```nasm
memcpy_fast:
    cld
    mov  rcx, rdx
    shr  rcx, 3             ; rcx = n / 8 (nb de qwords)
    rep  movsq              ; copier par blocs de 8 octets
    mov  rcx, rdx
    and  rcx, 7             ; rcx = n % 8 (octets restants)
    rep  movsb
    ret
```

---

## 10.9 Comparaison de chaînes (`strcmp`)

```nasm
; strcmp(rdi = s1, rsi = s2)
; retourne rax : 0 si égal, <0 si s1 < s2, >0 si s1 > s2
strcmp:
    cld
.loop:
    lodsb                   ; al = [rsi], rsi++
    mov  dl, [rdi]
    inc  rdi
    cmp  al, dl
    jne  .differ
    test al, al
    jnz  .loop              ; continuer si pas '\0'
    xor  rax, rax           ; égaux
    ret
.differ:
    movzx rax, al
    movzx rdx, dl
    sub   rax, rdx          ; retourner s1[i] - s2[i]
    ret
```

---

## Résumé

| Besoin | Instruction(s) |
|--------|----------------|
| Longueur | `repne scasb` avec `al=0` |
| Copie | `rep movsb` (ou `movsq`) |
| Remplissage | `rep stosb` |
| Comparaison | `repe cmpsb` |
| Recherche d'octet | `repne scasb` |
| Chargement séquentiel | `lodsb` |

- `cld` en début de fonction pour assurer DF=0 (incrément automatique).
- `rep movsq` est plus efficace que `rep movsb` pour les grandes zones alignées.
