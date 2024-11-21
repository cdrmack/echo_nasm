EXE = hello
SOURCES = hello.asm functions.asm
OBJS = $(addsuffix .o, $(basename $(notdir $(SOURCES))))

%.o:%.asm
	nasm -g -f elf64 -o $@ $<

all: $(EXE)
	@echo $(EXE) build complete

$(EXE): $(OBJS)
	ld -o $@ $^

clean:
	rm -f $(EXE) $(OBJS)
