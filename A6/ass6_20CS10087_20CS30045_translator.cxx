#include "ass6_20CS10087_20CS30045_translator.h"

/**
 * @brief Global variables
 *
 * quadArray: vector of quads
 * currentTable, globalTable, parentTable : Symbol Tables
 * currentSmbol : pointer to current symbol
 * currentType : Data type of the current symbol
 * tableCount : total symbol tables
 * temporaryCount : temporary count
 */
vector<Quad *> quadArray;
SymbolTable *currentTable, *globalTable, *parentTable;
Symbol *currentSymbol;
SymbolType::typeEnum currentType;
int tableCount, temporaryCount;
vector<string> stringLiterals;

/** @brief Implementation of activation record class
 */
ActivationRecord::ActivationRecord() : totalDisplacement(0), displacement(map<string, int>()) {}  // start with an initial displacement of 0

/**
 * @brief Construct a new Symbol Type:: Symbol Type object
 *
 * @param type data type
 * @param arrayType type of the array
 * @param width width of array
 */
SymbolType::SymbolType(typeEnum type, SymbolType *arrayType, int width) : type(type), width(width), arrayType(arrayType) {}

/**
 * @brief function to get the size of Symbol type
 * @return int
 */
int SymbolType::getSize()
{
    if (type == CHAR)
        return 1;
    else if (type == INT)
        return 4;
    else if (type == FLOAT || type == POINTER)
        return 8;
    else if (type == ARRAY)
        return width * (arrayType->getSize());
    else
        return 0;
}

/**
 * @brief function to get the symbol type in string format
 *
 * @return string
 */
string SymbolType::toString()
{
    if (this->type == SymbolType::VOID)
        return "void";
    else if (this->type == SymbolType::CHAR)
        return "char";
    else if (this->type == SymbolType::INT)
        return "int";
    else if (this->type == SymbolType::FLOAT)
        return "float";
    else if (this->type == SymbolType::POINTER)
        return "ptr(" + this->arrayType->toString() + ")";
    else if (this->type == SymbolType::FUNCTION)
        return "function";
    else if (this->type == SymbolType::ARRAY)
        return "array(" + to_string(this->width) + ", " + this->arrayType->toString() + ")";
    else if (this->type == SymbolType::BLOCK)
        return "block";
}

/**
 * @brief Construct a new Symbol Table:: Symbol Table object
 *
 * @param name name of symbol type
 * @param parent parent of symbol type
 */
SymbolTable::SymbolTable(string name, SymbolTable *parent) : name(name), parent(parent) {}

/**
 * @brief function to look for the symbol in the symbol table
 *
 * @param name name of the symbol
 * @return Symbol*
 */
Symbol *SymbolTable::lookup(string name)
{
    auto it = (this)->symbols.find(name);
    if (it != (this)->symbols.end())
        return &(it->second);

    Symbol *ret_ptr = nullptr;
    if (this->parent != NULL)
        ret_ptr = this->parent->lookup(name);

    if (this == currentTable && !ret_ptr)
    {
        ret_ptr = new Symbol(name);
        ret_ptr->category = Symbol::LOCAL;
        if(currentTable == globalTable)
            ret_ptr->category = Symbol::GLOBAL;
        this->symbols.insert({name, *ret_ptr});
        return &((this)->symbols.find(name)->second);
    }
    return ret_ptr;
}

/**
 * @brief function to update the offset of symbols in the symbol table
 *
 */
void SymbolTable::update()
{
    vector<SymbolTable *> visited;
    int offset;
    for (auto &map_entry : (this)->symbols)
    {
        if (map_entry.first == (this->symbols).begin()->first)
        {
            map_entry.second.offset = 0;
            offset = map_entry.second.size;
        }
        else
        {
            map_entry.second.offset = offset;
            offset += map_entry.second.size;
        }
        if (map_entry.second.nestedTable)
        {
            visited.push_back(map_entry.second.nestedTable);
        }
    }
    
    // now prepare activation record for the current table
    activationRecord = new ActivationRecord();
    // first stack the parameters
    for (auto map_entry : (this)->symbols)
    {
        if (map_entry.second.category == Symbol::PARAMETER)
        {
            if(map_entry.second.size != 0)
            {
                activationRecord->totalDisplacement -= map_entry.second.size;
                activationRecord->displacement[map_entry.second.name] = activationRecord->totalDisplacement;
            }
        }
    }

    // now stack the local variables and the temporaries
    for (auto map_entry : (this)->symbols)
    {
        if ((map_entry.second.category == Symbol::LOCAL && map_entry.second.name != "return") || map_entry.second.category == Symbol::TEMPORARY)
        {
            if(map_entry.second.size != 0)
            {
                activationRecord->totalDisplacement -= map_entry.second.size;
                activationRecord->displacement[map_entry.second.name] = activationRecord->totalDisplacement;
            }
        }
    }
    
    // update children table
    for (auto &table : visited)
    {
        table->update();
    }
}

/**
 * @brief function to print the symbol table
 *
 */
void SymbolTable::print()
{
    cout << string(140, '=') << endl;
    cout << "Table Name: " << this->name <<"\t\t Parent Name: "<< ((this->parent)?this->parent->name:"None") << endl;
    cout << string(140, '=') << endl;
    cout << setw(20) << "Name" << setw(40) << "Type" << setw(20) << "Category" << setw(20) << "Initial Value" << setw(20) << "Offset" << setw(20) << "Size" << setw(20) << "Child" << "\n" << endl;
    // cout<<"Name\t Type\t InitialValue\t Offset\t Size\n";
    
    vector<SymbolTable *> tovisit;
    for (auto &map_entry : (this)->symbols)
    {
        cout << setw(20) << map_entry.first;
        fflush(stdout);
        cout << setw(40) << map_entry.second.type->toString();
        cout << setw(20);
        if(map_entry.second.category == Symbol::LOCAL)
            cout << "local";
        else if(map_entry.second.category == Symbol::GLOBAL)
            cout << "global";
        else if(map_entry.second.category == Symbol::FUNCTION)
            cout << "function";
        else if(map_entry.second.category == Symbol::PARAMETER)
            cout << "parameter";
        else if(map_entry.second.category == Symbol::TEMPORARY)
            cout << "temporary";
        cout << setw(20) << map_entry.second.initialValue << setw(20) << map_entry.second.offset << setw(20) << map_entry.second.size;
        cout << setw(20) << (map_entry.second.nestedTable ? map_entry.second.nestedTable->name : "NULL") << endl;
        if (map_entry.second.nestedTable)
        {
            tovisit.push_back(map_entry.second.nestedTable);
        }
    }
    cout << string(140, '-') << endl;
    cout << "\n"
         << endl;
    for (auto &table : tovisit)
    {
        table->print();
    }
}

/**
 * @brief Constructor for Symbol Class
 *
 * @param name Name of Symbol
 * @param type symbol type
 * @param init initial value
 */
Symbol::Symbol(string name, SymbolType::typeEnum type, string init) : name(name), type(new SymbolType(type)), offset(0), nestedTable(NULL), initialValue(init)
{
    size = this->type->getSize();
}
/**
 * @brief function to update the type of symbol
 *
 * @param type type of the symbol
 * @return Symbol*
 */
Symbol *Symbol::update(SymbolType *type)
{
    this->type = type;
    size = this->type->getSize();
    return this;
}
/**
 * @brief function to convert the type of the symbol
 *
 * @param type_ new type of symbol
 * @return Symbol*
 */
Symbol *Symbol::convert(SymbolType::typeEnum type_)
{
    if ((this->type)->type == SymbolType::typeEnum::FLOAT)
    {
        if (type_ == SymbolType::typeEnum::INT)
        {
            Symbol *fin_ = gentemp(type_);
            emit("=", fin_->name, "Float_TO_Int(" + this->name + ")");
            return fin_;
        }
        else if (type_ == SymbolType::typeEnum::CHAR)
        {
            Symbol *fin_ = gentemp(type_);
            emit("=", fin_->name, "Float_TO_Char(" + this->name + ")");
            return fin_;
        }
        return this;
    }
    else if ((this->type)->type == SymbolType::typeEnum::INT)
    {
        if (type_ == SymbolType::typeEnum::FLOAT)
        {
            Symbol *fin_ = gentemp(type_);
            emit("=", fin_->name, "INT_TO_Float(" + this->name + ")");
            return fin_;
        }
        else if (type_ == SymbolType::typeEnum::CHAR)
        {
            Symbol *fin_ = gentemp(type_);
            emit("=", fin_->name, "INT_TO_Char(" + this->name + ")");
            return fin_;
        }
        return this;
    }
    else if ((this->type)->type == SymbolType::typeEnum::CHAR)
    {
        if (type_ == SymbolType::typeEnum::INT)
        {
            Symbol *fin_ = gentemp(type_);
            emit("=", fin_->name, "Char_TO_Int(" + this->name + ")");
            return fin_;
        }
        else if (type_ == SymbolType::typeEnum::FLOAT)
        {
            Symbol *fin_ = gentemp(type_);
            emit("=", fin_->name, "Char_TO_Float(" + this->name + ")");
            return fin_;
        }
        return this;
    }
    return this;
}

/**
 * @brief Construct a new Quad:: Quad object
 *
 * @param result result
 * @param arg1 argument 1
 * @param op operator
 * @param arg2 argument 2
 */
Quad::Quad(string result, string arg1, string op, string arg2) : result(result), op(op), arg1(arg1), arg2(arg2) {}
/**
 * @brief Construct a new Quad:: Quad object
 *
 * @param result result
 * @param arg1 integer passed as argument 1
 * @param op operator
 * @param arg2 argument 2
 */
Quad::Quad(string result, int arg1, string op, string arg2) : result(result), op(op), arg1(toString(arg1)), arg2(arg2) {}

/**
 * @brief function to print the quadruple
 *
 */
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
        cout << "Function start: " << this->result << endl;
    }
    else if (this->op == "labelend")
    {
        cout << "Function end: " << this->result << endl;
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
    else if (this->op == "=str")
    {
        cout << "\t" << this->result << " = " << stringLiterals[atoi(this->arg1.c_str())] << endl;
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

/**
 * @brief function to create a new quadruple and store it in the quad array
 *
 * @param op operator
 * @param result result
 * @param arg1 argument 1
 * @param arg2 argument 2
 */
void emit(string op, string result, string arg1, string arg2)
{
    Quad *q = new Quad(result, arg1, op, arg2);
    quadArray.push_back(q);
}

/**
 * @brief function to create a mew quadruple and store it in the quad array if first argument is passed as integer
 *
 * @param op operator
 * @param result result
 * @param arg1 argument 1 (integer)
 * @param arg2 argument 2
 */
void emit(string op, string result, int arg1, string arg2)
{
    Quad *q = new Quad(result, arg1, op, arg2);
    quadArray.push_back(q);
}

/**
 * @brief function to backpatch the list with addr
 *
 * @param list_ list
 * @param addr address
 */
void backpatch(list<int> list_, int addr)
{
    for (auto &i : list_)
    {
        quadArray[i - 1]->result = toString(addr);
    }
}

void finalBackpatch()
{
    // any dangling exits for void type functions are sent to function end
    int curPos = quadArray.size();
    int lastExit = -1;
    for(auto it = quadArray.rbegin(); it != quadArray.rend(); it++) {
        string op = (*it)->op;
        if(op == "labelend") 
        {
            lastExit = curPos;
        } 
        else if(op == "goto" or op == "==" or op == "!=" or op == "<" or op == ">" or op == "<=" or op == ">=") {
            if((*it)->result.empty()) 
            {
                (*it)->result = toString(lastExit);
            }
        }
        curPos--;
    }
}

/**
 * @brief function to create a new list with base as the only element
 *
 * @param base
 * @return list<int>
 */
list<int> makeList(int base)
{
    return {base};
}

/**
 * @brief function to merge two lists
 *
 * @param first first list
 * @param second second list
 * @return list<int>
 */
list<int> merge(list<int> first, list<int> second)
{
    list<int> ret = first;
    ret.merge(second);
    return ret;
}

/**
 * @brief function to return the expression value as integer value
 *
 */
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

/**
 * @brief function to return the expression value as boolean value
 *
 */
void Expression::toBool()
{
    if (this->type == Expression::typeEnum::NONBOOLEAN)
    {
        this->falseList = makeList(static_cast<int>(quadArray.size() + 1));
        emit("==", "", this->symbol->name, "0");
        this->trueList = makeList(static_cast<int>(quadArray.size() + 1));
        emit("goto", "");
    }
}

/**
 * @brief function to get the next instruction number
 *
 * @return int
 */
int nextInstruction()
{
    return quadArray.size() + 1;
}

/**
 * @brief function to generate new temp variable and insert in the symbol table
 *
 * @param type symbol type
 * @param s
 * @return Symbol*
 */
Symbol *gentemp(SymbolType::typeEnum type, string s)
{
    Symbol *temp = new Symbol("t" + toString(temporaryCount++), type, s);
    currentTable->symbols.insert({temp->name, *temp});
    return temp;
}

/**
 * @brief function to change the current table
 *
 * @param table new current table
 */
void changeTable(SymbolTable *table)
{
    currentTable = table;
}

/**
 * @brief function to check whether two symbols have same type
 *
 * @param a first symbol
 * @param b second symbol
 * @return true
 * @return false
 */
bool typeCheck(Symbol *&a, Symbol *&b)
{
    std::function<bool(SymbolType *, SymbolType *)> type_comp = [&](SymbolType *first, SymbolType *second) -> bool
    {
        if (!first and !second)
            return true;
        else if (!first or !second or first->type != second->type)
            return false;
        else
            return type_comp(first->arrayType, second->arrayType);
    };
    if (type_comp(a->type, b->type))
        return true;
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
    else
    {
        return false;
    }
}

/**
 * @brief function to convert int to string
 *
 * @param i
 * @return string
 */
string toString(int i)
{
    return to_string(i);
}

/**
 * @brief function to convert float to string
 *
 * @param f
 * @return string
 */
string toString(float f)
{
    return to_string(f);
}

/**
 * @brief function to convert char to string
 *
 * @param c
 * @return string
 */
string toString(char c)
{
    return string(1, c);
}