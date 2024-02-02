flex lexical.l
bison -d s.y
gcc lex.yy.c s.tab.c -o exemple

