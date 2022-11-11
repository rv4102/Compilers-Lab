#include "ass6_20CS10087_20CS30045_translator.h"

string in_file, asm_file;
ActivationRecord *curr_ar; 
ofstream asmFile;
map<char, int> esc_to_ascii = {{'n', 10},{'t', 9},{'r', 13},{'b', 8},{'f', 12},{'v', 11},{'a', 7},{'0', 0}};
map<int, map<int, string>> num_to_reg = {{1, {{1, "dil"}, {4, "edi"}, {8, "rdi"}}}, {2, {{1, "sil"}, {4, "esi"}, {8, "rsi"}}}, {3, {{1, "dl"}, {4, "edx"}, {8, "rdx"}}}, {4, {{1, "cl"}, {4, "ecx"}, {8, "rcx"}}}};

int get_ascii(string cc)
{
    if (cc.length() == 3)
    {
        return (int)cc[1];
    }
    else
    {
        if (esc_to_ascii.find(cc[2]) != esc_to_ascii.end())
        {
            return esc_to_ascii[cc[2]];
        }
        else
        {
            return (int)cc[2];
        }
    }
}


string stack_location(string name)
{
    if (curr_ar->displacement.count(name))
        return toString(curr_ar->displacement[name]) + "(%rbp)";
    else 
        return name;
}

string find_register(string name, int number, int size)
{
    string regis = num_to_reg[number][size];
    return "%" + regis;
}

void storing_paramter(string name, int number)
{
    Symbol *symbol = currentTable->lookup(name);
    int size = symbol->size;
    SymbolType::typeEnum type = symbol->type->type;
    string instr = "";
    if (type == SymbolType::ARRAY)
    {
        instr = "leaq";
        size = 8;
    }
    else if (size == 1)
    {
        instr = "movb";
    }
    else if (size == 4)
    {
        instr = "movl";
    }
    else if (size == 8)
    {
        instr = "movq";
    }
    string regis = find_register(name, number, size);
    asmFile << "\t" << setw(8) << instr << stack_location(name) << ", " << regis << endl;
}

void parameter(string name, int number)
{
    Symbol *symbol = currentTable->lookup(name);
    int size = symbol->size;
    SymbolType::typeEnum type = symbol->type->type;
    string instr = "";
    if (type == SymbolType::ARRAY)
    {
        instr = "movq";
        size = 8;
    }
    else if (size == 1)
    {
        instr = "movb";
    }
    else if (size == 4)
    {
        instr = "movl";
    }
    else if (size == 8)
    {
        instr = "movq";
    }
    string regis = find_register(name, number, size);
    asmFile << "\t" << setw(8) << instr << regis << ", " << stack_location(name) << endl;
}



void translate()
{
    asmFile.open(asm_file);
    asmFile << left;
    asmFile << "\t.file\t\"" + in_file + "\"" << endl;
    asmFile << endl;
    asmFile << "#\t"
                 << "function variables and temp are allocated on the stack:\n"
                 << endl;
    for (auto &symbol : globalTable->symbols)
    {
        if (symbol.second.category == Symbol::FUNCTION)
        {
            asmFile << "#\t" << symbol.second.name << endl;
            for (auto &record : symbol.second.nestedTable->activationRecord->displacement)
            {
                asmFile << "#\t" << record.first << ": " << record.second << endl;
            }
        }
    }
    asmFile << endl;
    if (stringLiterals.size() > 0)
    {
        asmFile << "\t.section\t.rodata" << endl;
        int i = 0;
        for (auto &stringLiteral : stringLiterals)
        {
            asmFile << ".LC" << i++ << ":" << endl;
            asmFile << "\t.string\t" << stringLiteral << endl;
        }
    }

    for (auto &symbol : globalTable->symbols)
    {
        if (symbol.second.initialValue.empty() && symbol.second.category == Symbol::GLOBAL)
        {
            asmFile << "\t.comm\t" << symbol.first << "," << symbol.second.size << "," << symbol.second.size << endl;
        }
    }
    map<int, string> label_map;
    int num_of_quad = 1, labelNum = 0;
    for (auto &quad : quadArray)
    {
        if (quad->op == "label")
        {
            label_map[num_of_quad] = ".LFB" + toString(labelNum);
        }
        else if (quad->op == "labelend")
        {
            label_map[num_of_quad] = ".LFE" + toString(labelNum);
            labelNum++;
        }
        num_of_quad++;
    }
    for (auto &quad : quadArray)
    {
        if (quad->op == "goto" or quad->op == "==" or quad->op == "!=" or quad->op == "<" or quad->op == ">" or quad->op == "<=" or quad->op == ">=")
        {
            int loc = stoi(quad->result);
            if (label_map.find(loc) == label_map.end())
            {
                label_map[loc] = ".L" + toString(labelNum);
                labelNum++;
            }
        }
    }

    bool txt_spc = false;
    string glb_strtemp;
    int glb_inttemp, glb_chartemp; 
    string fun_label;
    stack<string> params;
    num_of_quad = 1;
    for (auto &quad : quadArray)
    {

        if (quad->op == "label")
        {
            if (!txt_spc)
            {
                asmFile << "\t.text" << endl;
                txt_spc = true;
            }

            currentTable = globalTable->lookup(quad->result)->nestedTable;
            curr_ar = currentTable->activationRecord;

            fun_label = label_map[num_of_quad];
            fun_label[3] = 'E';
            asmFile << "\t" << setw(8) << ".globl" << quad->result << endl;
            asmFile << "\t" << setw(8) << ".type" << quad->result << ", @function" << endl;
            asmFile << quad->result << ":" << endl;
            asmFile << label_map[num_of_quad] << ":" << endl;
            asmFile << "\t"
                         << ".cfi_startproc" << endl;
            asmFile << "\t" << setw(8) << "pushq"
                         << "%rbp" << endl;
            asmFile << "\t.cfi_def_cfa_offset 16" << endl;
            asmFile << "\t.cfi_offset 6, -16" << endl;
            asmFile << "\t" << setw(8) << "movq"
                         << "%rsp, %rbp" << endl;
            asmFile << "\t.cfi_def_cfa_register 6" << endl;
            asmFile << "\t" << setw(8) << "subq"
                         << "$" << -curr_ar->totalDisplacement << ", %rsp" << endl;

            int number = 1;
            for (auto param : currentTable->parameters)
            {
                parameter(param, number);
                number++;
            }
        }
        else if (quad->op == "labelend")
        {
            asmFile << label_map[num_of_quad] << ":" << endl;
            asmFile << "\t" << setw(8) << "movq"
                         << "%rbp, %rsp" << endl;
            asmFile << "\t" << setw(8) << "popq"
                         << "%rbp" << endl;
            asmFile << "\t"
                         << ".cfi_def_cfa 7, 8" << endl;
            asmFile << "\t"
                         << "ret" << endl;
            asmFile << "\t"
                         << ".cfi_endproc" << endl;
            asmFile << "\t" << setw(8) << ".size" << quad->result << ", .-" << quad->result << endl;

            txt_spc = false;
        }
        else
        {
            if (txt_spc)
            {
                string op = quad->op;
                string result = quad->result;
                string arg1 = quad->arg1;
                string arg2 = quad->arg2;

                if (label_map.count(num_of_quad))
                {
                    asmFile << label_map[num_of_quad] << ":" << endl;
                }

                if (op == "=")
                {
                    if (isdigit(arg1[0]))
                    {
                        // integer constant
                        asmFile << "\t" << setw(8) << "movl"
                                     << "$" << arg1 << ", " << stack_location(result) << endl;
                    }
                    else if (arg1[0] == '\'')
                    {
                        // character constant
                        asmFile << "\t" << setw(8) << "movb"
                                     << "$" << get_ascii(arg1) << ", " << stack_location(result) << endl;
                    }
                    else
                    {
                        int sz = currentTable->lookup(arg1)->size;
                        if (sz == 1)
                        {
                            asmFile << "\t" << setw(8) << "movb" << stack_location(arg1) << ", %al" << endl;
                            asmFile << "\t" << setw(8) << "movb"
                                         << "%al, " << stack_location(result) << endl;
                        }
                        else if (sz == 4)
                        {
                            asmFile << "\t" << setw(8) << "movl" << stack_location(arg1) << ", %eax" << endl;
                            asmFile << "\t" << setw(8) << "movl"
                                         << "%eax, " << stack_location(result) << endl;
                        }
                        else if (sz == 8)
                        {
                            asmFile << "\t" << setw(8) << "movq" << stack_location(arg1) << ", %rax" << endl;
                            asmFile << "\t" << setw(8) << "movq"
                                         << "%rax, " << stack_location(result) << endl;
                        }
                    }
                }
                else if (op == "=str")
                {
                    asmFile << "\t" << setw(8) << "movq"
                                 << "$.LC" << arg1 << ", " << stack_location(result) << endl;
                }
                else if (op == "param")
                {
                    params.push(result);
                }
                else if (op == "call")
                {
                    int paramCount = stoi(arg2);
                    while (paramCount)
                    {
                        storing_paramter(params.top(), paramCount);
                        params.pop();
                        paramCount--;
                    }
                    asmFile << "\t" << setw(8) << "call" << arg1 << endl;
                    int sz = currentTable->lookup(result)->size;
                    if (sz == 1)
                    {
                        asmFile << "\t" << setw(8) << "movb"
                                     << "%al, " << stack_location(result) << endl;
                    }
                    else if (sz == 4)
                    {
                        asmFile << "\t" << setw(8) << "movl"
                                     << "%eax, " << stack_location(result) << endl;
                    }
                    else if (sz == 8)
                    {
                        asmFile << "\t" << setw(8) << "movq"
                                     << "%rax, " << stack_location(result) << endl;
                    }
                }
                else if (op == "return")
                {
                    if (!result.empty())
                    {
                        int sz = currentTable->lookup(result)->size;
                        if (sz == 1)
                        {
                            asmFile << "\t" << setw(8) << "movb" << stack_location(result) << ", %al" << endl;
                        }
                        else if (sz == 4)
                        {
                            asmFile << "\t" << setw(8) << "movl" << stack_location(result) << ", %eax" << endl;
                        }
                        else if (sz == 8)
                        {
                            asmFile << "\t" << setw(8) << "movq" << stack_location(result) << ", %rax" << endl;
                        }
                    }
                    if (quadArray[num_of_quad]->op != "labelend") 
                        asmFile << "\t" << setw(8) << "jmp" << fun_label << endl;
                }
                else if (op == "goto")
                {
                    asmFile << "\t" << setw(8) << "jmp" << label_map[stoi(result)] << endl;
                }
                else if (op == "==" or op == "!=" or op == "<" or op == "<=" or op == ">" or op == ">=")
                {
                    // check if arg1 == arg2
                    int sz = currentTable->lookup(arg1)->size;
                    string movins, cmpins, movreg;
                    if (sz == 1)
                    {
                        movins = "movb";
                        cmpins = "cmpb";
                        movreg = "%al";
                    }
                    else if (sz == 4)
                    {
                        movins = "movl";
                        cmpins = "cmpl";
                        movreg = "%eax";
                    }
                    else if (sz == 8)
                    {
                        movins = "movq";
                        cmpins = "cmpq";
                        movreg = "%rax";
                    }
                    asmFile << "\t" << setw(8) << movins << stack_location(arg2) << ", " << movreg << endl;
                    asmFile << "\t" << setw(8) << cmpins << movreg << ", " << stack_location(arg1) << endl;
                    if (op == "==")
                    {
                        asmFile << "\t" << setw(8) << "je" << label_map[stoi(result)] << endl;
                    }
                    else if (op == "!=")
                    {
                        asmFile << "\t" << setw(8) << "jne" << label_map[stoi(result)] << endl;
                    }
                    else if (op == "<")
                    {
                        asmFile << "\t" << setw(8) << "jl" << label_map[stoi(result)] << endl;
                    }
                    else if (op == "<=")
                    {
                        asmFile << "\t" << setw(8) << "jle" << label_map[stoi(result)] << endl;
                    }
                    else if (op == ">")
                    {
                        asmFile << "\t" << setw(8) << "jg" << label_map[stoi(result)] << endl;
                    }
                    else if (op == ">=")
                    {
                        asmFile << "\t" << setw(8) << "jge" << label_map[stoi(result)] << endl;
                    }
                }
                else if (op == "+")
                {
                    // result = arg1 + arg2
                    if (result == arg1)
                    {
                        // increment arg1
                        asmFile << "\t" << setw(8) << "incl" << stack_location(arg1) << endl;
                    }
                    else
                    {
                        asmFile << "\t" << setw(8) << "movl" << stack_location(arg1) << ", "
                                     << "%eax" << endl;
                        asmFile << "\t" << setw(8) << "addl" << stack_location(arg2) << ", "
                                     << "%eax" << endl;
                        asmFile << "\t" << setw(8) << "movl"
                                     << "%eax"
                                     << ", " << stack_location(result) << endl;
                    }
                }
                else if (op == "-")
                {
                    // result = arg1 - arg2
                    if (result == arg1)
                    {
                        // decrement arg1
                        asmFile << "\t" << setw(8) << "decl" << stack_location(arg1) << endl;
                    }
                    else
                    {
                        asmFile << "\t" << setw(8) << "movl" << stack_location(arg1) << ", "
                                     << "%eax" << endl;
                        asmFile << "\t" << setw(8) << "subl" << stack_location(arg2) << ", "
                                     << "%eax" << endl;
                        asmFile << "\t" << setw(8) << "movl"
                                     << "%eax"
                                     << ", " << stack_location(result) << endl;
                    }
                }
                else if (op == "*")
                {
                    // result = arg1 * arg2
                    asmFile << "\t" << setw(8) << "movl" << stack_location(arg1) << ", "
                                 << "%eax" << endl;
                    if (isdigit(arg2[0]))
                    {
                        asmFile << "\t" << setw(8) << "imull"
                                     << "$" + stack_location(arg2) << ", "
                                     << "%eax" << endl;
                    }
                    else
                    {
                        asmFile << "\t" << setw(8) << "imull" << stack_location(arg2) << ", "
                                     << "%eax" << endl;
                    }
                    asmFile << "\t" << setw(8) << "movl"
                                 << "%eax"
                                 << ", " << stack_location(result) << endl;
                }
                else if (op == "/")
                {
                    // result = arg1  / arg2
                    asmFile << "\t" << setw(8) << "movl" << stack_location(arg1) << ", "
                                 << "%eax" << endl;
                    asmFile << "\t" << setw(8) << "cdq" << endl;
                    asmFile << "\t" << setw(8) << "idivl" << stack_location(arg2) << endl;
                    asmFile << "\t" << setw(8) << "movl"
                                 << "%eax"
                                 << ", " << stack_location(result) << endl;
                }
                else if (op == "%")
                {
                    // result = arg1 % arg2
                    asmFile << "\t" << setw(8) << "movl" << stack_location(arg1) << ", "
                                 << "%eax" << endl;
                    asmFile << "\t" << setw(8) << "cdq" << endl;
                    asmFile << "\t" << setw(8) << "idivl" << stack_location(arg2) << endl;
                    asmFile << "\t" << setw(8) << "movl"
                                 << "%edx"
                                 << ", " << stack_location(result) << endl;
                }
                else if (op == "=[]")
                {
                    // result = arg1[arg2]
                    Symbol *symbol = currentTable->lookup(arg1);
                    if (symbol->category == Symbol::PARAMETER)
                    {
                        asmFile << "\t" << setw(8) << "movl" << stack_location(arg2) << ", "
                                     << "%eax" << endl;
                        asmFile << "\t" << setw(8) << "cltq" << endl;
                        asmFile << "\t" << setw(8) << "addq" << stack_location(arg1) << ", "
                                     << "%rax" << endl;
                        asmFile << "\t" << setw(8) << "movl"
                                     << "(%rax)"
                                     << ", "
                                     << "%eax" << endl;
                        asmFile << "\t" << setw(8) << "movl"
                                     << "%eax"
                                     << ", " << stack_location(result) << endl;
                    }
                    else
                    {
                        asmFile << "\t" << setw(8) << "movl" << stack_location(arg2) << ", "
                                     << "%eax" << endl;
                        asmFile << "\t" << setw(8) << "cltq" << endl;
                        asmFile << "\t" << setw(8) << "movl" << curr_ar->displacement[arg1] << "(%rbp, %rax, 1)"
                                     << ", "
                                     << "%eax" << endl;
                        asmFile << "\t" << setw(8) << "movl"
                                     << "%eax"
                                     << ", " << stack_location(result) << endl;
                    }
                }
                else if (op == "[]=")
                {
                    // result[arg1] = arg2
                    Symbol *symbol = currentTable->lookup(result);
                    if (symbol->category == Symbol::PARAMETER)
                    {
                        asmFile << "\t" << setw(8) << "movl" << stack_location(arg1) << ", "
                                     << "%eax" << endl;
                        asmFile << "\t" << setw(8) << "cltq" << endl;
                        asmFile << "\t" << setw(8) << "addq" << stack_location(result) << ", "
                                     << "%rax" << endl;
                        asmFile << "\t" << setw(8) << "movl" << stack_location(arg2) << ", "
                                     << "%ebx" << endl;
                        asmFile << "\t" << setw(8) << "movl"
                                     << "%ebx"
                                     << ", "
                                     << "(%rax)" << endl;
                    }
                    else
                    {
                        asmFile << "\t" << setw(8) << "movl" << stack_location(arg1) << ", "
                                     << "%eax" << endl;
                        asmFile << "\t" << setw(8) << "cltq" << endl;
                        asmFile << "\t" << setw(8) << "movl" << stack_location(arg2) << ", "
                                     << "%ebx" << endl;
                        asmFile << "\t" << setw(8) << "movl"
                                     << "%ebx"
                                     << ", " << curr_ar->displacement[result] << "(%rbp, %rax, 1)" << endl;
                    }
                }
                else if (op == "=&")
                {
                    // result = &arg1
                    asmFile << "\t" << setw(8) << "leaq" << stack_location(arg1) << ", "
                                 << "%rax" << endl;
                    asmFile << "\t" << setw(8) << "movq"
                                 << "%rax"
                                 << ", " << stack_location(result) << endl;
                }
                else if (op == "=*")
                {
                    // result = *arg1
                    asmFile << "\t" << setw(8) << "movq" << stack_location(arg1) << ", "
                                 << "%rax" << endl;
                    asmFile << "\t" << setw(8) << "movl"
                                 << "(%rax)"
                                 << ", "
                                 << "%eax" << endl;
                    asmFile << "\t" << setw(8) << "movl"
                                 << "%eax"
                                 << ", " << stack_location(result) << endl;
                }
                else if (op == "=-")
                {
                    // result = -arg1
                    asmFile << "\t" << setw(8) << "movl" << stack_location(arg1) << ", "
                                 << "%eax" << endl;
                    asmFile << "\t" << setw(8) << "negl"
                                 << "%eax" << endl;
                    asmFile << "\t" << setw(8) << "movl"
                                 << "%eax"
                                 << ", " << stack_location(result) << endl;
                }
                else if (op == "*=")
                {
                    // *result = arg1
                    asmFile << "\t" << setw(8) << "movl" << stack_location(arg1) << ", "
                                 << "%eax" << endl;
                    asmFile << "\t" << setw(8) << "movq" << stack_location(result) << ", "
                                 << "%rbx" << endl;
                    asmFile << "\t" << setw(8) << "movl"
                                 << "%eax"
                                 << ", "
                                 << "(%rbx)" << endl;
                }
            }
            else
            {
                currentSymbol = globalTable->lookup(quad->result);
                if (currentSymbol->category == Symbol::TEMPORARY)
                {
                    if (currentSymbol->type->type == SymbolType::INT)
                    {
                        glb_inttemp = stoi(quad->arg1);
                    }
                    else if (currentSymbol->type->type == SymbolType::CHAR)
                    {
                        glb_chartemp = get_ascii(quad->arg1);
                    }
                    else if (currentSymbol->type->type == SymbolType::POINTER)
                    {
                        glb_strtemp = ".LC" + quad->arg1;
                    }
                }
                else
                {
                    if (currentSymbol->type->type == SymbolType::INT)
                    {
                        asmFile << "\t" << setw(8) << ".globl" << currentSymbol->name << endl;
                        asmFile << "\t" << setw(8) << ".data" << endl;
                        asmFile << "\t" << setw(8) << ".align" << 4 << endl;
                        asmFile << "\t" << setw(8) << ".type" << currentSymbol->name << ", @object" << endl;
                        asmFile << "\t" << setw(8) << ".size" << currentSymbol->name << ", 4" << endl;
                        asmFile << currentSymbol->name << ":" << endl;
                        asmFile << "\t" << setw(8) << ".long" << glb_inttemp << endl;
                    }
                    else if (currentSymbol->type->type == SymbolType::CHAR)
                    {
                        asmFile << "\t" << setw(8) << ".globl" << currentSymbol->name << endl;
                        asmFile << "\t" << setw(8) << ".data" << endl;
                        asmFile << "\t" << setw(8) << ".type" << currentSymbol->name << ", @object" << endl;
                        asmFile << "\t" << setw(8) << ".size" << currentSymbol->name << ", 1" << endl;
                        asmFile << currentSymbol->name << ":" << endl;
                        asmFile << "\t" << setw(8) << ".byte" << glb_chartemp << endl;
                    }
                    else if (currentSymbol->type->type == SymbolType::POINTER)
                    {
                        asmFile << "\t"
                                     << ".section	.data.rel.local" << endl;
                        asmFile << "\t" << setw(8) << ".align" << 8 << endl;
                        asmFile << "\t" << setw(8) << ".type" << currentSymbol->name << ", @object" << endl;
                        asmFile << "\t" << setw(8) << ".size" << currentSymbol->name << ", 8" << endl;
                        asmFile << currentSymbol->name << ":" << endl;
                        asmFile << "\t" << setw(8) << ".quad" << glb_strtemp << endl;
                    }
                }
            }
        }

        num_of_quad++;
    }

    asmFile.close();
}

int main(int argc, char const *argv[])
{
    in_file = string(argv[1]) + ".c";
    asm_file = string(argv[1]) + ".s";
    tableCount = 0;
    temporaryCount = 0;
    globalTable = new SymbolTable("global");
    currentTable = globalTable;
    cout << left; 

    yyin = fopen(in_file.c_str(), "r");
    yyparse();

    globalTable->update();

    globalTable->print();
    finalBackpatch();
    int ins = 1;
    for (auto it : quadArray)
    {
        cout << setw(4) << ins++ << ": ";
        it->print();
    }
    translate();

    return 0;
}