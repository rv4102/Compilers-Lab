assign2: main.o libass2_20CS30045.a
		cc main.o -L. -lass2_20CS30045 -o assign2

main.o: main.c myl.h
		cc -Wall -c main.c
	
libass2_20CS30045.a: ass2_20CS30045.o
		ar -rcs libass2_20CS30045.a ass2_20CS30045.o

ass2_20CS30045.o: ass2_20CS30045.c myl.h
		cc -Wall -c ass2_20CS30045.c

clean:
		rm ass2 main.o libass2_20CS30045.a ass2_20CS30045.o