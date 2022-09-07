output.txt: input.c a.out
	./a.out<input.c>output.txt

a.out:	lex.yy.c main.c def.h
	cc lex.yy.c main.c -lfl

lex.yy.c: lex_tool.l def.h
	flex lex_tool.l
 
clean:
	rm a.out lex.yy.c output.txt
