
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
    cout << string(140, '-') << endl;
    cout << "Symbol Table Name : " << this->name << "\t\t Parent Table Name: " << ((this->parent) ? this->parent->name : "None") << endl;
    cout << string(140, '-') << endl;
    cout << setw(20) << "Name" << setw(40) << "Type" << setw(20) << "Initial Value" << setw(20) << "Offset" << setw(20) << "Size" << setw(20) << "Child"
         << "\n"
         << endl;
    vector<SymbolTable *> target;
    for (auto &it : (this)->symbols)
    {
        cout << setw(20) << it.first; fflush(stdout);
        cout << setw(40) << (it.second.isFunction ? "function" : it.second.type->toString());
        cout << setw(20) << it.second.initialValue << setw(20) << it.second.offset << setw(20) << it.second.size;
        cout << setw(20) << (it.second.nestedTable ? it.second.nestedTable->name : "NULL") << endl;
        if (it.second.nestedTable)
        {
            target.push_back(it.second.nestedTable);
        }
    }
    cout << string(140, '-') << endl;
    cout << "\n"
         << endl;
    for (auto &table : target)
    {
        table->print();
    }
}

Symbol::Symbol(string _name, SymbolType::typeEnum _type, string _value)
{
    this->name = _name;
    this->type = new SymbolType(_type);
    this->offset = 0;
    this->nestedTable = NULL;
    this->initialValue = _value;
    this->isFunction = false;
    size = this->type->getSize();
}

Symbol *Symbol::update(SymbolType *_type)
{
    this->type = _type;
    this->size = this->type->getSize();
    return this;
}

Symbol *Symbol::convert(SymbolType::typeEnum type_)
{
    if ((this->type)->type == SymbolType::typeEnum::FLOAT)
    {
        if (type_ == SymbolType::typeEnum::CHAR)
        {
            Symbol *temp = gentemp(type_);
            emit("=", temp->name, "FLOAT_TO_INT(" + this->name + ")");
            return temp;
        }
        else if (type_ == SymbolType::typeEnum::CHAR)
        {
            Symbol *temp = gentemp(type_);
            emit("=", temp->name, "FLOAT_TO_CHAR(" + this->name + ")");
            return temp;
        }
        return this;
    }
    else if ((this->type)->type == SymbolType::typeEnum::INT)
    {
        if (type_ == SymbolType::typeEnum::FLOAT)
        {
            Symbol *temp = gentemp(type_);
            emit("=", temp->name, "INT_TO_FLOAT(" + this->name + ")");
            return temp;
        }
        else if (type_ == SymbolType::typeEnum::CHAR)
        {
            Symbol *temp = gentemp(type_);
            emit("=", temp->name, "INT_TO_CHAR(" + this->name + ")");
            return temp;
        }
        return this;
    }
    else if ((this->type)->type == SymbolType::typeEnum::CHAR)
    {
        if (type_ == SymbolType::typeEnum::INT)
        {
            Symbol *temp_ = gentemp(type_);
            emit("=", temp_->name, "CHAR_TO_INT(" + this->name + ")");
            return temp_;
        }
        else if (type_ == SymbolType::typeEnum::FLOAT)
        {
            Symbol *temp_ = gentemp(type_);
            emit("=", temp_->name, "CHAR_TO_FLOAT(" + this->name + ")");
            return temp_;
        }
        return this;
    }
    return this;
}

Quad::Quad(string result, string arg1, string op, string arg2){
    this->result = result;
    this->op = op;
    this->arg1 = arg1;
    this->arg2 = arg2;
}
Quad::Quad(string result, int arg1, string op, string arg2){
    this->result = result;
    this->op = op;
    this->arg1 = arg1;
    this->arg2 = arg2;
}

void Quad::print()
{
    auto binary_print = [this]()
    {
        cout << "\t" << this->result << " = " << this->arg1 << " " << this->op << " " << this->arg2 << endl;
    };
    auto relation_print = [this]()
    {
        cout << "\tif " << this->arg1 << " " << this->op << " " << this->arg2 << " goto " << this->result << endl;
    };

    auto shift_print = [this]()
    {
        cout << "\t" << this->result << " " << this->op[0] << " " << this->op[1] << this->arg1 << endl;
    };
    auto shift_print_ = [this](string tp)
    {
        cout << "\t" << this->result << " " << tp << " " << this->arg1 << endl;
    };
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
        cout << this->op << this->arg1 << this->arg2 << this->result << endl;
        cout << "INVALID OPERATOR\n";
    }
}

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

void backpatch(list<int> list_, int addr)
{
    for (auto &i : list_)
    {
        quadArray[i - 1]->result = toString(addr);
    }
}
list<int> makeList(int base)
{
    return {base};
}

list<int> merge(list<int> first, list<int> second)
{
 
    list<int> ret = first;
    ret.merge(second);
    return ret;
}

void Expression::toInt()
{
    if (this->type == Expression::typeEnum::BOOLEAN)
    {
        this->symbol = gentemp(SymbolType::typeEnum::INT);
        backpatch(this->trueList, static_cast<int>(quadArray.size() + 1));  
        emit("=", this->symbol->name, "true");                              
        emit("goto", toString(static_cast<int>(quadArray.size() + 2)));     
        backpatch(this->falseList, static_cast<int>(quadArray.size() + 1)); 
        emit("=", this->symbol->name, "false");
    }
}

void Expression::toBool()
{
    // if the expression type is non boolean
    if (this->type == Expression::typeEnum::NONBOOLEAN)
    {
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