#include<stdio.h>
#include "def.h"

extern char* yytext;
extern int yylex();

int main(){
    int token;
    while(token=yylex()){
        if(token==KEYWORD){
            printf("< keyword, %d, %s >\n", token, yytext);
        }
        else if(token==IDENTIFIERS){
            printf("< identifier, %d, %s >\n", token, yytext);
        }
        else if(token==INTEGER_CONSTANT){
            printf("< integer_constant, %d, %s >\n", token, yytext);
        }
        else if(token==FLOATING_CONSTANT){
            printf("< floating_constant, %d, %s >\n", token, yytext);
        }
        else if(token==CHARACTER_CONSTANT){
            printf("< character_constant, %d, %s >\n", token, yytext);
        }
        else if(token==STRING_LITERAL){
            printf("< string_literal, %d, %s >\n", token, yytext);
        }
        else if(token==PUNCTUATORS){
            printf("< punctuator, %d, %s >\n", token, yytext);
        }
        else if(token==SINGLE_COMMENT_LINE){
            printf("< single_line_comment, %d >\n", token);
        }
        else if(token==MULTI_COMMENT_LINE){
            printf("< multple_line_comment, %d >\n", token);
        }
        else{
            printf("< invalid token, %d, %s >\n", token, yytext);
        }
    }
}


