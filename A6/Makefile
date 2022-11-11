parser.out: lex.yy.o y.tab.o ass6_20CS10087_20CS30045_translator.o ass6_20CS10087_20CS30045_target_translator.o
	g++ lex.yy.o y.tab.o ass6_20CS10087_20CS30045_translator.o ass6_20CS10087_20CS30045_target_translator.o -lfl -o parser.out

ass6_20CS10087_20CS30045_target_translator.o: ass6_20CS10087_20CS30045_target_translator.cxx ass6_20CS10087_20CS30045_translator.h
	g++ -c ass6_20CS10087_20CS30045_target_translator.cxx

ass6_20CS10087_20CS30045_translator.o: ass6_20CS10087_20CS30045_translator.cxx ass6_20CS10087_20CS30045_translator.h
	g++ -c ass6_20CS10087_20CS30045_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

y.tab.o: y.tab.c
	g++ -c y.tab.c

lex.yy.c: ass6_20CS10087_20CS30045.l y.tab.h ass6_20CS10087_20CS30045_translator.h
	flex ass6_20CS10087_20CS30045.l

y.tab.c y.tab.h: ass6_20CS10087_20CS30045.y
	bison -dty --report=all ass6_20CS10087_20CS30045.y

libass2_20CS30045.a: ass2_20CS30045.o
	ar -rcs libass2_20CS30045.a ass2_20CS30045.o

ass2_20CS30045.o: ass2_20CS30045.c myl.h
	gcc -c ass2_20CS30045.c

clean:
	rm libass2_20CS30045.a ass2_20CS30045.o parser.out ass6_20CS10087_20CS30045_translator.o ass6_20CS10087_20CS30045_target_translator.o lex.yy.* y.tab.* y.output test*

test: parser.out libass2_20CS30045.a
	@echo "Generating assembly files\n"
	./parser.out ass6_20CS10087_20CS30045_test1 > ass6_20CS10087_20CS30045_quads1.out
	./parser.out ass6_20CS10087_20CS30045_test2 > ass6_20CS10087_20CS30045_quads2.out
	./parser.out ass6_20CS10087_20CS30045_test3 > ass6_20CS10087_20CS30045_quads3.out
	./parser.out ass6_20CS10087_20CS30045_test4 > ass6_20CS10087_20CS30045_quads4.out
	./parser.out ass6_20CS10087_20CS30045_test5 > ass6_20CS10087_20CS30045_quads5.out
	./parser.out ass6_20CS10087_20CS30045_test6 > ass6_20CS10087_20CS30045_quads6.out
	./parser.out ass6_20CS10087_20CS30045_test7 > ass6_20CS10087_20CS30045_quads7.out
	@echo "Compiling assembly files\n"
	gcc ass6_20CS10087_20CS30045_test1.s -L. -lass2_20CS30045 -no-pie -o test1
	gcc ass6_20CS10087_20CS30045_test2.s -L. -lass2_20CS30045 -no-pie -o test2
	gcc ass6_20CS10087_20CS30045_test3.s -L. -lass2_20CS30045 -no-pie -o test3
	gcc ass6_20CS10087_20CS30045_test4.s -L. -lass2_20CS30045 -no-pie -o test4
	gcc ass6_20CS10087_20CS30045_test5.s -L. -lass2_20CS30045 -no-pie -o test5
	gcc ass6_20CS10087_20CS30045_test6.s -L. -lass2_20CS30045 -no-pie -o test6
	gcc ass6_20CS10087_20CS30045_test7.s -L. -lass2_20CS30045 -no-pie -o test7
	@echo "Binaries generated. Run using ./test<num>\n\n"
	@echo "Running test1:\n"
	@./test1
	@echo "Running test2:\n"
	@./test2
	@echo "Running test3:\n"
	@./test3
	@echo "Running test4:\n"
	@./test4
	@echo "Running test5:\n"
	@./test5
	@echo "Running test6:\n"
	@./test6
	@echo "Running test7:\n"
	@./test7
