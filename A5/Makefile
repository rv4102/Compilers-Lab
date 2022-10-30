parser.out: lex.yy.o y.tab.o ass5_20CS10087_20CS30045_translator.o
	g++ lex.yy.o y.tab.o ass5_20CS10087_20CS30045_translator.o -lfl -o parser.out

ass5_20CS10087_20CS30045_translator.o: ass5_20CS10087_20CS30045_translator.cxx ass5_20CS10087_20CS30045_translator.h
	g++ -c ass5_20CS10087_20CS30045_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

y.tab.o: y.tab.c
	g++ -c y.tab.c

lex.yy.c: ass5_20CS10087_20CS30045.l y.tab.h ass5_20CS10087_20CS30045_translator.h
	flex ass5_20CS10087_20CS30045.l

y.tab.c y.tab.h: ass5_20CS10087_20CS30045.y ass5_20CS10087_20CS30045_translator.h
	bison -dty --report=all ass5_20CS10087_20CS30045.y

clean:
	rm parser.out ass5_20CS10087_20CS30045_translator.o lex.yy.* y.tab.* y.output

test: parser.out
	./parser.out < ass5_20CS10087_20CS30045_test1.c > ass5_20CS10087_20CS30045_quads1.out
	./parser.out < ass5_20CS10087_20CS30045_test2.c > ass5_20CS10087_20CS30045_quads2.out
	./parser.out < ass5_20CS10087_20CS30045_test3.c > ass5_20CS10087_20CS30045_quads3.out
	./parser.out < ass5_20CS10087_20CS30045_test4.c > ass5_20CS10087_20CS30045_quads4.out
	./parser.out < ass5_20CS10087_20CS30045_test5.c > ass5_20CS10087_20CS30045_quads5.out
	./parser.out < ass5_20CS10087_20CS30045_test6.c > ass5_20CS10087_20CS30045_quads6.out