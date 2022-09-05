%option noyywrap yylineno
%{
#include<iostream>
#include<fstream>
#include<string>
#include"Symbol.h"
#include"parser.h"
using std::ofstream;
using std::cout;
using std::string;
using std::endl;
ofstream fout("out.txt");
extern YYSTYPE yylval;
FILE * fp;
void fLog(string s){
    fout<<s<<endl;
}
%}

%%
[\t\v ] { }
\n {
    return NEWLINE;
}
\( {
    return LPAREN;
}
\) {
    return RPAREN;
}
\*\* {
    return POWER;
}
[*|/] {
    yylval.symbol=new Symbol(string(yytext));
    return MULOP;
}

pi {
    return PI;
}
e {
    return E;
}

[0-9]+ {
    yylval.val=std::stoi(yytext);
    return NUMBER;
}

sin|cos|tan|abs {
    yylval.symbol=new Symbol(string(yytext));
    return FUNCTION;
}




[\+|-] {
    yylval.symbol=new Symbol(string(yytext));
    return ADDOP;
}
%%

/*
int main(int argc,char * argv []){
    if(argc<=1){
        cout<<"Input file not given\n";
        return -1;
    }
    fp=fopen(argv[1],"r");
    yyin=fp;
    yylex();
    fout.close();
    fclose(yyin);
}
*/