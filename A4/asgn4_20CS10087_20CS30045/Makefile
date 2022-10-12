output.txt: a.out asgn4_20CS10087_20CS30045_test.c
	./a.out < asgn4_20CS10087_20CS30045_test.c > output.txt

a.out: lex.yy.o y.tab.o asgn4_20CS10087_20CS30045.o
	cc lex.yy.o y.tab.o asgn4_20CS10087_20CS30045.o -lfl

lex.yy.o: lex.yy.c
	cc -c lex.yy.c

y.tab.o: y.tab.c
	cc -c y.tab.c

asgn4_20CS10087_20CS30045.o: asgn4_20CS10087_20CS30045.c
	cc -c asgn4_20CS10087_20CS30045.c

lex.yy.c: asgn4_20CS10087_20CS30045.l y.tab.h 
	flex asgn4_20CS10087_20CS30045.l

y.tab.c: asgn4_20CS10087_20CS30045.y
	bison -dty asgn4_20CS10087_20CS30045.y

y.tab.h: asgn4_20CS10087_20CS30045.y
	bison -dty asgn4_20CS10087_20CS30045.y

asgn4_20CS10087_20CS30045.c:
	touch asgn4_20CS10087_20CS30045.c

clean:
	rm output.txt a.out lex.yy.* y.tab.* asgn4_20CS10087_20CS30045.o