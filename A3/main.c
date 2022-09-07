#include <stdio.h>

#define KEYWORD 10
#define IDENTIFIERS 11
#define INTEGER_CONSTANT 12
#define FLOATING_CONSTANT 13
#define CHARACTER_CONSTANT 15
#define STRING_LITERAL 16
#define PUNCTUATORS 17
#define SINGLE_COMMENT_LINE 18
#define MULTI_COMMENT_LINE 19

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
            printf("< punctuators, %d, %s >\n", token, yytext);
        }
        else if(token==SINGLE_COMMENT_LINE){
            printf("< single_line_comment, %d >\n", token);
        }
        else if(token==MULTI_COMMENT_LINE){
            printf("< multple_line_comment, %d >\n", token);
        }
        else{
            printf("invalid token\n");
        }
    }
}


