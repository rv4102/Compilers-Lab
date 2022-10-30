
#include "ass5_20CS10087_20CS30045_translator.h"

vector<Quad *> quadArray;
SymbolTable *currentTable, *globalTable;
Symbol *currentSymbol;
SymbolType::typeEnum currentType;
int tableCount, temporaryCount;

SymbolType :: SymbolType(typeEnum _type, SymbolType *_arrayType , int _width){
    this->type = _type;
    this->arrayType = _arrayType;
    this->width = _width;
};

int SymbolType::getSize(){
    if(type == CHAR) return 1;
    if(type == INT) return 4;
    if(type == VOID) return 0;
    if(type == FLOAT) return 8;
    if(type == POINTER) return 4;
    if(type == FUNCTION) return 0;
    if(type == ARRAY) return width * (arrayType->getSize());
    if(type == BLOCK) return 0;
}

string SymbolType::toString(){
    if(this->type == SymbolType::CHAR) return "char";
    if(this->type == SymbolType::INT) return "int";
    if(this->type == SymbolType::VOID) return "void";
    if (this->type == SymbolType::FLOAT) return "float";
    if (this->type == SymbolType::POINTER) return "pointer";
    if (this->type == SymbolType::FUNCTION) return "fucntion";
    if (this->type == SymbolType::ARRAY) return "array";
    if (this->type == SymbolType::BLOCK) return "block";
    if (this->type == SymbolType::FUNCTION) return "function";
}

SymbolTable::SymbolTable(string _name, SymbolTable *_parent): name(_name), parent(_parent){}

Symbol* SymbolTable::SymbolTable::lookup(string _name){
    auto sym = this->symbols.find(_name);
    if(sym != this->symbols.end()) return &sym->second;
    Symbol *par = NULL;
    if(this->parent != NULL) par = this->parent->lookup(_name);
    if(this == currentTable && par!=NULL){
        this->symbols.insert({_name, *(new Symbol(_name))});
        return &(this->symbols.find(_name)->second);
    }
    return par;
}

void SymbolTable::update()
{
    vector<SymbolTable *> vis; 
    int offset;
    for (auto &new_e : (this)->symbols)
    {
        if (new_e.first == (this->symbols).begin()->first) 
        {
            new_e.second.offset = 0;
            offset = new_e.second.size;
        }
        else 
        {
            new_e.second.offset = offset;
            offset += new_e.second.size;
        }
        if (new_e.second.nestedTable) 
        {
            vis.push_back(new_e.second.nestedTable);
        }
    }
    for (auto &table : vis) 
    {
        table->update();
    }
}

void SymbolTable::print()
{   
    cout << string(140, '=') << endl;
    cout << "Table Name: " << this->name << "\t\t Parent Name: " << ((this->parent) ? this->parent->name : "None") << endl;
    cout << string(140, '=') << endl;
    cout << setw(20) << "Name" << setw(40) << "Type" << setw(20) << "Initial Value" << setw(20) << "Offset" << setw(20) << "Size" << setw(20) << "Child"
         << "\n"
         << endl;
    vector<SymbolTable *> tovisit;

    // print all the symbols in the table
    for (auto &map_entry : (this)->symbols)
    {
        cout << setw(20) << map_entry.first;
        fflush(stdout);
        cout << setw(40) << (map_entry.second.isFunction ? "function" : map_entry.second.type->toString());
        cout << setw(20) << map_entry.second.initialValue << setw(20) << map_entry.second.offset << setw(20) << map_entry.second.size;
        cout << setw(20) << (map_entry.second.nestedTable ? map_entry.second.nestedTable->name : "NULL") << endl;
        // remember to print nested tables later
        if (map_entry.second.nestedTable)
        {
            tovisit.push_back(map_entry.second.nestedTable);
        }
    }
    cout << string(140, '-') << endl;
    cout << "\n"
         << endl;
    // print nested tables
    for (auto &table : tovisit)
    {
        table->print();
    }
}

// Implementation of symbol class
Symbol::Symbol(string name, SymbolType::typeEnum type, string init) : name(name), type(new SymbolType(type)), offset(0), nestedTable(NULL), initialValue(init), isFunction(false)
{
    size = this->type->getSize();
}
// update type of the symbol
Symbol *Symbol::update(SymbolType *type)
{
    this->type = type;
    size = this->type->getSize();
    return this;
}
// convert the present symbol to different type, return old symbol if conversion not possible
Symbol *Symbol::convert(SymbolType::typeEnum type_)
{

    // if the current type is float
    if ((this->type)->type == SymbolType::typeEnum::FLOAT)
    {
        // if the target type is inst
        if (type_ == SymbolType::typeEnum::INT)
        {
            // generate symbol of new type
            Symbol *fin_ = gentemp(type_);
            emit("=", fin_->name, "Float_TO_Int(" + this->name + ")");
            return fin_;
        }
        // if the target type is char
        else if (type_ == SymbolType::typeEnum::CHAR)
        {
            // generate symbol of new type
            Symbol *fin_ = gentemp(type_);
            emit("=", fin_->name, "Float_TO_Char(" + this->name + ")");
            return fin_;
        }
        // reutrn orignal symbol if the final type is not int or char
        return this;
    }
    // if current type is int
    else if ((this->type)->type == SymbolType::typeEnum::INT)
    {
        // if the target type is float
        if (type_ == SymbolType::typeEnum::FLOAT)
        {
            // generate symbol of new type
            Symbol *fin_ = gentemp(type_);
            emit("=", fin_->name, "INT_TO_Float(" + this->name + ")");
            return fin_;
        }
        // if the target type is char
        else if (type_ == SymbolType::typeEnum::CHAR)
        {
            // generate symbol of new type
            Symbol *fin_ = gentemp(type_);
            emit("=", fin_->name, "INT_TO_Char(" + this->name + ")");
            return fin_;
        }
        // reutrn orignal symbol if the final type is not float or char
        return this;
    }
    // if the current type si char
    else if ((this->type)->type == SymbolType::typeEnum::CHAR)
    {
        // if the target type is int
        if (type_ == SymbolType::typeEnum::INT)
        {
            // generate symbol of new type
            Symbol *fin_ = gentemp(type_);
            emit("=", fin_->name, "Char_TO_Int(" + this->name + ")");
            return fin_;
        }
        // if the target type is float
        else if (type_ == SymbolType::typeEnum::FLOAT)
        {
            // generate symbol of new type
            Symbol *fin_ = gentemp(type_);
            emit("=", fin_->name, "Char_TO_Float(" + this->name + ")");
            return fin_;
        }
        // reutrn orignal symbol if the final type is not int or float
        return this;
    }
    return this;
}

// Implementation of quad class
Quad::Quad(string result, string arg1, string op, string arg2) : result(result), op(op), arg1(arg1), arg2(arg2) {}
Quad::Quad(string result, int arg1, string op, string arg2) : result(result), op(op), arg1(toString(arg1)), arg2(arg2) {}

// print the quad
void Quad::print()
{
    // if binary operations
    auto binary_print = [this]()
    {
        cout << "\t" << this->result << " = " << this->arg1 << " " << this->op << " " << this->arg2 << endl;
    };
    // if relational operators
    auto relation_print = [this]()
    {
        cout << "\tif " << this->arg1 << " " << this->op << " " << this->arg2 << " goto " << this->result << endl;
    };
    // if shift operators
    auto shift_print = [this]()
    {
        cout << "\t" << this->result << " " << this->op[0] << " " << this->op[1] << this->arg1 << endl;
    };
    // if special type of operators
    auto shift_print_ = [this](string tp)
    {
        cout << "\t" << this->result << " " << tp << " " << this->arg1 << endl;
    };

    /* we define the printing format for all operators */
    if (this->op == "=")
    {
        cout << "\t" << this->result << " = " << this->arg1 << endl;
    }
    else if (this->op == "goto")
    {
        cout << "\tgoto " << this->result << endl;
    }
    else if (this->op == "return")
    {
        cout << "\treturn " << this->result << endl;
    }
    else if (this->op == "call")
    {
        cout << "\t" << this->result << " = call " << this->arg1 << ", " << this->arg2 << endl;
    }
    else if (this->op == "param")
    {
        cout << "\t"
             << "param " << this->result << endl;
    }
    else if (this->op == "label")
    {
        cout << this->result << endl;
    }
    else if (this->op == "=[]")
    {
        cout << "\t" << this->result << " = " << this->arg1 << "[" << this->arg2 << "]" << endl;
    }
    else if (this->op == "[]=")
    {
        cout << "\t" << this->result << "[" << this->arg1 << "] = " << this->arg2 << endl;
    }
    else if (this->op == "+" or this->op == "-" or this->op == "*" or this->op == "/" or this->op == "%" or this->op == "|" or this->op == "^" or this->op == "&" or this->op == "<<" or this->op == ">>")
    {
        binary_print();
    }
    else if (this->op == "==" or this->op == "!=" or this->op == "<" or this->op == ">" or this->op == "<=" or this->op == ">=")
    {
        relation_print();
    }
    else if (this->op == "=&" or this->op == "=*")
    {
        shift_print();
    }
    else if (this->op == "*=")
    {
        cout << "\t"
             << "*" << this->result << " = " << this->arg1 << endl;
    }
    else if (this->op == "=-")
    {
        shift_print_("= -");
    }
    else if (this->op == "~")
    {
        shift_print_("= ~");
    }
    else if (this->op == "!")
    {
        shift_print_("= !");
    }
    else
    {
        // if none of the above operators
        cout << this->op << this->arg1 << this->arg2 << this->result << endl;
        cout << "INVALID OPERATOR\n";
    }
}

// Implementation of emit funtions
void emit(string op, string result, string arg1, string arg2)
{
    Quad *q = new Quad(result, arg1, op, arg2);
    quadArray.push_back(q);
}
void emit(string op, string result, int arg1, string arg2)
{
    Quad *q = new Quad(result, arg1, op, arg2);
    quadArray.push_back(q);
}

// Implementation of backpatching functions
void backpatch(list<int> list_, int addr)
{
    // for all the addresses in the list, add the target address
    for (auto &i : list_)
    {
        quadArray[i - 1]->result = toString(addr);
    }
}
list<int> makeList(int base)
{
    // returns list with the base address as its only value
    return {base};
}

list<int> merge(list<int> first, list<int> second)
{
    // merge two lists
    list<int> ret = first;
    ret.merge(second);
    return ret;
}
// Implementation of Expression class functions

void Expression::toInt()
{
    // if the expression type is boolean
    if (this->type == Expression::typeEnum::BOOLEAN)
    {
        // generate symbol of new type and do backpatching and other required operations
        this->symbol = gentemp(SymbolType::typeEnum::INT);
        backpatch(this->trueList, static_cast<int>(quadArray.size() + 1));  // update the true list
        emit("=", this->symbol->name, "true");                              // emit the quad
        emit("goto", toString(static_cast<int>(quadArray.size() + 2)));     // emit the goto quad
        backpatch(this->falseList, static_cast<int>(quadArray.size() + 1)); // update the false list
        emit("=", this->symbol->name, "false");
    }
}

void Expression::toBool()
{
    // if the expression type is non boolean
    if (this->type == Expression::typeEnum::NONBOOLEAN)
    {
        // generate symbol of new type and do backpatching and other required operations
        this->falseList = makeList(static_cast<int>(quadArray.size() + 1)); // update the falselist
        emit("==", "", this->symbol->name, "0");                            // emit general goto statements
        this->trueList = makeList(static_cast<int>(quadArray.size() + 1));  // update the truelist
        emit("goto", "");
    }
}

// Implementation of other helper functions
int nextInstruction()
{
    // returns the next instruction number
    return quadArray.size() + 1;
}

// generates temporary of given type with given value s
Symbol *gentemp(SymbolType::typeEnum type, string s)
{
    Symbol *temp = new Symbol("t" + toString(temporaryCount++), type, s);
    currentTable->symbols.insert({temp->name, *temp});
    return temp;
}
// change current table to specified table
void changeTable(SymbolTable *table)
{
    currentTable = table;
}

// code to check if a and b are of the same type, promotes to the higher type if feasible and if that makes the type of both the same
bool typeCheck(Symbol *&a, Symbol *&b)
{
    // lambda function to check if a and b are of the same type
    std::function<bool(SymbolType *, SymbolType *)> type_comp = [&](SymbolType *first, SymbolType *second) -> bool
    {
        if (!first and !second)
            return true;
        else if (!first or !second or first->type != second->type)
            return false;
        else
            return type_comp(first->arrayType, second->arrayType);
    };
    // if the types are same return true
    if (type_comp(a->type, b->type))
        return true;
    // if the types are not same but can be cast safely according the rules, then cast and return
    else if (a->type->type == SymbolType::FLOAT or b->type->type == SymbolType::FLOAT)
    {
        a = a->convert(SymbolType::FLOAT);
        b = b->convert(SymbolType::FLOAT);
        return true;
    }
    else if (a->type->type == SymbolType::INT or b->type->type == SymbolType::INT)
    {
        a = a->convert(SymbolType::INT);
        b = b->convert(SymbolType::INT);
        return true;
    }
    // return false if not possible to cast safelt to same type
    else
    {
        return false;
    }
}
// Implementation of utility functions
// overloaded toString function to maintain semantic consistency
// convert int to string
string toString(int i)
{
    return to_string(i);
}
// converts float to string
string toString(float f)
{
    return to_string(f);
}
// converts char to string
string toString(char c)
{
    return string(1, c);
}

int main()
{
    // initialization of global variables
    tableCount = 0;
    temporaryCount = 0;
    globalTable = new SymbolTable("global");
    currentTable = globalTable;
    cout << left; // left allign
    yyparse();
    globalTable->update();
    globalTable->print();
    int ins = 1;
    for (auto it : quadArray)
    {
        cout << setw(4) << ins++ << ": ";
        it->print();
    }
    return 0;
}