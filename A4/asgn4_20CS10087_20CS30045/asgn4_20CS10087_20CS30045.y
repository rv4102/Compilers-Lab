%{
    #include <stdio.h>
    extern int yylex();
    extern char* yytext;
    extern int yylineno;
    void yyerror(char *s);
%}

%union {
    int int_val;
    float float_val;
    char char_val;
    char *string_val;
}

%token AUTO
%token BREAK
%token CASE
%token CHAR
%token CONST
%token CONTINUE
%token DEFAULT
%token DO
%token DOUBLE
%token ELSE
%token ENUM
%token EXTERN
%token FLOAT
%token FOR
%token GOTO
%token IF
%token INLINE
%token INT
%token LONG
%token REGISTER
%token RESTRICT
%token RETURN
%token SHORT
%token SIGNED
%token SIZEOF
%token STATIC
%token STRUCT
%token SWITCH
%token TYPEDEF
%token UNION
%token UNSIGNED
%token VOID
%token VOLATILE
%token WHILE
%token BOOL
%token COMPLEX
%token IMAGINARY

%token <string_val> IDENTIFIERS
%token <int_val> INTEGER_CONSTANT
%token <float_val> FLOATING_CONSTANT
%token <char_val> CHARACTER_CONSTANT
%token <string_val> STRING_LITERAL

%token LEFT_SQUARE_BRACKET
%token RIGHT_SQUARE_BRACKET
%token LEFT_PARENTHESIS
%token RIGHT_PARENTHESIS
%token LEFT_CURLY_BRACKET
%token RIGHT_CURLY_BRACKET 
%token DOT
%token ARROW
%token INCREMENT
%token DECREMENT
%token BITWISE_AND
%token MULTIPLY
%token ADD
%token SUBTRACT
%token BITWISE_NOR
%token NOT
%token DIVIDE
%token MODULO 
%token LSHIFT
%token RSHIFT
%token LESS_THAN
%token GREATER_THAN
%token LESS_THAN_EQUAL
%token GREATER_THAN_EQUAL
%token EQUAL
%token NOT_EQUAL
%token BITWISE_XOR
%token BITWISE_OR 
%token LOGICAL_AND
%token LOGICAL_OR
%token QUESTION_MARK
%token COLON
%token SEMICOLON
%token ELLIPSIS
%token ASSIGN
%token MULTIPLY_ASSIGN
%token DIVIDE_ASSIGN
%token MODULO_ASSIGN
%token ADD_ASSIGN
%token SUBTRACT_ASSIGN
%token LSHIFT_ASSIGN
%token RSHIFT_ASSIGN
%token AND_ASSIGN
%token XOR_ASSIGN
%token OR_ASSIGN
%token COMMA
%token HASH

%nonassoc RIGHT_PARENTHESIS
%nonassoc ELSE

%start translation_unit

%%

primary_expression: IDENTIFIERS																										{ printf("Line no. %d: primary-expression --> identifier\n",yylineno); }
                  | INTEGER_CONSTANT																								{ printf("Line no. %d: primary-expression --> integer_constant\n",yylineno); }
				  | FLOATING_CONSTANT																								{ printf("Line no. %d: primary_expression --> floating_constant\n",yylineno); }
				  | CHARACTER_CONSTANT																								{ printf("Line no. %d: primary_expression --> character_constant\n",yylineno); }
                  | STRING_LITERAL																									{ printf("Line no. %d: primary-expression --> string-literal\n",yylineno); }
                  | LEFT_PARENTHESIS expression RIGHT_PARENTHESIS																	{ printf("Line no. %d: primary-expression --> ( expression )\n",yylineno); }
                  ;

argument_expression_list_opt: argument_expression_list																				{ printf("Line no. %d: argument-expression-list-opt --> argument-expression-list\n",yylineno); }
                            |																										{ printf("Line no. %d: argument-expression-list-opt --> epsilon\n",yylineno); }
                            ;

postfix_expression: primary_expression																								{ printf("Line no. %d: postfix-expression --> primary-expression\n",yylineno); }
                  | postfix_expression LEFT_SQUARE_BRACKET expression RIGHT_SQUARE_BRACKET												{ printf("Line no. %d: postfix-expression --> postfix-expression [ expression ]\n",yylineno); }
                  | postfix_expression LEFT_PARENTHESIS argument_expression_list_opt RIGHT_PARENTHESIS								{ printf("Line no. %d: postfix-expression --> postfix-expression ( argument-expression-list-opt )\n",yylineno); }
                  | postfix_expression DOT IDENTIFIERS																				{ printf("Line no. %d: postfix-expression --> postfix-expression . identifier\n",yylineno); }
                  | postfix_expression ARROW IDENTIFIERS																				{ printf("Line no. %d: postfix-expression --> postfix-expression -> identifier\n",yylineno); }
                  | postfix_expression INCREMENT																					{ printf("Line no. %d: postfix-expression --> postfix-expression ++\n",yylineno); }
                  | postfix_expression DECREMENT																					{ printf("Line no. %d: postfix-expression --> postfix-expression --\n",yylineno); }
                  | LEFT_PARENTHESIS type_name RIGHT_PARENTHESIS LEFT_CURLY_BRACKET initializer_list RIGHT_CURLY_BRACKET				{ printf("Line no. %d: postfix-expression --> ( type-name ) { initializer-list }\n",yylineno); }
                  | LEFT_PARENTHESIS type_name RIGHT_PARENTHESIS LEFT_CURLY_BRACKET initializer_list COMMA RIGHT_CURLY_BRACKET			{ printf("Line no. %d: postfix-expression --> ( type-name ) { initializer-list , }\n",yylineno); }
                  ;

argument_expression_list: assignment_expression																						{ printf("Line no. %d: argument-expression-list --> assignment-expression\n",yylineno); }
                        | argument_expression_list COMMA assignment_expression														{ printf("Line no. %d: argument-expression-list --> argument-expression-list , assignment-expression\n",yylineno); }
                        ;

unary_expression: postfix_expression																								{ printf("Line no. %d: unary-expression --> postfix-expression\n",yylineno); }
                | INCREMENT unary_expression																						{ printf("Line no. %d: unary-expression --> ++ unary-expression\n",yylineno); }
                | DECREMENT unary_expression																						{ printf("Line no. %d: unary-expression --> -- unary-expression\n",yylineno); }
                | unary_operator cast_expression																					{ printf("Line no. %d: unary-operator --> cast-expression\n",yylineno); }
                | SIZEOF unary_expression																							{ printf("Line no. %d: unary-expression --> sizeof unary-expression\n",yylineno); }
                | SIZEOF LEFT_PARENTHESIS type_name RIGHT_PARENTHESIS																{ printf("Line no. %d: unary-expression --> sizeof ( type-name )\n",yylineno); }
                ;

unary_operator: BITWISE_AND																											{ printf("Line no. %d: unary-operator --> &\n",yylineno); }
              | MULTIPLY																											{ printf("Line no. %d: unary-operator --> *\n",yylineno); }
              | ADD																													{ printf("Line no. %d: unary-operator --> +\n",yylineno); }
              | SUBTRACT																											{ printf("Line no. %d: unary-operator --> -\n",yylineno); }
              | BITWISE_NOR																											{ printf("Line no. %d: unary-operator --> ~\n",yylineno); }
              | NOT																													{ printf("Line no. %d: unary-operator --> !\n",yylineno); }
              ;

cast_expression: unary_expression																									{ printf("Line no. %d: cast-expression --> unary-expression\n",yylineno); }
               | LEFT_PARENTHESIS type_name RIGHT_PARENTHESIS cast_expression														{ printf("Line no. %d: cast-expression --> ( type-name ) cast-expression\n",yylineno); }
               ;

multiplicative_expression: cast_expression																							{ printf("Line no. %d: multiplicative-expression --> cast-expression\n",yylineno); }
                         | multiplicative_expression MULTIPLY cast_expression														{ printf("Line no. %d: multiplicative-expression --> multiplicative-expression * cast-expression\n",yylineno); }
                         | multiplicative_expression DIVIDE cast_expression															{ printf("Line no. %d: multiplicative-expression --> multiplicative-expression / cast-expression\n",yylineno); }
                         | multiplicative_expression MODULO cast_expression															{ printf("Line no. %d: multiplicative-expression --> multiplicative-expression %% cast-expression\n",yylineno); }
                         ;

additive_expression: multiplicative_expression																						{ printf("Line no. %d: additive-expression --> multiplicative-expression\n",yylineno); }
                   | additive_expression ADD multiplicative_expression																{ printf("Line no. %d: additive-expression --> additive-expression + multiplicative-expression\n",yylineno); }
                   | additive_expression SUBTRACT multiplicative_expression															{ printf("Line no. %d: additive-expression --> additive-expression - multiplicative-expression\n",yylineno); }
                   ;

shift_expression: additive_expression																								{ printf("Line no. %d: shift-expression --> additive-expression\n",yylineno); }
                | shift_expression LSHIFT additive_expression																		{ printf("Line no. %d: shift-expression --> shift-expression << additive-expression\n",yylineno); }
                | shift_expression RSHIFT additive_expression																		{ printf("Line no. %d: shift-expression --> shift-expression >> additive-expression\n",yylineno); }
                ;

relational_expression: shift_expression																								{ printf("Line no. %d: relational-expression --> shift-expression\n",yylineno); }
                     | relational_expression LESS_THAN shift_expression																{ printf("Line no. %d: relational-expression --> relational-expression < shift-expression\n",yylineno); }
                     | relational_expression GREATER_THAN shift_expression															{ printf("Line no. %d: relational-expression --> relational-expression > shift-expression\n",yylineno); }
                     | relational_expression LESS_THAN_EQUAL shift_expression														{ printf("Line no. %d: relational-expression --> relational-expression <= shift-expression\n",yylineno); }
                     | relational_expression GREATER_THAN_EQUAL shift_expression													{ printf("Line no. %d: relational-expression --> relational-expression >= shift-expression\n",yylineno); }
                     ;

equality_expression: relational_expression																							{ printf("Line no. %d: equality-expression --> relational-expression\n",yylineno); }
                   | equality_expression EQUAL relational_expression																{ printf("Line no. %d: equality-expression --> equality-expression == relational-expression\n",yylineno); }
                   | equality_expression NOT_EQUAL relational_expression															{ printf("Line no. %d: equality-expression --> equality-expression != relational-expression\n",yylineno); }
                   ;

and_expression: equality_expression																									{ printf("Line no. %d: AND-expression --> equality-expression\n",yylineno); }
              | and_expression BITWISE_AND equality_expression																		{ printf("Line no. %d: AND-expression --> AND-expression & equality-expression\n",yylineno); }
              ;

exclusive_or_expression: and_expression																								{ printf("Line no. %d: exclusive-OR-expression --> AND-expression\n",yylineno); }
                       | exclusive_or_expression BITWISE_XOR and_expression															{ printf("Line no. %d: exclusive-OR-expression --> exclusive-OR-expression ^ AND-expression\n",yylineno); }
                       ;

inclusive_or_expression: exclusive_or_expression																					{ printf("Line no. %d: inclusive-OR-expression --> exclusive-OR-expression\n",yylineno); }
                       | inclusive_or_expression BITWISE_OR exclusive_or_expression													{ printf("Line no. %d: inclusive-OR-expression --> inclusive-OR-expression | exclusive-OR-expression\n",yylineno); }
                       ;

logical_and_expression: inclusive_or_expression																						{ printf("Line no. %d: logical-AND-expression --> inclusive-OR-expression\n",yylineno); }
                      | logical_and_expression LOGICAL_AND inclusive_or_expression													{ printf("Line no. %d: logical-AND-expression --> logical-AND-expression && inclusive-OR-expression\n",yylineno); }
                      ;

logical_or_expression: logical_and_expression																						{ printf("Line no. %d: logical-OR-expression --> logical-AND-expression\n",yylineno); }
                     | logical_or_expression LOGICAL_OR logical_and_expression														{ printf("Line no. %d: logical-OR-expression --> logical_or_expression || logical-AND-expression\n",yylineno); }
                     ;

conditional_expression: logical_or_expression																						{ printf("Line no. %d: conditional-expression --> logical-OR-expression\n",yylineno); }
                      | logical_or_expression QUESTION_MARK expression COLON conditional_expression									{ printf("Line no. %d: conditional-expression --> logical-OR-expression ? expression : conditional-expression\n",yylineno); }
                      ;

assignment_expression: conditional_expression																						{ printf("Line no. %d: assignment-expression --> conditional-expression\n",yylineno); }
                     | unary_expression assignment_operator assignment_expression													{ printf("Line no. %d: assignment-expression --> unary-expression assignment-operator assignment-expression\n",yylineno); }
                     ;

assignment_operator: ASSIGN																											{ printf("Line no. %d: assignment-operator --> =\n",yylineno); }
                   | MULTIPLY_ASSIGN																								{ printf("Line no. %d: assignment-operator --> *=\n",yylineno); }
                   | DIVIDE_ASSIGN																									{ printf("Line no. %d: assignment-operator --> /=\n",yylineno); }
                   | MODULO_ASSIGN																									{ printf("Line no. %d: assignment-operator --> %%=\n",yylineno); }
                   | ADD_ASSIGN																										{ printf("Line no. %d: assignment-operator --> +=\n",yylineno); }
                   | SUBTRACT_ASSIGN																								{ printf("Line no. %d: assignment-operator --> -=\n",yylineno); }
                   | LSHIFT_ASSIGN																									{ printf("Line no. %d: assignment-operator --> <<=\n",yylineno); }
                   | RSHIFT_ASSIGN																									{ printf("Line no. %d: assignment-operator --> >>=\n",yylineno); }
                   | AND_ASSIGN																										{ printf("Line no. %d: assignment-operator --> &=\n",yylineno); }
                   | XOR_ASSIGN																										{ printf("Line no. %d: assignment-operator --> ^=\n",yylineno); }
                   | OR_ASSIGN																										{ printf("Line no. %d: assignment-operator --> |=\n",yylineno); }
                   ;

expression: assignment_expression																									{ printf("Line no. %d: expression --> assignment-expression\n",yylineno); }
          | expression COMMA assignment_expression																					{ printf("Line no. %d: expression --> expression , assignment-expression\n",yylineno); }
          ;

constant_expression: conditional_expression																							{ printf("Line no. %d: constant-expression --> conditional-expression\n",yylineno); }
                   ;

declaration: declaration_specifiers init_declarator_list_opt SEMICOLON																{ printf("Line no. %d: declaration --> declaration-specifiers init-declarator-list-opt ;\n",yylineno); }
           ;

init_declarator_list_opt: init_declarator_list																						{ printf("Line no. %d: init-declarator-list-opt --> init-declarator-list\n",yylineno); }
                         |																											{ printf("Line no. %d: init-declarator-list-opt --> epsilon\n",yylineno); }
                         ;

declaration_specifiers: storage_class_specifier declaration_specifiers_opt															{ printf("Line no. %d: declaration-specifiers --> storage-class-specifier declaration-specifiers-opt\n",yylineno); }
                      | type_specifier declaration_specifiers_opt																	{ printf("Line no. %d: declaration-specifiers --> type-specifier declaration-specifiers-opt\n",yylineno); }
                      | type_qualifier declaration_specifiers_opt																	{ printf("Line no. %d: declaration-specifiers --> type-qualifier declaration-specifiers-opt\n",yylineno); }
                      | function_specifier declaration_specifiers_opt																{ printf("Line no. %d: declaration-specifiers --> function-specifier declaration-specifiers-opt\n",yylineno); }
                      ;

declaration_specifiers_opt: declaration_specifiers																					{ printf("Line no. %d: declaration-specifiers-opt --> declaration-specifiers\n",yylineno); }
                          |																											{ printf("Line no. %d: declaration-specifiers-opt --> epsilon\n",yylineno); }
                          ;

init_declarator_list: init_declarator																								{ printf("Line no. %d: init-declarator-list --> init-declarator\n",yylineno); }
                    | init_declarator_list COMMA init_declarator																	{ printf("Line no. %d: init-declarator-list --> init-declarator-list , init-declarator\n",yylineno); }
                    ;

init_declarator: declarator																											{ printf("Line no. %d: init-declarator --> declarator\n",yylineno); }
               | declarator ASSIGN initializer 																						{ printf("Line no. %d: init-declarator --> declarator = initializer\n",yylineno); }
               ;

storage_class_specifier: EXTERN																										{ printf("Line no. %d: storage-class-specifier --> extern\n",yylineno); }
                       | STATIC																										{ printf("Line no. %d: storage-class-specifier --> static\n",yylineno); }
                       | AUTO																										{ printf("Line no. %d: storage-class-specifier --> auto\n",yylineno); }
                       | REGISTER																									{ printf("Line no. %d: storage-class-specifier --> register\n",yylineno); }
                       ;

type_specifier: VOID																												{ printf("Line no. %d: type-specifier --> void\n",yylineno); }
              | CHAR																												{ printf("Line no. %d: type-specifier --> char\n",yylineno); }
              | SHORT																												{ printf("Line no. %d: type-specifier --> short\n",yylineno); }
              | INT																													{ printf("Line no. %d: type-specifier --> int\n",yylineno); }
              | LONG																												{ printf("Line no. %d: type-specifier --> long\n",yylineno); }
              | FLOAT																												{ printf("Line no. %d: type-specifier --> float\n",yylineno); }
              | DOUBLE																												{ printf("Line no. %d: type-specifier --> double\n",yylineno); }
              | SIGNED																												{ printf("Line no. %d: type-specifier --> signed\n",yylineno); }
              | UNSIGNED																											{ printf("Line no. %d: type-specifier --> unsigned\n",yylineno); }
              | BOOL																												{ printf("Line no. %d: type-specifier --> _Bool\n",yylineno); }
              | COMPLEX																												{ printf("Line no. %d: type-specifier --> _Complex\n",yylineno); }
              | IMAGINARY																											{ printf("Line no. %d: type-specifier --> _Imaginary\n",yylineno); }
              | enum_specifier																										{ printf("Line no. %d: type-specifier --> enum-specifier\n",yylineno); }
              ;

specifier_qualifier_list_opt: specifier_qualifier_list																				{ printf("Line no. %d: specifier-qualifier-list-opt --> specifier-qualifier-list\n",yylineno); }
                            |																										{ printf("Line no. %d: specifier-qualifier-list-opt --> epsilon\n",yylineno); }
                            ;

specifier_qualifier_list: type_specifier specifier_qualifier_list_opt																{ printf("Line no. %d: specifier-qualifier-list --> type-specifier specifier-qualifier-list-opt\n",yylineno); }
                        | type_qualifier specifier_qualifier_list_opt																{ printf("Line no. %d: specifier-qualifier-list --> type-qualifier specifier-qualifier-list-opt\n",yylineno); }
                        ;

identifier_opt: IDENTIFIERS																											{ printf("Line no. %d: identifier-opt --> identifier\n",yylineno); }
              |																														{ printf("Line no. %d: identifier-opt --> epsilon\n",yylineno); }
              ;

enum_specifier: ENUM identifier_opt LEFT_CURLY_BRACKET enumerator_list RIGHT_CURLY_BRACKET												{ printf("Line no. %d: enum-specifier --> enum identifier-opt { enumerator-list }\n",yylineno); }
              | ENUM identifier_opt LEFT_CURLY_BRACKET enumerator_list COMMA RIGHT_CURLY_BRACKET										{ printf("Line no. %d: enum-specifier --> enum identifier-opt { enumerator-list , }\n",yylineno); }
              | ENUM IDENTIFIERS																										{ printf("Line no. %d: enum-specifier --> enum identifier\n",yylineno); }
              ;

enumerator_list: enumerator																											{ printf("Line no. %d: enumerator-list --> enumerator\n",yylineno); }
               | enumerator_list COMMA enumerator																					{ printf("Line no. %d: enumerator-list --> enumerator-list , enumerator\n",yylineno); }
               ;

enumerator: IDENTIFIERS																												{ printf("Line no. %d: enumerator --> enumeration-constant\n",yylineno); }
          | IDENTIFIERS ASSIGN constant_expression																					{ printf("Line no. %d: enumerator --> enumeration-constant = constant-expression\n",yylineno); }
          ;

type_qualifier: CONST																												{ printf("Line no. %d: type-qualifier --> const\n",yylineno); }
              | RESTRICT																											{ printf("Line no. %d: type-qualifier --> restrict\n",yylineno); }
              | VOLATILE																											{ printf("Line no. %d: type-qualifier --> volatile\n",yylineno); }
              ;

function_specifier: INLINE																											{ printf("Line no. %d: function-specifier --> inline\n",yylineno); }
                  ;

declarator: pointer_opt direct_declarator																							{ printf("Line no. %d: declarator --> pointer-opt direct-declarator\n",yylineno); }
          ;

pointer_opt: pointer																												{ printf("Line no. %d: pointer-opt --> pointer\n",yylineno); }
           |																														{ printf("Line no. %d: pointer-opt --> epsilon\n",yylineno); }
           ;

direct_declarator: IDENTIFIERS																										{ printf("Line no. %d: direct-declarator --> identifier\n",yylineno); }
                 | LEFT_PARENTHESIS declarator RIGHT_PARENTHESIS																	{ printf("Line no. %d: direct-declarator --> ( declarator )\n",yylineno); }
                 | direct_declarator LEFT_SQUARE_BRACKET type_qualifier_list_opt assignment_expression_opt RIGHT_SQUARE_BRACKET			{ printf("Line no. %d: direct-declarator --> direct_declarator [ type-qualifier-list-opt assignment-expression-opt ]\n",yylineno); }
                 | direct_declarator LEFT_SQUARE_BRACKET STATIC type_qualifier_list_opt assignment_expression RIGHT_SQUARE_BRACKET		{ printf("Line no. %d: direct-declarator --> direct_declarator [ static type-qualifier-list-opt assignment-expression ]\n",yylineno); }
                 | direct_declarator LEFT_SQUARE_BRACKET type_qualifier_list STATIC assignment_expression RIGHT_SQUARE_BRACKET			{ printf("Line no. %d: direct-declarator --> direct_declarator [ type-qualifier-list static assignment-expression ]\n",yylineno); }
                 | direct_declarator LEFT_SQUARE_BRACKET type_qualifier_list_opt MULTIPLY RIGHT_SQUARE_BRACKET							{ printf("Line no. %d: direct-declarator --> direct_declarator [ type-qualifier-list-opt * ]\n",yylineno); }
                 | direct_declarator LEFT_PARENTHESIS parameter_type_list RIGHT_PARENTHESIS											{ printf("Line no. %d: direct-declarator --> direct_declarator ( parameter-type-list )\n",yylineno); }
                 | direct_declarator LEFT_PARENTHESIS identifier_list_opt RIGHT_PARENTHESIS											{ printf("Line no. %d: direct-declarator --> direct_declarator ( identifier-list-opt )\n",yylineno); }
                 ;

type_qualifier_list_opt: type_qualifier_list																						{ printf("Line no. %d: type-qualifier-list-opt --> type-qualifier-list\n",yylineno); }
                       |																											{ printf("Line no. %d: type-qualifier-list-opt --> epsilon\n",yylineno); }
                       ;

assignment_expression_opt: assignment_expression																					{ printf("Line no. %d: assignment-expression-opt --> assignment-expression\n",yylineno); }
                         |																											{ printf("Line no. %d: assignment-expression-opt --> epsilon\n",yylineno); }
                         ;

identifier_list_opt: identifier_list																								{ printf("Line no. %d: identifier-list-opt --> identifier-list\n",yylineno); }
                   |																												{ printf("Line no. %d: identifier-list-opt --> epsilon\n",yylineno); }
                   ;

pointer: MULTIPLY type_qualifier_list_opt																							{ printf("Line no. %d: pointer --> * type-qualifier-list-opt\n",yylineno); }
       | MULTIPLY type_qualifier_list_opt pointer																					{ printf("Line no. %d: pointer --> * type-qualifier-list-opt pointer\n",yylineno); }
       ;

type_qualifier_list: type_qualifier																									{ printf("Line no. %d: type-qualifier-list --> type-qualifier\n",yylineno); }
                   | type_qualifier_list type_qualifier																				{ printf("Line no. %d: type-qualifier-list --> type-qualifier-list type-qualifier\n",yylineno); }
                   ;

parameter_type_list: parameter_list																									{ printf("Line no. %d: parameter-type-list --> parameter-list\n",yylineno); }
                   | parameter_list COMMA ELLIPSIS																				{ printf("Line no. %d: parameter-type-list --> parameter-list , ...\n",yylineno); }
                   ;

parameter_list: parameter_declaration																								{ printf("Line no. %d: parameter-list --> parameter-declaration\n",yylineno); }
              | parameter_list COMMA parameter_declaration																			{ printf("Line no. %d: parameter-list --> parameter-list , parameter-declaration\n",yylineno); }
              ;

parameter_declaration: declaration_specifiers declarator																			{ printf("Line no. %d: parameter-declaration --> declaration-specifiers declarator\n",yylineno); }
                     | declaration_specifiers																						{ printf("Line no. %d: parameter-declaration --> declaration-specifiers\n",yylineno); }
                     ;

identifier_list: IDENTIFIERS																											{ printf("Line no. %d: identifier-list --> identifier\n",yylineno); }
               | identifier_list COMMA IDENTIFIERS																					{ printf("Line no. %d: identifier-list --> identifier_list , identifier\n",yylineno); }
               ;

type_name: specifier_qualifier_list																									{ printf("Line no. %d: type-name --> specifier-qualifier-list\n",yylineno); }
         ;

initializer: assignment_expression																									{ printf("Line no. %d: initializer --> assignment-expression\n",yylineno); }
           | LEFT_CURLY_BRACKET initializer_list RIGHT_CURLY_BRACKET																	{ printf("Line no. %d: initializer --> { initializer-list }\n",yylineno); }
           | LEFT_CURLY_BRACKET initializer_list COMMA RIGHT_CURLY_BRACKET																{ printf("Line no. %d: initializer --> { initializer-list , }\n",yylineno); }
           ;

initializer_list: designation_opt initializer																						{ printf("Line no. %d: initializer-list --> designation-opt initializer\n",yylineno); }
                | initializer_list COMMA designation_opt initializer																{ printf("Line no. %d: initializer-list --> initializer-list , designation-opt initializer\n",yylineno); }
                ;

designation_opt: designation																										{ printf("Line no. %d: designation-opt --> designation\n",yylineno); }
               |																													{ printf("Line no. %d: designation-opt --> epsilon\n",yylineno); }
               ;

designation: designator_list ASSIGN																									{ printf("Line no. %d: designation --> designator-list =\n",yylineno); }
           ;

designator_list: designator																											{ printf("Line no. %d: designator-list --> designator\n",yylineno); }
               | designator_list designator																							{ printf("Line no. %d: designator-list --> designator-list designator\n",yylineno); }
               ;

designator: LEFT_SQUARE_BRACKET constant_expression RIGHT_SQUARE_BRACKET																{ printf("Line no. %d: designator --> [ constant-expression ]\n",yylineno); }
          | DOT IDENTIFIERS																											{ printf("Line no. %d: designator --> . identifier\n",yylineno); }
          ;

statement: labeled_statement																										{ printf("Line no. %d: statement --> labeled-statement\n",yylineno); }
         | compound_statement																										{ printf("Line no. %d: statement --> compound-statement\n",yylineno); }
         | expression_statement																										{ printf("Line no. %d: statement --> expression-statement\n",yylineno); }
         | selection_statement																										{ printf("Line no. %d: statement --> selection-statement\n",yylineno); }
         | iteration_statement																										{ printf("Line no. %d: statement --> iteration-statement\n",yylineno); }
         | jump_statement																											{ printf("Line no. %d: statement --> jump-statement\n",yylineno); }
         ;

labeled_statement: IDENTIFIERS COLON statement																						{ printf("Line no. %d: labeled-statement --> identifier : statement\n",yylineno); }
                 | CASE constant_expression COLON statement																			{ printf("Line no. %d: labeled-statement --> case constant-expression : statement\n",yylineno); }
                 | DEFAULT COLON statement																							{ printf("Line no. %d: labeled-statement --> default : statement\n",yylineno); }
                 ;

compound_statement: LEFT_CURLY_BRACKET block_item_list_opt RIGHT_CURLY_BRACKET															{ printf("Line no. %d: compound-statement --> { block-item-list-opt }\n",yylineno); }
                  ;

block_item_list_opt: block_item_list																								{ printf("Line no. %d: block-item-list-opt --> block-item-list\n",yylineno); }
                   |																												{ printf("Line no. %d: block-item-list-opt --> epsilon\n",yylineno); }
                   ;

block_item_list: block_item																											{ printf("Line no. %d: block-item-list --> block-item\n",yylineno); }
               | block_item_list block_item																							{ printf("Line no. %d: block-item-list --> block-item-list block-item\n",yylineno); }
               ;

block_item: declaration																												{ printf("Line no. %d: block-item --> declaration\n",yylineno); }
          | statement																												{ printf("Line no. %d: block-item --> statement\n",yylineno); }
          ;

expression_statement: expression_opt SEMICOLON																						{ printf("Line no. %d: expression-statement --> expression-opt ;\n",yylineno); }
                    ;

expression_opt: expression																											{ printf("Line no. %d: expression-opt --> expression\n",yylineno); }
              |																														{ printf("Line no. %d: expression-opt --> epsilon\n",yylineno); }
              ;

selection_statement: IF LEFT_PARENTHESIS expression RIGHT_PARENTHESIS statement														{ printf("Line no. %d: selection-statement --> if ( expression ) statement\n",yylineno); }
                   | IF LEFT_PARENTHESIS expression RIGHT_PARENTHESIS statement ELSE statement										{ printf("Line no. %d: selection-statement --> if ( expression ) statement else statement\n",yylineno); }
                   | SWITCH LEFT_PARENTHESIS expression RIGHT_PARENTHESIS statement													{ printf("Line no. %d: selection-statement --> switch ( expression ) statement\n",yylineno); }
                   ;

iteration_statement: WHILE LEFT_PARENTHESIS expression RIGHT_PARENTHESIS statement													{ printf("Line no. %d: iteration-statement --> while ( expression ) statement\n",yylineno); }
                   | DO statement WHILE LEFT_PARENTHESIS expression RIGHT_PARENTHESIS SEMICOLON										{ printf("Line no. %d: iteration-statement --> do statement while ( expression ) ;\n",yylineno); }
                   | FOR LEFT_PARENTHESIS expression_opt SEMICOLON expression_opt SEMICOLON expression_opt RIGHT_PARENTHESIS statement							{ printf("Line no. %d: iteration-statement --> for ( expression-opt ; expression-opt ; expression-opt ) statement\n",yylineno); }
                   | FOR LEFT_PARENTHESIS  declaration expression_opt SEMICOLON expression_opt RIGHT_PARENTHESIS statement			{ printf("Line no. %d: iteration-statement --> for ( declaration expression-opt ; expression-opt ) statement\n",yylineno); }
                   ;

jump_statement: GOTO IDENTIFIERS SEMICOLON																							{ printf("Line no. %d: jump-statement --> goto identifier ;\n",yylineno); }
              | CONTINUE SEMICOLON																									{ printf("Line no. %d: jump-statement --> continue ;\n",yylineno); }
              | BREAK SEMICOLON																										{ printf("Line no. %d: jump-statement --> break ;\n",yylineno); }
              | RETURN expression_opt SEMICOLON																						{ printf("Line no. %d: jump-statement --> return expression-opt ;\n",yylineno); }
              ;

translation_unit: external_declaration																								{ printf("Line no. %d: translation-unit --> external-declaration\n",yylineno); }
                | translation_unit external_declaration																				{ printf("Line no. %d: translation-unit --> translation-unit external-declaration\n",yylineno); }
                ;

external_declaration: function_definition																							{ printf("Line no. %d: external-declaration --> function-definition\n",yylineno); }
                    | declaration																									{ printf("Line no. %d: external-declaration --> declaration\n",yylineno); }
                    ;

function_definition: declaration_specifiers declarator declaration_list_opt compound_statement										{ printf("Line no. %d: function-definition --> declaration-specifiers declarator declaration-list-opt compound-statement\n",yylineno); }
                   ;

declaration_list_opt: declaration_list																								{ printf("Line no. %d: declaration-list-opt --> declaration-list\n",yylineno); }
                    |																												{ printf("Line no. %d: declaration-list-opt --> epsilon\n",yylineno); }
                    ;

declaration_list: declaration																										{ printf("Line no. %d: declaration-list --> declaration\n",yylineno); }
                | declaration_list declaration																						{ printf("Line no. %d: declaration-list --> declaration-list declaration\n",yylineno); }
                ;

%%

void yyerror(char *s) {
    printf("Error occured!      line no.: %d       Error: %s      Unable to parse: %s\n",yylineno, s, yytext);  
    printf("Parsing process terminated due to error.");
}