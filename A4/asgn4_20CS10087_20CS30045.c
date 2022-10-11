#include <stdio.h>
extern int yyparse();
int main(){
    printf("............. Starting the parsing process .............\n");
    yyparse();
    return 0;
}