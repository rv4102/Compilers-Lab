#include "myl.h"

int main(){
    printStr("------ 1. Tests for printStr ------\n");
    char *str_tc[4] = {"This program implements printf for string, int & float types.",
                            "It uses assembler directives to load string buffers in registers and print to screen.",
                            "\n",
                            ""};
    for(int i=0; i<4; i++){
        printStr(str_tc[i]);
        printStr("\n");
    }
    printStr("\n");

    printStr("------ 2. Tests for printInt and readInt ------ \n");
    printStr("Printing from integer array:\n");
    int int_tc[5] = {12351, 0, -32768, __INT32_MAX__, __INT32_MAX__+1};
    for(int i=0; i<5; i++){
        printInt(int_tc[i]);
        printStr("\n");
    }
    printStr("\n");
    printStr("Enter 5 numbers:\n");
    int int_inp;
    for(int i=1; i<=5; i++){
        if(readInt(&int_inp) == 0){
            printStr("Invalid input.\n");
            if(i != 5) printStr("Enter next number.\n");
        }
        else{
            printStr("Integer #");
            printInt(i);
            printStr(": ");
            printInt(int_inp);
            printStr("\n");
        }
    }
    printStr("\n");

    printStr("------ 3. Tests for printFlt and readFlt ------ \n");
    printStr("Printing from float array:\n");
    float float_tc[5] = {123.456, -0.463431, -69.233353, 32768.312412, -012.423};
    for(int i=0; i<5; i++){
        printFlt(float_tc[i]);
        printStr("\n");
    }
    printStr("\n");
    printStr("Enter 5 numbers:\n");
    float flt_inp;
    for(int i=1; i<=5; i++){
        if(readFlt(&flt_inp) == 0){
            printStr("Invalid input.\n");
            if(i != 5) printStr("Enter next number.\n");
        }
        else{
            printStr("Float #");
            printInt(i);
            printStr(": ");
            printFlt(flt_inp);
            printStr("\n");
        }
    }
    printStr("\n");
}