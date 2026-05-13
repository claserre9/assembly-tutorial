# Solutions — Chapitre 14 : Macros

## Solution 1 — sys_exit

```nasm
%macro sys_exit 1
    mov rax, 60
    mov rdi, %1
    syscall
%endmacro

; Utilisation
sys_exit 0
sys_exit 1
```

## Solution 2 — print_msg

```nasm
%macro print_msg 1
    jmp %%apres_data
%%msg_data: db %1
%%msg_len equ $ - %%msg_data
%%apres_data:
    mov rax, 1
    mov rdi, 1
    mov rsi, %%msg_data
    mov rdx, %%msg_len
    syscall
%endmacro

; Utilisation
print_msg "Bonjour!", 10
print_msg "Au revoir!", 10
```

## Solution 3 — Macro de boucle

```nasm
%macro repeter 2
    mov rcx, %1
%%boucle:
    %2              ; NASM ne supporte pas les blocs inline
    loop %%boucle
%endmacro

; Alternative : appeler une procédure
%macro repeter_proc 2
    mov rcx, %1
%%boucle:
    call %2
    loop %%boucle
%endmacro
```

## Solution 4 — Compilation conditionnelle

```nasm
%ifdef DEBUG
%macro debug_print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro
%else
%macro debug_print 2
    ; macro vide en mode release
%endmacro
%endif

; Compiler avec : nasm -DDEBUG -f elf64 ...
```
