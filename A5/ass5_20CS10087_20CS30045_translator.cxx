#include "ass5_20CS10087_20CS30045_translator.h"

vector<Quad *> quadArray;
SymbolTable *currentSTable, *globalSTable;
Symbol *currentSymbol;
SymbolType::typeEnum currentType;
int stCount, tempCount;

SymbolType :: SymbolType(typeEnum _type, SymbolType *_arrayType , int _width):type(_type), arrayType(_arrayType), width(_width){};

int SymbolType::SizeOfType(){
    if(type == CHAR) return 1;
    if(type == INT) return 4;
    if(type == VOID) return 0;
    if(type == FLOAT) return 8;
    if(type == POINTER) return 4;
    if(type == FUNCTION) return 0;
    if(type == ARRAY) return width * (arrayType->SizeOfType());
    if(type == BLOCK) return 0;
}