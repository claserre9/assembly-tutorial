NASM     := nasm
NASMFLAGS := -f elf64 -g -F dwarf
LD       := ld
LDFLAGS  :=
CC       := gcc
CFLAGS   := -no-pie -nostartfiles

PROG_DIR := prog
CHAPTERS := \
    ch01_hello_world \
    ch02_registres \
    ch03_constantes \
    ch03_donnees \
    ch04_arithmetique \
    ch05_entrees_sorties \
    ch06_conditions \
    ch07_boucles \
    ch08_procedures \
    ch09_tableaux \
    ch10_chaines \
    ch11_adressage \
    ch12_pile \
    ch13_fichiers \
    ch14_macros \
    ch15_flottants \
    ch16_structures \
    ch17_listes \
    ch18_simd \
    ch19_multifichiers

.PHONY: all clean $(CHAPTERS)

all: $(PROG_DIR) $(CHAPTERS)

$(PROG_DIR):
	mkdir -p $(PROG_DIR)

ch01_hello_world: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch01_introduction/hello_world.asm -o /tmp/ch01.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch01_hello_world /tmp/ch01.o

ch02_registres: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch02_registres/registres.asm -o /tmp/ch02.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch02_registres /tmp/ch02.o

ch03_constantes: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch03_constantes_donnees/constantes.asm -o /tmp/ch03a.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch03_constantes /tmp/ch03a.o

ch03_donnees: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch03_constantes_donnees/donnees.asm -o /tmp/ch03b.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch03_donnees /tmp/ch03b.o

ch04_arithmetique: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch04_arithmetique/arithmetique.asm -o /tmp/ch04.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch04_arithmetique /tmp/ch04.o

ch05_entrees_sorties: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch05_entrees_sorties/entrees_sorties.asm -o /tmp/ch05.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch05_entrees_sorties /tmp/ch05.o

ch06_conditions: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch06_conditions_sauts/conditions.asm -o /tmp/ch06.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch06_conditions /tmp/ch06.o

ch07_boucles: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch07_boucles/boucles.asm -o /tmp/ch07.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch07_boucles /tmp/ch07.o

ch08_procedures: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch08_procedures/procedures.asm -o /tmp/ch08.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch08_procedures /tmp/ch08.o

ch09_tableaux: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch09_tableaux/tableaux.asm -o /tmp/ch09.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch09_tableaux /tmp/ch09.o

ch10_chaines: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch10_chaines/chaines.asm -o /tmp/ch10.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch10_chaines /tmp/ch10.o

ch11_adressage: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch11_modes_adressage/adressage.asm -o /tmp/ch11.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch11_adressage /tmp/ch11.o

ch12_pile: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch12_pile/pile.asm -o /tmp/ch12.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch12_pile /tmp/ch12.o

ch13_fichiers: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch13_fichiers/fichiers.asm -o /tmp/ch13.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch13_fichiers /tmp/ch13.o

ch14_macros: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch14_macros/macros.asm -o /tmp/ch14.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch14_macros /tmp/ch14.o

ch15_flottants: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch15_virgule_flottante/flottants.asm -o /tmp/ch15.o
	$(CC) $(CFLAGS) -o $(PROG_DIR)/ch15_flottants /tmp/ch15.o -lm

ch16_structures: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch16_structures/structures.asm -o /tmp/ch16.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch16_structures /tmp/ch16.o

ch17_listes: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch17_listes_chainees/listes.asm -o /tmp/ch17.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch17_listes /tmp/ch17.o

ch18_simd: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch18_simd/simd.asm -o /tmp/ch18.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch18_simd /tmp/ch18.o

ch19_multifichiers: $(PROG_DIR)
	$(NASM) $(NASMFLAGS) ch19_multifichiers/utils.asm -o /tmp/ch19_utils.o
	$(NASM) $(NASMFLAGS) ch19_multifichiers/main.asm -o /tmp/ch19_main.o
	$(LD) $(LDFLAGS) -o $(PROG_DIR)/ch19_multifichiers /tmp/ch19_main.o /tmp/ch19_utils.o

clean:
	rm -rf $(PROG_DIR) /tmp/ch*.o
