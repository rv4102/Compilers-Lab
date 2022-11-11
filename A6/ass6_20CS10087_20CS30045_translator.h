#ifndef _TRANSLATOR_H
#define _TRANSLATOR_H

#include <iostream>
#include <fstream>
#include <string>
#include <map>
#include <vector>
#include <list>
#include <functional>
#include <iomanip>
#include <stack>
#include <string.h>
using namespace std;

class SymbolType;
class SymbolTable;
class Symbol;
class Label;
class Quad;
class Expression;
class Array;
class Statement;
class ActivationRecord;

// Activation Record class that stores displacement of variables and total displacement from base address
class ActivationRecord
{
    public:
        map<string, int> displacement;
        int totalDisplacement;

        ActivationRecord();
};

class SymbolType
{
public:
    enum typeEnum
    {
        VOID,
        CHAR,
        INT,
        FLOAT,
        POINTER,
        FUNCTION,
        ARRAY,
        BLOCK
    } type;                // type of the symbol, scoped enum for safe comparisons
    int width;
    SymbolType *arrayType;

    SymbolType(typeEnum, SymbolType * = NULL, int = 1);
    int getSize();
    string toString();
};

class SymbolTable
{
public:
    string name;                        
    map<string, Symbol> symbols;
    SymbolTable *parent;
    ActivationRecord *activationRecord;
    vector<string> parameters;

    SymbolTable(string = "NULL", SymbolTable * = NULL);
    Symbol *lookup(string);
    void print();
    void update();
};

class Symbol
{
public:
    string name;
    int size, offset;
    SymbolType *type;
    SymbolTable *nestedTable;
    string initialValue;
    enum Category
    {
        LOCAL,
        GLOBAL,
        PARAMETER,
        TEMPORARY,
        FUNCTION
    } category;

    Symbol(string, SymbolType::typeEnum = SymbolType::INT, string = "");
    Symbol *update(SymbolType *);
    Symbol *convert(SymbolType::typeEnum);
};

class Quad
{
public:
    string op, arg1, arg2, result;                   // parameters of the quad

    Quad(string, string, string = "=", string = "");
    Quad(string, int, string = "=", string = "");
    void print();
};

class Expression
{
public:
    Symbol *symbol;
    enum typeEnum
    {
        NONBOOLEAN,
        BOOLEAN
    } type;
    list<int> trueList, falseList, nextList;

    void toInt();
    void toBool();
};

class Array
{
public:
    Symbol *temp;
    enum typeEnum
    {
        OTHER,
        POINTER,
        ARRAY
    } type;
    Symbol *symbol;
    SymbolType *subArrayType;
};

class Statement
{
public:
    list<int> nextList;
};

// Emit functions for generating quads
void emit(string, string, string = "", string = "");
void emit(string, string, int, string = "");

// Backpatching functions
void backpatch(list<int>, int);
void finalBackpatch();
list<int> makeList(int);
list<int> merge(list<int>, list<int>);

// Other helper functions
int nextInstruction();
Symbol *gentemp(SymbolType::typeEnum, string = "");
void changeTable(SymbolTable *);

// Type checking and conversions
bool typeCheck(Symbol *&, Symbol *&); // checks if the two symbols have the same type

// Utility functions
string toString(int);
string toString(float);
string toString(char);

// Global variables
extern vector<Quad *> quadArray;
extern SymbolTable *currentTable, *globalTable;
extern Symbol *currentSymbol;
extern SymbolType::typeEnum currentType;
extern int tableCount, temporaryCount;
extern vector<string> stringLiterals;
extern FILE *yyin;
extern int yyparse();

#endif