#include "myl.h"
#define NEWLINE "\n"

int main(){
    printStr("------ 1. Tests for printStr ------\n");
    char str_tc[4] = {"This program implements printf for string, int & float types.",
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
    int int_tc[5] = {12351, 0, -1241, -32768, 32767};
    for(int i=0; i<5; i++){
        printInt(int_tc[i]);
        printStr("\n");
    }
    printStr("\n");
    printStr("Enter 5 numbers:\n");
    int inputs[5];
    for(int i=0; i<5; i++){
        readInt(&inputs[i]);
    }
    printStr("Printing from inputs:\n");
    for(int i=0; i<5; i++){
        printInt(inputs[i]);
        printStr("\n");
    }

    printStr("------ 3. Tests for printFlt and readFlt ------ \n");
    printStr("Printing from float array:\n");
    int float_tc[5] = {123.456, -0.463431, -69.233353}
}