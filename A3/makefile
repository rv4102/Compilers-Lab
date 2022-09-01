output.txt: input.txt a.out
	./a.out<input.txt>output.txt

a.out:	lex.yy.c main.c
	cc lex.yy.c main.c -lfl

lex.yy.c:	 lex_tool.l
	flex lex_tool.l
 
clean:
	rm a.out lex.yy.c output.txt
