UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    RM = rm -f
else
    RM = del /f
endif

all : exec
avl.o: avl.c avl.h
	gcc -c avl.c -o avl.o
main.o: main.c avl.h
	gcc -c main.c -o main.o
exec: main.o avl.o
	gcc main.o avl.o -o exec
clean:
	$(RM) *.o exec
