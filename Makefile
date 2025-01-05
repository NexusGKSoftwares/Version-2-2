# Variables
CC = gcc
AS = as
CFLAGS = -Os -Wall -g
LDFLAGS = -lncurses
OBJ = main.o snake.o helpers.o

# Default target
all: snake_asm

# Linking the final executable
snake_asm: $(OBJ)
	$(CC) $(OBJ) -o $@ $(LDFLAGS) -no-pie

# Compile C source files
main.o: main.c
	$(CC) $(CFLAGS) -c main.c

helpers.o: helpers.c
	$(CC) $(CFLAGS) -c helpers.c

# Assemble the assembly source file
snake.o: snake.asm
	$(AS) -gstabs snake.asm -o snake.o

# Clean up generated files
clean:
	rm -f $(OBJ) snake_asm
