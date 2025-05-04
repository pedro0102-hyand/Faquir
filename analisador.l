%{
#include "analisador.tab.h"
%}

%%

[ \t\n]+              ; // Ignora espaços, tabulações e quebras de linha

"int"                { return INT; }
"float"              { return FLOAT; }
"char"               { return CHAR; }
"bool"               { return BOOL; }
"true"               { return TRUE; }
"false"              { return FALSE; }

"=="                 { return TK_EQ; }
"!="                 { return TK_NE; }
"<="                 { return TK_LE; }
">="                 { return TK_GE; }
"<"                  { return TK_LT; }
">"                  { return TK_GT; }

"&&"                 { return TK_AND; }     
"||"                 { return TK_OR; }      
"!"                  { return TK_NOT; }     

[0-9]+\.[0-9]+        {
    yylval.fval = atof(yytext);
    return REAL;
}

[0-9]+               {
    yylval.valor = atoi(yytext);
    return NUM;
}

"'"[a-zA-Z0-9]"'"    {
    yylval.letra = yytext[1];
    return CARACTERE;
}

[A-Za-z]             {
    yylval.letra = yytext[0];
    return ID;
}

"("                  { return '('; }
")"                  { return ')'; }
";"                  { return ';'; }
"="                  { return '='; }

"+"                  { return TK_SOMA; }
"-"                  { return TK_SUB; }
"*"                  { return TK_MUL; }
"/"                  { return TK_DIV; }

.                    ; // Ignora qualquer outro caractere não reconhecido

%%

int yywrap() { return 1; }



























