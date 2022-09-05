%{
#include<iostream>
#include<cstdio>
#include<fstream>
#include<cmath>
#include"Symbol.h"
using std::cout;
using std::endl;
using std::ofstream;
ofstream output("output.txt");
extern ofstream fout;
extern FILE * yyin;
extern int yylex();
void yyerror(const char * s){
    cout<<s<<endl;
}
%}

%union {
    double val;
    Symbol * symbol;
}

%token LPAREN RPAREN  PI E NEWLINE POWER
%token<symbol> ADDOP MULOP FUNCTION
%token<val> NUMBER
%type Start Expressions
%type<val>Expression Term Factor

%%
Start:Expressions {};
Expressions:Expression NEWLINE {
    output<<$1<<endl;
    cout<<$1<<endl;
} Expressions
           | Expression{
            output<<$1<<endl;
            cout<<$1<<endl;
           };
Expression:Term{
            $$=$1;
            }
          | Expression ADDOP Term{
            if($2->value=="+"){
                $$=$1+$3;
            }else{
                $$=$1-$3;
            }
            delete $2;
          };

Term: Factor{
    $$=$1;
}
    | Term MULOP Factor{
        if($2->value=="*"){
            $$=$1*$3;
        }else{
            $$=$1/$3;
        }
        delete $2;
    }
    | ADDOP Factor{
        if($1->value=="-"){
            $$=-1*$2;
        }else{
            $$=$2;
        }
        delete $1;
    };

Factor: NUMBER {
        $$=$1;
       }
      | PI {
        $$=3.1415;
      }
      | E{
        $$=2.71;
      }
      | LPAREN Expression RPAREN{
        $$=$2;
      }
      | FUNCTION LPAREN Expression RPAREN{
        if($1->value=="sin"){
            $$=sin($3);
        }else if($1->value=="cos"){
            $$=cos($3);
        }else if($1->value=="tan"){
            $$=tan($3);
        }
        else if($1->value=="abs"){
            $$=fabs($3);
        }
        delete $1;
      }
%%

int main(int argc,char * argv[]){
    if(argc<=1){
        cout<<"no input filename given"<<endl;
        exit(1);
    }
    FILE * fp;
	if((fp=fopen(argv[1],"r"))==NULL)
	{
		cout<<"Cannot Open Input File.\n"<<endl;
		exit(1);
	}
    yyin=fp;
    yyparse();
    fclose(yyin);
    fout.close();
    output.close();
}