all:
	bison -d analisador.y
	flex analisador.l
	g++ analisador.tab.c lex.yy.c -o compilador

clean:
	rm -f analisador.tab.c analisador.tab.h lex.yy.c compilador