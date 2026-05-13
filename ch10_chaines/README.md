# Chapitre 10 — Chaînes de caractères

## Concepts abordés

- Représentation des chaînes (terminées par null ou avec longueur explicite)
- Calcul de longueur (`strlen`)
- Copie (`strcpy`), concaténation (`strcat`), comparaison (`strcmp`)
- Instructions de chaîne : `movs`, `scas`, `cmps`, `stos`, `lods`
- Préfixes de répétition : `rep`, `repe`, `repne`

## Représentation des chaînes

```nasm
; Terminée par null (style C)
msg db "Bonjour", 0

; Avec longueur explicite (style NASM)
msg     db "Bonjour"
msg_len equ $ - msg
```

## Instructions de chaîne (opèrent sur [rsi] → [rdi])

| Instruction | Action |
|-------------|--------|
| `movsb/w/d/q` | Copie un élément de `[rsi]` vers `[rdi]`, avance les pointeurs |
| `stosb/w/d/q` | Stocke `al/ax/eax/rax` dans `[rdi]`, avance `rdi` |
| `lodsb/w/d/q` | Charge `[rsi]` dans `al/ax/eax/rax`, avance `rsi` |
| `scasb/w/d/q` | Compare `al/ax/eax/rax` avec `[rdi]`, avance `rdi` |
| `cmpsb/w/d/q` | Compare `[rsi]` avec `[rdi]`, avance les deux pointeurs |

## Préfixes de répétition

```nasm
rep   movsb          ; répéter rcx fois
repe  cmpsb          ; répéter tant que égal et rcx > 0
repne scasb          ; répéter tant que non égal et rcx > 0
```

## Exemple : strlen rapide avec REPNE SCASB

```nasm
; rdi = adresse de la chaîne
mov rcx, -1             ; compteur max
xor al, al              ; chercher le null byte (0)
repne scasb             ; dec rcx tant que [rdi] != al
not rcx
dec rcx                 ; longueur dans rcx
```

## Exemple : memset avec REP STOSB

```nasm
; Remplir tampon (64 octets) avec 0
mov rdi, tampon
mov rcx, 64
xor al, al
rep stosb
```
