#ifndef TRANSLATOR_H
#define TRANSLAOR_H

#include <iostream>
#include <vector>
#include <map>
#include <list>
using namespace std;

class Symbol;
class SymbolType;
class SymbolTable;
class Quad;
class Array;
class Expression;
class Statement;

extern vector<Quad *> quadArray;                
extern SymbolTable *currentSTable, *globalSTable; 
extern Symbol *currentSymbol;                   
extern SymbolType::typeEnum currentType;        
extern int stCount, tempCount;          

extern int yyparse();


class SymbolType{
    public:
        enum typeEnum {VOID, CHAR, INT, FLOAT, POINTER, FUNCTION, ARRAY, BLOCK} type;
        int width;   
        SymbolType *arrayType;  

        SymbolType(typeEnum _type, SymbolType * _arrayType = NULL, int _width= 1); 
        string TypetoString();
        int SizeOfType();
};

class SymbolTable{
    public:
        string name;                 
        map<string, Symbol> symbols; 
        SymbolTable *parent;         

        SymbolTable(string = "NULL", SymbolTable * = NULL); 
        Symbol *lookup(string);                             
        void update();                                      
        void print();                                       
};

class Symbol{
    public:
        string name;              
        int size, offset;         
        SymbolType *type;         
        SymbolTable *nestedTable; 
        string Value;      
        bool isFunction;          

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
        Symbol *loc; 
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

        void ConverttoInt();  
        void ConverttoBool(); 
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
list<int> merge(list<int> &list1, list<int> &list2); 

int nextInstruction();                              
Symbol *gentemp(SymbolType::typeEnum, string = ""); 
void changeTable(SymbolTable *);                    // changes the current symbol table to the given one

bool typeCheck(Symbol *&s1, Symbol *&s2);       //same type symbols


string ConverttoString(int i);   
string ConverttoString(float f); 
string ConverttoString(char c);  


#endif