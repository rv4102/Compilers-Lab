%{
    #include "y.tab.h"
%}

%option yylineno

DIGIT                           [0-9]
ID_NON_DIGIT                    [a-zA-Z_]
NON_ZERO_DIGIT                  [1-9]
IDENTIFIERS                     {ID_NON_DIGIT}({DIGIT}|{ID_NON_DIGIT})*
ENUMERATION_CONSTANT            {IDENTIFIERS}
SIGN                            [+-]
DIGIT_SEQUENCE                  {DIGIT}+
INTEGER_CONSTANT                {NON_ZERO_DIGIT}{DIGIT}*|[0]
EXPONENT_PART                   [eE]{SIGN}?{DIGIT_SEQUENCE}      
FRACTIONAL_CONSTANT             ({DIGIT_SEQUENCE}?\.{DIGIT_SEQUENCE})|({DIGIT_SEQUENCE}\.)
FLOATING_CONSTANT               ({FRACTIONAL_CONSTANT}({EXPONENT_PART}?))|({DIGIT_SEQUENCE}{EXPONENT_PART})
ESCAPE_SEQUENCE                 "\\'"|"\\""|"\\?"|"\\\"|"\\a"|"\\b"|"\\f"|"\\n"|"\\r"|"\\t"|"\\v"
C_CHAR                          [^\'\n\\]|{ESCAPE_SEQUENCE}
C_CHAR_SEQUENCE                 {C_CHAR}+
CHARACTER_CONSTANT              \'{C_CHAR_SEQUENCE}\'
S_CHAR                          [^\"\n\\]|{ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE                 {S_CHAR}+
STRING_LITERAL                  \"{S_CHAR_SEQUENCE}?\"
SINGLE_COMMENT_STARTED          "//"
MULTILINE_STARTED               "/*"
MULTILINE_END                   "*/"
WS                              [ \n\t]
%x SINGLE_LINE_COMMENT
%x MULTIPLE_LINE_COMMENT

%%

"auto"                          { return AUTO; }
"break"                         { return BREAK; }
"case"                          { return CASE; }
"char"                          { return CHAR; }
"const"                         { return CONST; }
"continue"                      { return CONTINUE; }
"default"                       { return DEFAULT; }
"do"                            { return DO; }
"double"                        { return DOUBLE; }
"else"                          { return ELSE; }
"enum"                          { return ENUM; }             
"extern"                        { return EXTERN; }
"float"                         { return FLOAT; }
"for"                           { return FOR; }
"goto"                          { return GOTO; }
"if"                            { return IF; }
"inline"                        { return INLINE; }
"int"                           { return INT; }
"long"                          { return LONG; }
"register"                      { return REGISTER; }
"restrict"                      { return RESTRICT; }
"return"                        { return RETURN; }
"short"                         { return SHORT; }
"signed"                        { return SIGNED; }
"sizeof"                        { return SIZEOF; }
"static"                        { return STATIC; }
"struct"                        { return STRUCT; }
"switch"                        { return SWITCH; }
"typedef"                       { return TYPEDEF; }
"union"                         { return UNION; }
"unsigned"                      { return UNSIGNED; }
"void"                          { return VOID; }
"volatile"                      { return VOLATILE; }
"while"                         { return WHILE; }
"_Bool"                         { return BOOL; }
"_Complex"                      { return COMPLEX; }
"_Imaginary"                    { return IMAGINARY; }

{IDENTIFIERS}                               {return IDENTIFIERS;}
{INTEGER_CONSTANT}                          {return INTEGER_CONSTANT;}
{FLOATING_CONSTANT}                         {return FLOATING_CONSTANT;}
{CHARACTER_CONSTANT}                        {return CHARACTER_CONSTANT;}
{STRING_LITERAL}                            {return STRING_LITERAL;}

"["                             { return SQUARE_BRACE_OPEN; }
"]"                             { return SQUARE_BRACE_CLOSE; }
"("                             { return PARENTHESIS_OPEN; }
")"                             { return PARENTHESIS_CLOSE; }
"{"                             { return CURLY_BRACE_OPEN; }
"}"                             { return CURLY_BRACE_CLOSE; }
"."                             { return DOT; }
"->"                            { return ARROW; }
"++"                            { return INCREMENT; }
"--"                            { return DECREMENT; }
"&"                             { return BITWISE_AND; }
"*"                             { return MULTIPLY; }
"+"                             { return ADD; }
"-"                             { return SUBTRACT; }
"~"                             { return BITWISE_NOR; }
"!"                             { return NOT; }
"/"                             { return DIVIDE; }
"%"                             { return MODULO; }
"<<"                            { return LSHIFT; }
">>"                            { return RSHIFT; }
"<"                             { return LESS_THAN; }
">"                             { return GREATER_THAN; }
"<="                            { return LESS_THAN_EQUAL; }
">="                            { return GREATER_THAN_EQUAL; }
"=="                            { return EQUAL; }
"!="                            { return NOT_EQUAL; }
"^"                             { return BITWISE_XOR; }
"|"                             { return BITWISE_OR; }
"&&"                            { return LOGICAL_AND; }
"||"                            { return LOGICAL_OR; }
"?"                             { return QUESTION_MARK; }
":"                             { return COLON; }
";"                             { return SEMICOLON; }
"..."                           { return THREE_DOTS; }
"="                             { return ASSIGN; }
"*="                            { return MULTIPLY_ASSIGN; }
"/="                            { return DIVIDE_ASSIGN; }
"%="                            { return MODULO_ASSIGN; }
"+="                            { return ADD_ASSIGN; }
"-="                            { return SUBTRACT_ASSIGN; }
"<<="                           { return LSHIFT_ASSIGN; }
">>="                           { return RSHIFT_ASSIGN; }
"&="                            { return AND_ASSIGN; }
"^="                            { return XOR_ASSIGN; }
"|="                            { return OR_ASSIGN; }
","                             { return COMMA; }
"#"                             { return HASH; }

{SINGLE_COMMENT_STARTED}                    {BEGIN(SINGLE_LINE_COMMENT);}
<SINGLE_LINE_COMMENT>.                      {}
<SINGLE_LINE_COMMENT>"\n"                   {BEGIN(INITIAL); }
{MULTILINE_STARTED}                         {BEGIN(MULTIPLE_LINE_COMMENT);}
<MULTIPLE_LINE_COMMENT>.                    {}
<MULTIPLE_LINE_COMMENT>"\n"                 {}
<MULTIPLE_LINE_COMMENT>{MULTILINE_END}      {BEGIN(INITIAL); }
{WS}                                        {}

%%