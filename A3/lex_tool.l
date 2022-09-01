%{
    #define KEYWORD 10
    #define IDENTIFIERS 11
    #define INTEGER_CONSTANT 12
    #define FLOATING_CONSTANT 13
    #define CHARACTER_CONSTANT 15
    #define STRING_LITERAL 16
    #define PUNCTUATORS 17
    #define SINGLE_COMMENT_LINE 18
    #define MULTI_COMMENT_LINE 19
%}

KEYWORD                         "auto"|"enum"|"restrict"|"unsigned"|"break"|"extern"|"return"|"void"|"case"|"float"|"short"|"volatile"|"char"|"float"|"short"|"volatile"|"char"|"for"|"signed"|"while"|"const"|"goto"|"sizeof"|"_Bool"|"continue"|"if"|"static"|"_Complex"|"default"|"inline"|"struct"|"_Imaginary"|"do"|"int"|"switch"|"double"|"long"|"typedef"|"else"|"register"|"union"
DIGIT                           [0-9]
ID_NON_DIGIT                    [a-zA-Z_]
NON_ZERO_DIGIT                  [1-9]

IDENTIFIER                      {ID_NON_DIGIT}({DIGIT}|{ID_NON_DIGIT})*
ENUMERATION_CONSTANT            {IDENTIFIER}

SIGN                            [+-]
DIGIT_SEQUENCE                  {DIGIT}+
INTEGER_CONSTANT                {NON_ZERO_DIGIT}{DIGIT}*|[0]

EXPONENT_PART                   [eE]{SIGN}{DIGIT_SEQUENCE}      
FRACTIONAL_CONSTANT             ({DIGIT_SEQUENCE}?\.{DIGIT_SEQUENCE})|({DIGIT_SEQUENCE}\.)
FLOATING_CONSTANT               ({FRACTIONAL_CONSTANT}({EXPONENT_PART}?))|({DIGIT_SEQUENCE}{EXPONENT_PART})

ESCAPE_SEQUENCE                 "\\'"|"\\""|"\\?"|"\\\"|"\\a"|"\\b"|"\\f"|"\\n"|"\\r"|"\\t"|"\\v"

C_CHAR                          [^\'\n\\]|{ESCAPE_SEQUENCE}
C_CHAR_SEQUENCE                 {C_CHAR}+
CHARACTER_CONSTANT              \'{C_CHAR_SEQUENCE}\'

S_CHAR                          [^\"\n\\]|{ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE                 {S_CHAR}+
STRING_LITERAL                  \"{S_CHAR_SEQUENCE}?\"

PUNCTUATORS                     "["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"

SINGLE_COMMENT_STARTED          "//"
MULTILINE_STARTED               "/*"
MULTILINE_END                   "*/"

WS                              [ \n\t]

%x SINGLE_LINE_COMMENT
%x MULTIPLE_LINE_COMMENT

%%

{KEYWORD}                                   {return KEYWORD;}
{IDENTIFIER}                                {return IDENTIFIERS;}
{INTEGER_CONSTANT}                          {return INTEGER_CONSTANT;}
{FLOATING_CONSTANT}                         {return FLOATING_CONSTANT;}
{CHARACTER_CONSTANT}                        {return CHARACTER_CONSTANT;}
{STRING_LITERAL}                            {return STRING_LITERAL;}
{PUNCTUATORS}                               {return PUNCTUATORS;}

{SINGLE_COMMENT_STARTED}                    {BEGIN(SINGLE_LINE_COMMENT);}
<SINGLE_LINE_COMMENT>.                      {}
<SINGLE_LINE_COMMENT>"\n"                   {BEGIN(INITIAL); return SINGLE_COMMENT_LINE;}

{MULTILINE_STARTED}                         {BEGIN(MULTIPLE_LINE_COMMENT);}
<MULTIPLE_LINE_COMMENT>.                    {}
<MULTIPLE_LINE_COMMENT>"\n"                 {}
<MULTIPLE_LINE_COMMENT>{MULTILINE_END}      {BEGIN(INITIAL); return MULTI_COMMENT_LINE;}

{WS}                                        {}

%%

int yywrap(){
    return 1;
}

