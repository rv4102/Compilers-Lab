#include<stdio.h>
#include "def.h"

extern char* yytext;
extern int yylex();

int main(){
    int token;
    while(token=yylex()){
        if(token==KEYWORD){
            printf("< KEYWORD, %s >\n", yytext);
        }
        else if(token==IDENTIFIERS){
            printf("< IDENTIFIER, %s >\n", yytext);
        }
        else if(token==INTEGER_CONSTANT){
            printf("< INTEGER CONSTANT, %s >\n", yytext);
        }
        else if(token==FLOATING_CONSTANT){
            printf("< FLOATING POINT CONSTANT, %s >\n", yytext);
        }
        else if(token==CHARACTER_CONSTANT){
            printf("< CHARACTER CONSTANT, %s >\n", yytext);
        }
        else if(token==STRING_LITERAL){
            printf("< STRING LITERAL, %s >\n", yytext);
        }
        else if(token==PUNCTUATORS){
            printf("< PUNCTUATOR, %s >\n", yytext);
        }
        else if(token==SINGLE_COMMENT_LINE){
            printf("< SINGLE LINE COMMENT >\n");
        }
        else if(token==MULTI_COMMENT_LINE){
            printf("< MULTIPLE LINE COMMENT >\n");
        }
        else{
            printf("< INVALID TOKEN, %s >\n", yytext);
        }
    }
}