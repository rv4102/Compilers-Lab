// this program contains definitions for printInt, readInt, printFlt, readFlt, printStr
#include "myl.h"

int printStr(char *string){
    // find length of string
    int len=0;
    while(string[len++] != '\0');

    __asm__ __volatile__(
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(string), "d"(len)
    ); // $4: write, $1: on stdin
}

int printInt(int n){
    
}

int readInt(int *n){

}

int readFlt(float *n){

}

int printFlt(float n){
    
}