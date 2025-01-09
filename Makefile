# store all .asm files (except functions.asm)
ASM_FILES := $(filter-out functions.asm, $(wildcard *.asm))

# extract base names (ignore extension)
TARGETS := $(basename $(ASM_FILES))

all: $(TARGETS)

$(TARGETS): %: %.o
	ld $< -o $@

%.o: %.asm
	nasm -g -f elf64 $< -o $@

clean:
	rm -f $(TARGETS) *.o
