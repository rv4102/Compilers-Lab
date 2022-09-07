output.txt: ass3_20CS30045_20CS10087_test.c a.out
	./a.out < ass3_20CS30045_20CS10087_test.c > output.txt

a.out:	lex.yy.c ass3_20CS30045_20CS10087.c def.h
	cc lex.yy.c ass3_20CS30045_20CS10087.c -lfl

lex.yy.c: ass3_20CS30045_20CS10087.l def.h
	flex ass3_20CS30045_20CS10087.l
 
clean:
	rm a.out lex.yy.c output.txt
