%{
#include<stdio.h>
#include <stdlib.h>
#include "routine.h"
extern int ligne;
extern int col;
int yyparse();
int yylex();
int yyerror(char *s);
int typeidf;
char* sauvOP;
int t;
int a;
int c;
%}

%union {
int num1;
float num2;
char* str;
struct {
float v;
int type;
}valexp;
int xexpcomp;
float ycst;
} 
%start S
%token mc_program mc_pdec mc_define mc_pinst mc_begin mc_for mc_while mc_endfor mc_do mc_if mc_else mc_endif mc_pint mc_pfloat mc_end
%token add sous aff diff mult infegal supegal egal ou '/' '<' '>' '!' '&' ':' ';' '(' ')' 
%token <num1> PEntier 
%token <num2> PReel 
%token <str> IDF
%type <valexp> expar operande
%type <xexpcomp> expcomp
%type <ycst> Cst
%left ou 
%left '&' 
%left '!'
%left '<' '>' infegal supegal egal diff
%left add sous
%left mult '/'

%%
S :  INTRO mc_pdec DEC mc_pinst mc_begin INST mc_end {printf("programme syntaxiquement correct\n"); afficher(); YYACCEPT;}
;
INTRO : mc_program IDF {printf("Debut du programme\n");}
;

DEC : DecVar DEC | DecCst DEC|DecVar| DecCst
;
DecVar : ListeIDF ':' Type';'  {inserertype(typeidf);}                      
;
DecCst : mc_define Type IDF aff Cst ';' {if(declaration($3) == 0) inserer($3,typeidf,1,$5); else {printf("Erreur semantique! Deja declare! a ligne %d a la colonne %d \n", ligne, col);}}    
;
Cst : PEntier {t = 0;}
    | PReel   {t = 1;}
;
ListeIDF : IDF ou ListeIDF              {if(declaration($1) == 0) inserer($1,-1,0,0); else {printf("Erreur semantique! Deja declare! a ligne %d a la colonne %d \n", ligne, col);}}
         | IDF                          {if(declaration($1) == 0) inserer($1,-1,0,0); else {printf("Erreur semantique! Deja declare! a ligne %d a la colonne %d \n", ligne, col);}}          
;
Type : mc_pint   {typeidf = 0;}
     | mc_pfloat {typeidf = 1;}
;
INST :  INS INST | INS
;
INS : Affect | Boucle | If    
;
operande : Cst {$$.v = $1; $$.type=t;}
         | IDF {if(declaration($1) == 0) {printf("Erreur semantique! entite non declaree! a ligne %d a la colonne %d \n", ligne, col);}
         $$.v=retourneval($1); $$.type=typeidf;}

;
operation : add  {strcpy(sauvOP,"+");}
          | sous {strcpy(sauvOP,"-");}
          | mult {strcpy(sauvOP,"*");}
          | '/'  {strcpy(sauvOP,"/");}
;
expar : operande operation operande     {if(CompatibleType($1.type,$3.type)==1){
                                        $$.type=$1.type;
                                        if(strcmp(sauvOP, "+") == 0) $$.v = $1.v + $3.v;
                                        if(strcmp(sauvOP, "-") == 0) $$.v = $1.v - $3.v;
                                        if(strcmp(sauvOP, "*") == 0) $$.v = $1.v * $3.v;
                                        if(strcmp(sauvOP, "/") == 0) {if($3.v != 0) $$.v = $1.v / $3.v; else {printf("Erreur semantique! Division par 0 impossible! a ligne %d a la colonne %d \n", ligne, col);}}}
                                       else {printf("Erreur semantique! Incompatibilité de Type! a ligne %d a la colonne %d \n", ligne, col);}}
       | operande operation expar       {if(CompatibleType($1.type,$3.type)==1){
                                        $$.type=$1.type;
                                        if(strcmp(sauvOP, "+") == 0) $$.v = $1.v + $3.v;
                                        if(strcmp(sauvOP, "-") == 0) $$.v = $1.v - $3.v;
                                        if(strcmp(sauvOP, "*") == 0) $$.v = $1.v * $3.v;
                                        if(strcmp(sauvOP, "/") == 0) {if($3.v != 0) $$.v = $1.v / $3.v; else {printf("Erreur semantique! Division par 0 impossible! a ligne %d a la colonne %d \n", ligne, col);}}}
                                       else {printf("Erreur semantique! Incompatibilité de Type! a ligne %d a la colonne %d \n", ligne, col);}}
;
                                
Affect : IDF aff expar ';'              {if(declaration($1) == 0) {printf("Erreur semantique! Entite non declaree! a ligne %d a la colonne %d \n", ligne, col);}
                                         if(CompatibleType(retournetype($1), $3.type) == 0) {printf("Erreur semantique! Incompatibilite des types a ligne %d a la colonne %d \n", ligne, col);}
                                         if (ModifCst($1)==0) {printf("Erreur semantique! Modification d'une constante a ligne %d a la colonne %d \n", ligne, col);}
                                         insererval($1,$3.v); }       
       | IDF aff operande ';'            {if(declaration($1) == 0) {printf("Erreur semantique! Entite non declaree! a ligne %d a la colonne %d \n", ligne, col);}                
                                        if(CompatibleType(retournetype($1), $3.type) == 0) {printf("Erreur semantique! Incompatibilite des types a ligne %d a la colonne %d \n", ligne, col);}
                                         if (ModifCst($1)==0) {printf("Erreur semantique! Modification d'une constante a ligne %d a la colonne %d \n", ligne, col);}
                                         insererval($1,$3.v); }                                       
;  
Boucle :  mc_for IDF aff Cst mc_while Cst mc_do INST mc_endfor {if(declaration($2) == 0) {printf("Erreur semantique! Entite non declaree! a ligne %d a la colonne %d \n", ligne, col);}                           if(CompatibleType(retournetype($2), t) == 0) {printf("Erreur semantique! Incompatibilite des types a ligne %d a la colonne %d \n", ligne, col);}}
;
If :  mc_do INST ':' mc_if '(' expcond ')' mc_else INST mc_endif  {if(a==0) YYACCEPT;}
    | mc_do INST ':' mc_if '(' expcond ')' mc_endif               {if(a==0) YYACCEPT;}
;
expcomp : expar '<' expar     {c=1; $$=cond($1.v,c,$3.v); }
        | expar '>' expar     {c=2; $$=cond($1.v,c,$3.v); }     
        | expar egal expar    {c=3; $$=cond($1.v,c,$3.v); }
        | expar diff expar    {c=4; $$=cond($1.v,c,$3.v); }
        | expar supegal expar {c=5; $$=cond($1.v,c,$3.v); }
        | expar infegal expar {c=6; $$=cond($1.v,c,$3.v); }
;

expcond: expcomp '&' expcomp {if (($1 == 1) && ($3==1 )) a=1;}  
       | expcomp ou expcomp  {if (($1 == 1) || ($3==1)) a=1;}
       | '!' expcomp         {if  ($2 != 1) a=1;}
       | expcomp             {if  ($1 == 1) a=1;}
;
%%
int yyerror(char* msg)
{printf("%s ligne %d et colonne %d", msg, ligne, col);
return 0;
}
int main()  {    
yyparse();  
return 0;  
} 




