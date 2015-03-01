all:a

a: test.tab.c lex.yy.c
	gcc test.tab.c lex.yy.c -lm

test.tab.c: test.y
	bison -d test.y

lex.yy.c: test.l
	flex test.l
