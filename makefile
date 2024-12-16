all: exec
data.o: data.c data.h
	gcc -c data.c -o data.o
avl.o: avl.c avl.h
	gcc -c avl.c -o avl.o
map.o: src/lib/map.c src/include/map.h
	gcc -c src/lib/map.c -o map.o
game.o: src/lib/game.c src/include/game.h
	gcc -c src/lib/game.c -o game.o
main.o: main.c data.h avl.h
	gcc -c main.c -o main.o
exec: main.o data.o avl.o
	gcc main.o data.o avl.o -o exec

clean:
	rm main.o data.o avl.o
	rm exec