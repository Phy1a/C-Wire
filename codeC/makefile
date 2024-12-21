UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    RM = rm -f
else
    RM = del /f
endif

all: exec
data.o: data.c data.h
	gcc -c data.c -o data.o
avl.o: avl.c avl.h
	gcc -c avl.c -o avl.o
main.o: main.c data.h avl.h
	gcc -c main.c -o main.o
exec: main.o data.o avl.o
	gcc main.o data.o avl.o -o exec

clean:
	$(RM) *.o exec
