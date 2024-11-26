EXE = hello
SOURCES = hello.asm
OBJS = hello.o

all: $(EXE)
	@echo $(EXE) build complete

hello.o: hello.asm
	nasm -g -f elf64 hello.asm -o hello.o

$(EXE): hello.o
	ld hello.o -o hello

clean:
	rm -f $(EXE) $(OBJS)
