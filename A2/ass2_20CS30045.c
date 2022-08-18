// this program contains definitions for printInt, readInt, printFlt, readFlt, printStr
#include "myl.h"
#define BUFFER 20
#define PRECISION 6

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

    if(len <= 0)
        return ERR;

    int neg = 0, idx = 0;
    if(inputBuff[0] == '-'){
        neg = 1; // set flag to be true
        idx++; // begin traversing from index 1
    }
    else if(inputBuff[0] == '+')
        idx++;

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
        if(n == __INT32_MAX__+1){ // if n is INT_MIN
            buff[i++] = '-';
            buff[i++] = '8';
            n /= 10;
            n = -n;
        }
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
    char inputBuff[BUFFER];
    int len;
    __asm__ __volatile__ (
        "movl $0, %%eax \n\t" 
        "movq $0, %%rdi \n\t"
        "syscall \n\t"
        : "=a"(len)
        :"S"(inputBuff), "d"(BUFFER)
    );

    if(len <= 0)
        return ERR;
    
    int neg = 0, idx = 0;
    float n1 = 0;
    if(inputBuff[0] == '-'){
        neg = 1; // set flag to true
        idx++; // begin traversing from index 1
    }
    else if(inputBuff[0] == '+')
        idx++; // begin traversing from index 1

    while(idx < len && inputBuff[idx] != '\n' && 
            inputBuff[idx] != '.'){
        if(inputBuff[idx] < '0' || inputBuff[idx] > '9')
            return ERR;
        int dig = (int)(inputBuff[idx] - '0');
        n1 *= 10;
        n1 += dig;
        idx++;
    }
    // if there are digits after the decimal point, then join them to n
    if(idx < len && inputBuff[idx] == '.'){
        idx++;
        float shift = 10.F;
        while(idx < len && inputBuff[idx] != '\n'){
            if(inputBuff[idx] < '0' || inputBuff[idx] > '9')
                return ERR;
            float dig = (float)(inputBuff[idx] - '0');
            dig /= shift;
            n1 += dig;
            shift *= 10;
            idx++;
        }
    }
    n1 = (neg == 1)? -n1 : n1;
    *n = n1;

    return OK;
}

int printFlt(float n){
    char buff[BUFFER];
    int len = 0;
    if(n < 0){
        buff[len++] = '-';
        n = -n;
    }

    // find the integral part of the float number
    long integral_part = (long)n;
    n -= integral_part;

    if(integral_part > __INT32_MAX__ || 
        integral_part < (__INT32_MAX__+1)) //integral part less than INT_MIN
        return ERR;

    // load the integral part into character array
    while(integral_part != 0){
        buff[len++] = (char)('0' + (integral_part % 10));
        integral_part /= 10;
    }
    if(len == 0 || buff[len-1] == '-')
        buff[len++] = '0';
    
    // reverse the the stored number
    int leftPtr = 0, rightPtr = len-1;
    if(buff[0] == '-'){
        leftPtr = 1; // go to index=1 if negative number
    }
    while(leftPtr < rightPtr){
        char temp = buff[leftPtr];
        buff[leftPtr++] = buff[rightPtr];
        buff[rightPtr--] = temp;
    }

    buff[len++] = '.';

    // get the fractional part
    for(int i=0; i<PRECISION; i++)
        n *= 10;
    long fractional_part = (long)n;

    // store fractional part in character array
    for(int i=0; i<PRECISION; i++){
        buff[len++] = (char)('0' + (fractional_part%10));
        fractional_part /= 10;
    }
    leftPtr = len - PRECISION;
    rightPtr = len-1;
    while(leftPtr < rightPtr){
        char temp = buff[leftPtr];
        buff[leftPtr++] = buff[rightPtr];
        buff[rightPtr--] = temp;
    }
    
    __asm__ __volatile__(
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        : "S"(buff), "d"(len)
    );
    
    return len;
}