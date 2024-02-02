%{
#include<stdio.h>
#include<string.h>
#include "s.tab.h"
int ligne=1;
int col=0;
extern YYSTYPE yylval;
%}
%option noyywrap
chiffre	[0-9]
lettre [a-zA-Z]
IDF {lettre}(({lettre}|_|{chiffre})*({lettre}|{chiffre})+)*
PEntier 0|[+|-]?[1-9]{chiffre}*
PReel [+|-]?(0[.]{chiffre}+|[1-9]{chiffre}*[.]{chiffre}+) 
commentaireSimple [/]{2}.*
commentaireSautDeLigne  "/""*"(.|\n])*"*""/"
comp_expression ">"|"<"|"=="|">="|"<="|"!="|"|"|"+"|"-"|"/"|"&"|"!"|"*"
%%
Program {return mc_program; col=col+yyleng;}
PDEC {return mc_pdec;col=col+yyleng;}
PINST {return mc_pinst;col=col+yyleng;}
Begin {return mc_begin;col=col+yyleng;}
End {return mc_end;col=col+yyleng;}
@define { return mc_define; col=col+yyleng;}
Pint { return mc_pint ;col=col+yyleng;}
Pfloat { return mc_pfloat ;col=col+yyleng;}
ENDFOR { return mc_endfor ;col=col+yyleng;}
ENDIF { return mc_endif ;col=col+yyleng;}
FOR { return mc_for ;col=col+yyleng;}
WHILE { return mc_while ;col=col+yyleng;}
IF { return mc_if ;col=col+yyleng;}
DO { return mc_do ;col=col+yyleng;}
ELSE { return mc_else ;col=col+yyleng;}
{IDF} {if(yyleng<=12){yylval.str=strdup(yytext);return IDF;col=col+yyleng;} else printf("IDF trop long!\n");}
{PEntier} {if((atoi(yytext) < 32767) & (atoi(yytext) > -32768)){return PEntier ;col=col+yyleng;} else printf("Valeur depassée!");}
{PReel} {atof(yytext) ; return PReel ;}
[():;] {return yytext[0];col=col+yyleng;}
"<--" { return aff ;col=col+yyleng;}
"//" {col=col+yyleng;}
"/*" {col=col+yyleng;}
"*/" {col=col+yyleng;}
[ \t] {col=col+yyleng;}
\n {ligne++; col=0;}
{comp_expression} {
	col = col + yyleng;
	if(strcmp(yytext,"|")==0)
		return ou;
	else if(strcmp(yytext,"&")==0)
			return '&';
		else if(strcmp(yytext,"!")==0)
				return '!';
			else if(strcmp(yytext,"<")==0)
					return '<';
				 if(strcmp(yytext,"<=")==0)
					return infegal;
				 if(strcmp(yytext,">")==0)
					return '>';
				 if(strcmp(yytext,">=")==0)
					return supegal;
				 if(strcmp(yytext,"==")==0)
					return egal;
				 if(strcmp(yytext,"!=")==0)
					return diff;
				else if(strcmp(yytext,"+")==0)
						return add;
					 if(strcmp(yytext,"-")==0)
						return sous;
					else if(strcmp(yytext,"*")==0)
							return mult;
						 if(strcmp(yytext,"/")==0)
							return '/';
}
{commentaireSimple} {col=col+yyleng;}
{commentaireSautDeLigne} {ligne++; col=0;} 
. printf("\n Erreur lexical à la ligne %d et colonne %d sur l entite %s\n", ligne, col, yytext);
%%


