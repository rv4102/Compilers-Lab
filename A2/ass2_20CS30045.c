// this program contains definitions for printInt, readInt, printFlt, readFlt, printStr
#include "myl.h"
#define BUFFER 20

int printStr(char *string){
    // find length of string
    int len=0;
    while(string[len] != '\0'){
        len++;
    }

    __asm__ __volatile__(
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(string), "d"(len)
    );

    return len;
}

int readInt(int *n){
    char inputBuff[BUFFER]; // input buffer
    int len;
    __asm__ __volatile__ (
        "movl $0, %%eax \n\t" 
        "movq $0, %%rdi \n\t"
        "syscall \n\t"
        : "=a"(len)
        :"S"(inputBuff), "d"(BUFFER)
    );

    if(len < 0)
        return ERR;

    int neg = 0, idx = 0;
    if(inputBuff[0] == '-'){
        neg = 1; // set flag to be true
        idx++; // begin traversing from index 1
    }
    else if(inputBuff[0] == '+'){
        idx++;
    }

    long n1 = 0;
    while(idx < len && inputBuff[idx] != '\n'){
        if(inputBuff[idx] < '0' || inputBuff[idx] > '9')
            return ERR;
        int dig = (int)(inputBuff[idx] - '0');
        n1 *= 10;
        n1 += dig;

        idx++;
    }
    n1 = (neg == 1)? -n1 : n1;
    if(n1 > __INT32_MAX__ || n1 < (__INT32_MAX__+1)){
        return ERR;
    }

    *n = (int)n1;
    return OK;
}

int printInt(int n){
    char buff[BUFFER];
    int i=0, leftPtr, rightPtr;

    if(n == 0)
        buff[i++] = '0';
    else{
        if(n < 0){
            buff[i++] = '-';
            n = -n;
        }
        // extracts characters one at a time and stores in reverse
        while(n != 0){
            int dig = n%10;
            buff[i++] = (char)('0' + dig);
            n /= 10;
        }

        // reverse the array to get original number
        if(buff[0] == '-')
            leftPtr = 1;
        else
            leftPtr = 0;
        rightPtr = i-1;
        while(leftPtr < rightPtr){
            char temp = buff[leftPtr];
            buff[leftPtr++] = buff[rightPtr];
            buff[rightPtr--] = temp;
        }
    }
    buff[i] = '\0';

    __asm__ __volatile__(
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buff), "d"(i)
    );    

    // return length of characters printed
    return i;
}

int readFlt(float *n){

}

int printFlt(float n){
    
}