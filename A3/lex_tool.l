%{
    #define KEYWORD 10
    #define IDENTIFIERS 11
    #define INTEGER_CONSTANT 12
    #define FLOATING_CONSTANT 13
    #define ENUMERATION_CONSTANT 14
    #define CHARACTER_CONSTANT 15
    #define STRING_LITERAL 16
    #define PUNCTUATORS 17
    #define COMMENT 18
%}

KEYWORD          "auto"|"enum"|"restrict"|"unsigned"|"break"|"extern"|"return"|"void"|"case"|"float"|"short"|"volatile"|"char"|"float"|"short"|"volatile"|"char"|"for"|"signed"|"while"|"const"|"goto"|"sizeof"|"_Bool"|"continue"|"if"|"static"|"_Complex"|"default"|"inline"|"struct"|"_Imaginary"|"do"|"int"|"switch"|"double"|"long"|"typedef"|"else"|"register"|"union"
DIGIT            [0-9]
ID_NON_DIGIT     [a-zA-Z_]
IDENTIFIER       {ID_NON_DIGIT}({DIGIT}|{ID_NON_DIGIT})*
NON_ZERO_DIGIT   [1-9]
ENUMERATION_CONSTANT {IDENTIFIER}
SIGN            [+-]
DIGIT_SEQUENCE  {DIGIT}+
EXPONENT_PART   [eE]{SIGN}{DIGIT_SEQUENCE}      
FRACTIONAL_CONSTANT  ({DIGIT_SEQUENCE}?\.{DIGIT_SEQUENCE})|({DIGIT_SEQUENCE}\.)
FLOATING_CONSTANT    ({FRACTIONAL_CONSTANT}({EXPONENT_PART}?)) | ({DIGIT_SEQUENCE}{EXPONENT_PART})
ESCAPE_SEQUENCE      "\\'"|"\\""|"\\?"|"\\\"|"\\a"|"\\b"|"\\f"|"\\n"|"\\r"|"\\t"|"\\v"
C_CHAR               [^\'\n\\] | {ESCAPE_SEQUENCE}
C_CHAR_SEQUENCE      {C_CHAR}+

S_CHAR              [^\"\n\\] | {ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE     {S_CHAR}+
STRING_LITERAL      \"{S_CHAR_SEQUENCE}?\"

PUNCTUATORS         "[" | "]" | "(" | ")" | "{" | "}" | "." | "->" | "++" | "--" | "&" | "*" | "+" | "-" | "~" | "!" | "/" | "%" | "<<" | ">>" | "<" | ">" | "<=" | ">=" | "==" | "!=" | "^" | "|" | "&&" | "||" | "?" | ":" | ";" | "..." | "=" | "*=" | "/=" | "%=" | "+=" | "-=" | "<<=" | ">>=" | "&=" | "^=" | "|=" | "," | "#"


