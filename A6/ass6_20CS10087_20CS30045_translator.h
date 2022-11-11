#ifndef TRANSLATOR_H
#define TRANSLATOR_H

#include <iostream>
#include <vector>
#include <map>
#include <list>
#include <iomanip>
#include <functional>
#include <string>
#include <string.h>
using namespace std;

class Symbol;
class SymbolType;
class SymbolTable;
class Label;
class Quad;
class Array;
class Expression;
class Statement;
class ActivationRecord;    

extern int yyparse();

class ActivationRecord {
    public:
        map<string, int> displacement;
        int totalDisplacement;
        ActivationRecord();
};

class SymbolType{
    public:
        enum typeEnum {VOID, CHAR, INT, FLOAT, POINTER, FUNCTION, ARRAY, BLOCK} type;
        int width;   
        SymbolType *arrayType;  

        SymbolType(typeEnum _type, SymbolType * _arrayType = NULL, int _width= 1); 
        string toString();
        int getSize();
};

class SymbolTable{
    public:
        string name;
        map<string, Symbol> symbols;
        SymbolTable *parent;
        ActivationRecord *activationRecord;
        vector<string> parameters;
        
        SymbolTable(string = "NULL", SymbolTable * = NULL); // constructor
        Symbol *lookup(string); // returns the symbol with the given name, adds new entry if not found
        void print();
        void update();
};

class Symbol{
    public:
        string name;              
        int size, offset;         
        SymbolType *type;         
        SymbolTable *nestedTable; 
        string initialValue;      
        enum Category {LOCAL, GLOBAL, PARAMETER, TEMPORARY, FUNCTION} category;         

        Symbol(string _name, SymbolType::typeEnum _type = SymbolType::INT, string _value = ""); 
        Symbol *update(SymbolType * _type);                                        
        Symbol *convert(SymbolType::typeEnum _type);                               
};

class Quad{

    public:
        string op, arg1, arg2, result; 

        Quad(string _result, string _arg1, string _op = "=", string _arg2 = ""); 
        Quad(string _result, int _arg1, string _op = "=", string _arg2 = "");    
        Quad(string _result, float _arg1, string _op = "=", string _arg2 = "");
        void print();                                    
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

class Statement
{
    public:
        list<int> nextList; 
};

void emit(string _op, string _result, string _arg1 = "", string _arg2 = ""); 
void emit(string _op, string _result, int _arg1, string _arg2 = "");         
void emit(string _op, string _result, float _arg1, string _arg2 = "");         

void backpatch(list<int> _list, int add);       
list<int> makeList(int i);              
list<int> merge(list<int>, list<int>); 

int nextInstruction();                              
Symbol *gentemp(SymbolType::typeEnum, string = ""); 
void changeTable(SymbolTable *);                    // changes the current symbol table to the given one

bool typeCheck(Symbol *&s1, Symbol *&s2);       //same type symbols


string toString(int i);   
string toString(float f); 
string toString(char c);

extern vector<Quad *> quadArray;
extern SymbolTable *currentTable, *globalTable;
extern Symbol *currentSymbol;
extern SymbolType::typeEnum currentType;
extern int tableCount, temporaryCount;
extern vector<string> stringLiterals;
extern FILE *yyin;
extern int yyparse();

#endif