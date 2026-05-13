# Solutions — Chapitre 19 : Multi-fichiers

## Solution 1 — Module mathématique

**math_utils.asm** :
```nasm
section .text
global puissance, est_premier, pgcd

; rdi=base, rsi=exposant → rax = base^exposant
puissance:
    push rbp
    mov  rbp, rsp
    mov  rax, 1
    test rsi, rsi
    jz   .fin
.boucle:
    imul rax, rdi
    dec  rsi
    jnz  .boucle
.fin:
    pop  rbp
    ret

; rdi=n → rax = 1 si premier, 0 sinon
est_premier:
    push rbp
    mov  rbp, rsp
    cmp  rdi, 2
    jl   .pas_premier
    je   .premier
    mov  rcx, 2
.boucle:
    mov  rax, rdi
    xor  rdx, rdx
    div  rcx
    test rdx, rdx
    jz   .pas_premier
    inc  rcx
    mov  rax, rcx
    imul rax, rax
    cmp  rax, rdi
    jle  .boucle
.premier:
    mov  rax, 1
    jmp  .fin
.pas_premier:
    xor  rax, rax
.fin:
    pop  rbp
    ret

; rdi=a, rsi=b → rax = PGCD (algorithme d'Euclide)
pgcd:
    push rbp
    mov  rbp, rsp
.boucle:
    test rsi, rsi
    jz   .fin
    mov  rax, rdi
    xor  rdx, rdx
    div  rsi
    mov  rdi, rsi
    mov  rsi, rdx
    jmp  .boucle
.fin:
    mov  rax, rdi
    pop  rbp
    ret
```

## Solution 2 — Makefile

```makefile
NASM = nasm
NASMFLAGS = -f elf64

all: programme

programme: main.o math_utils.o
	ld -o programme main.o math_utils.o

main.o: main.asm
	$(NASM) $(NASMFLAGS) main.asm -o main.o

math_utils.o: math_utils.asm
	$(NASM) $(NASMFLAGS) math_utils.asm -o math_utils.o

run: programme
	./programme

clean:
	rm -f *.o programme
```
