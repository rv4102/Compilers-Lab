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

%token IDENTIFIERS
%token <int_val> INTEGER_CONSTANT
%token <float_val> FLOATING_CONSTANT
%token <char_val> CHARACTER_CONSTANT
%token <string_val> STRING_LITERAL

%token SQUARE_BRACE_OPEN
%token SQUARE_BRACE_CLOSE
%token PARENTHESIS_OPEN
%token PARENTHESIS_CLOSE
%token CURLY_BRACE_OPEN
%token CURLY_BRACE_CLOSE 
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
%token THREE_DOTS
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

%nonassoc PARENTHESIS_CLOSE
%nonassoc ELSE

%start translation_unit

%%

primary_expression: IDENTIFIERS																										{ printf("primary-expression --> identifier\n"); }
                  | INTEGER_CONSTANT																								{ printf("primary-expression --> integer_constant\n"); }
				  | FLOATING_CONSTANT																								{ printf("primary_expression --> floating_constant\n"); }
				  | CHARACTER_CONSTANT																								{ printf("primary_expression --> character_constant\n"); }
                  | STRING_LITERAL																									{ printf("primary-expression --> string-literal\n"); }
                  | PARENTHESIS_OPEN expression PARENTHESIS_CLOSE																	{ printf("primary-expression --> ( expression )\n"); }
                  ;

argument_expression_list_opt: argument_expression_list																				{ printf("argument-expression-list-opt --> argument-expression-list\n"); }
                            |																										{ printf("argument-expression-list-opt --> epsilon\n"); }
                            ;

postfix_expression: primary_expression																								{ printf("postfix-expression --> primary-expression\n"); }
                  | postfix_expression SQUARE_BRACE_OPEN expression SQUARE_BRACE_CLOSE												{ printf("postfix-expression --> postfix-expression [ expression ]\n"); }
                  | postfix_expression PARENTHESIS_OPEN argument_expression_list_opt PARENTHESIS_CLOSE								{ printf("postfix-expression --> postfix-expression ( argument-expression-list-opt )\n"); }
                  | postfix_expression DOT IDENTIFIERS																				{ printf("postfix-expression --> postfix-expression . identifier\n"); }
                  | postfix_expression ARROW IDENTIFIERS																				{ printf("postfix-expression --> postfix-expression -> identifier\n"); }
                  | postfix_expression INCREMENT																					{ printf("postfix-expression --> postfix-expression ++\n"); }
                  | postfix_expression DECREMENT																					{ printf("postfix-expression --> postfix-expression --\n"); }
                  | PARENTHESIS_OPEN type_name PARENTHESIS_CLOSE CURLY_BRACE_OPEN initializer_list CURLY_BRACE_CLOSE				{ printf("postfix-expression --> ( type-name ) { initializer-list }\n"); }
                  | PARENTHESIS_OPEN type_name PARENTHESIS_CLOSE CURLY_BRACE_OPEN initializer_list COMMA CURLY_BRACE_CLOSE			{ printf("postfix-expression --> ( type-name ) { initializer-list , }\n"); }
                  ;

argument_expression_list: assignment_expression																						{ printf("argument-expression-list --> assignment-expression\n"); }
                        | argument_expression_list COMMA assignment_expression														{ printf("argument-expression-list --> argument-expression-list , assignment-expression\n"); }
                        ;

unary_expression: postfix_expression																								{ printf("unary-expression --> postfix-expression\n"); }
                | INCREMENT unary_expression																						{ printf("unary-expression --> ++ unary-expression\n"); }
                | DECREMENT unary_expression																						{ printf("unary-expression --> -- unary-expression\n"); }
                | unary_operator cast_expression																					{ printf("unary-operator --> cast-expression\n"); }
                | SIZEOF unary_expression																							{ printf("unary-expression --> sizeof unary-expression\n"); }
                | SIZEOF PARENTHESIS_OPEN type_name PARENTHESIS_CLOSE																{ printf("unary-expression --> sizeof ( type-name )\n"); }
                ;

unary_operator: BITWISE_AND																											{ printf("unary-operator --> &\n"); }
              | MULTIPLY																											{ printf("unary-operator --> *\n"); }
              | ADD																													{ printf("unary-operator --> +\n"); }
              | SUBTRACT																											{ printf("unary-operator --> -\n"); }
              | BITWISE_NOR																											{ printf("unary-operator --> ~\n"); }
              | NOT																													{ printf("unary-operator --> !\n"); }
              ;

cast_expression: unary_expression																									{ printf("cast-expression --> unary-expression\n"); }
               | PARENTHESIS_OPEN type_name PARENTHESIS_CLOSE cast_expression														{ printf("cast-expression --> ( type-name ) cast-expression\n"); }
               ;

multiplicative_expression: cast_expression																							{ printf("multiplicative-expression --> cast-expression\n"); }
                         | multiplicative_expression MULTIPLY cast_expression														{ printf("multiplicative-expression --> multiplicative-expression * cast-expression\n"); }
                         | multiplicative_expression DIVIDE cast_expression															{ printf("multiplicative-expression --> multiplicative-expression / cast-expression\n"); }
                         | multiplicative_expression MODULO cast_expression															{ printf("multiplicative-expression --> multiplicative-expression %% cast-expression\n"); }
                         ;

additive_expression: multiplicative_expression																						{ printf("additive-expression --> multiplicative-expression\n"); }
                   | additive_expression ADD multiplicative_expression																{ printf("additive-expression --> additive-expression + multiplicative-expression\n"); }
                   | additive_expression SUBTRACT multiplicative_expression															{ printf("additive-expression --> additive-expression - multiplicative-expression\n"); }
                   ;

shift_expression: additive_expression																								{ printf("shift-expression --> additive-expression\n"); }
                | shift_expression LSHIFT additive_expression																		{ printf("shift-expression --> shift-expression << additive-expression\n"); }
                | shift_expression RSHIFT additive_expression																		{ printf("shift-expression --> shift-expression >> additive-expression\n"); }
                ;

relational_expression: shift_expression																								{ printf("relational-expression --> shift-expression\n"); }
                     | relational_expression LESS_THAN shift_expression																{ printf("relational-expression --> relational-expression < shift-expression\n"); }
                     | relational_expression GREATER_THAN shift_expression															{ printf("relational-expression --> relational-expression > shift-expression\n"); }
                     | relational_expression LESS_THAN_EQUAL shift_expression														{ printf("relational-expression --> relational-expression <= shift-expression\n"); }
                     | relational_expression GREATER_THAN_EQUAL shift_expression													{ printf("relational-expression --> relational-expression >= shift-expression\n"); }
                     ;

equality_expression: relational_expression																							{ printf("equality-expression --> relational-expression\n"); }
                   | equality_expression EQUAL relational_expression																{ printf("equality-expression --> equality-expression == relational-expression\n"); }
                   | equality_expression NOT_EQUAL relational_expression															{ printf("equality-expression --> equality-expression != relational-expression\n"); }
                   ;

and_expression: equality_expression																									{ printf("AND-expression --> equality-expression\n"); }
              | and_expression BITWISE_AND equality_expression																		{ printf("AND-expression --> AND-expression & equality-expression\n"); }
              ;

exclusive_or_expression: and_expression																								{ printf("exclusive-OR-expression --> AND-expression\n"); }
                       | exclusive_or_expression BITWISE_XOR and_expression															{ printf("exclusive-OR-expression --> exclusive-OR-expression ^ AND-expression\n"); }
                       ;

inclusive_or_expression: exclusive_or_expression																					{ printf("inclusive-OR-expression --> exclusive-OR-expression\n"); }
                       | inclusive_or_expression BITWISE_OR exclusive_or_expression													{ printf("inclusive-OR-expression --> inclusive-OR-expression | exclusive-OR-expression\n"); }
                       ;

logical_and_expression: inclusive_or_expression																						{ printf("logical-AND-expression --> inclusive-OR-expression\n"); }
                      | logical_and_expression LOGICAL_AND inclusive_or_expression													{ printf("logical-AND-expression --> logical-AND-expression && inclusive-OR-expression\n"); }
                      ;

logical_or_expression: logical_and_expression																						{ printf("logical-OR-expression --> logical-AND-expression\n"); }
                     | logical_or_expression LOGICAL_OR logical_and_expression														{ printf("logical-OR-expression --> logical_or_expression || logical-AND-expression\n"); }
                     ;

conditional_expression: logical_or_expression																						{ printf("conditional-expression --> logical-OR-expression\n"); }
                      | logical_or_expression QUESTION_MARK expression COLON conditional_expression									{ printf("conditional-expression --> logical-OR-expression ? expression : conditional-expression\n"); }
                      ;

assignment_expression: conditional_expression																						{ printf("assignment-expression --> conditional-expression\n"); }
                     | unary_expression assignment_operator assignment_expression													{ printf("assignment-expression --> unary-expression assignment-operator assignment-expression\n"); }
                     ;

assignment_operator: ASSIGN																											{ printf("assignment-operator --> =\n"); }
                   | MULTIPLY_ASSIGN																								{ printf("assignment-operator --> *=\n"); }
                   | DIVIDE_ASSIGN																									{ printf("assignment-operator --> /=\n"); }
                   | MODULO_ASSIGN																									{ printf("assignment-operator --> %%=\n"); }
                   | ADD_ASSIGN																										{ printf("assignment-operator --> +=\n"); }
                   | SUBTRACT_ASSIGN																								{ printf("assignment-operator --> -=\n"); }
                   | LSHIFT_ASSIGN																									{ printf("assignment-operator --> <<=\n"); }
                   | RSHIFT_ASSIGN																									{ printf("assignment-operator --> >>=\n"); }
                   | AND_ASSIGN																										{ printf("assignment-operator --> &=\n"); }
                   | XOR_ASSIGN																										{ printf("assignment-operator --> ^=\n"); }
                   | OR_ASSIGN																										{ printf("assignment-operator --> |=\n"); }
                   ;

expression: assignment_expression																									{ printf("expression --> assignment-expression\n"); }
          | expression COMMA assignment_expression																					{ printf("expression --> expression , assignment-expression\n"); }
          ;

constant_expression: conditional_expression																							{ printf("constant-expression --> conditional-expression\n"); }
                   ;

declaration: declaration_specifiers init_declarator_list_opt SEMICOLON																{ printf("declaration --> declaration-specifiers init-declarator-list-opt ;\n"); }
           ;

init_declarator_list_opt: init_declarator_list																						{ printf("init-declarator-list-opt --> init-declarator-list\n"); }
                         |																											{ printf("init-declarator-list-opt --> epsilon\n"); }
                         ;

declaration_specifiers: storage_class_specifier declaration_specifiers_opt															{ printf("declaration-specifiers --> storage-class-specifier declaration-specifiers-opt\n"); }
                      | type_specifier declaration_specifiers_opt																	{ printf("declaration-specifiers --> type-specifier declaration-specifiers-opt\n"); }
                      | type_qualifier declaration_specifiers_opt																	{ printf("declaration-specifiers --> type-qualifier declaration-specifiers-opt\n"); }
                      | function_specifier declaration_specifiers_opt																{ printf("declaration-specifiers --> function-specifier declaration-specifiers-opt\n"); }
                      ;

declaration_specifiers_opt: declaration_specifiers																					{ printf("declaration-specifiers-opt --> declaration-specifiers\n"); }
                          |																											{ printf("declaration-specifiers-opt --> epsilon\n"); }
                          ;

init_declarator_list: init_declarator																								{ printf("init-declarator-list --> init-declarator\n"); }
                    | init_declarator_list COMMA init_declarator																	{ printf("init-declarator-list --> init-declarator-list , init-declarator\n"); }
                    ;

init_declarator: declarator																											{ printf("init-declarator --> declarator\n"); }
               | declarator ASSIGN initializer 																						{ printf("init-declarator --> declarator = initializer\n"); }
               ;

storage_class_specifier: EXTERN																										{ printf("storage-class-specifier --> extern\n"); }
                       | STATIC																										{ printf("storage-class-specifier --> static\n"); }
                       | AUTO																										{ printf("storage-class-specifier --> auto\n"); }
                       | REGISTER																									{ printf("storage-class-specifier --> register\n"); }
                       ;

type_specifier: VOID																												{ printf("type-specifier --> void\n"); }
              | CHAR																												{ printf("type-specifier --> char\n"); }
              | SHORT																												{ printf("type-specifier --> short\n"); }
              | INT																													{ printf("type-specifier --> int\n"); }
              | LONG																												{ printf("type-specifier --> long\n"); }
              | FLOAT																												{ printf("type-specifier --> float\n"); }
              | DOUBLE																												{ printf("type-specifier --> double\n"); }
              | SIGNED																												{ printf("type-specifier --> signed\n"); }
              | UNSIGNED																											{ printf("type-specifier --> unsigned\n"); }
              | BOOL																												{ printf("type-specifier --> _Bool\n"); }
              | COMPLEX																												{ printf("type-specifier --> _Complex\n"); }
              | IMAGINARY																											{ printf("type-specifier --> _Imaginary\n"); }
              | enum_specifier																										{ printf("type-specifier --> enum-specifier\n"); }
              ;

specifier_qualifier_list_opt: specifier_qualifier_list																				{ printf("specifier-qualifier-list-opt --> specifier-qualifier-list\n"); }
                            |																										{ printf("specifier-qualifier-list-opt --> epsilon\n"); }
                            ;

specifier_qualifier_list: type_specifier specifier_qualifier_list_opt																{ printf("specifier-qualifier-list --> type-specifier specifier-qualifier-list-opt\n"); }
                        | type_qualifier specifier_qualifier_list_opt																{ printf("specifier-qualifier-list --> type-qualifier specifier-qualifier-list-opt\n"); }
                        ;

identifier_opt: IDENTIFIERS																											{ printf("identifier-opt --> identifier\n"); }
              |																														{ printf("identifier-opt --> epsilon\n"); }
              ;

enum_specifier: ENUM identifier_opt CURLY_BRACE_OPEN enumerator_list CURLY_BRACE_CLOSE												{ printf("enum-specifier --> enum identifier-opt { enumerator-list }\n"); }
              | ENUM identifier_opt CURLY_BRACE_OPEN enumerator_list COMMA CURLY_BRACE_CLOSE										{ printf("enum-specifier --> enum identifier-opt { enumerator-list , }\n"); }
              | ENUM IDENTIFIERS																										{ printf("enum-specifier --> enum identifier\n"); }
              ;

enumerator_list: enumerator																											{ printf("enumerator-list --> enumerator\n"); }
               | enumerator_list COMMA enumerator																					{ printf("enumerator-list --> enumerator-list , enumerator\n"); }
               ;

enumerator: IDENTIFIERS																												{ printf("enumerator --> enumeration-constant\n"); }
          | IDENTIFIERS ASSIGN constant_expression																					{ printf("enumerator --> enumeration-constant = constant-expression\n"); }
          ;

type_qualifier: CONST																												{ printf("type-qualifier --> const\n"); }
              | RESTRICT																											{ printf("type-qualifier --> restrict\n"); }
              | VOLATILE																											{ printf("type-qualifier --> volatile\n"); }
              ;

function_specifier: INLINE																											{ printf("function-specifier --> inline\n"); }
                  ;

declarator: pointer_opt direct_declarator																							{ printf("declarator --> pointer-opt direct-declarator\n"); }
          ;

pointer_opt: pointer																												{ printf("pointer-opt --> pointer\n"); }
           |																														{ printf("pointer-opt --> epsilon\n"); }
           ;

direct_declarator: IDENTIFIERS																										{ printf("direct-declarator --> identifier\n"); }
                 | PARENTHESIS_OPEN declarator PARENTHESIS_CLOSE																	{ printf("direct-declarator --> ( declarator )\n"); }
                 | direct_declarator SQUARE_BRACE_OPEN type_qualifier_list_opt assignment_expression_opt SQUARE_BRACE_CLOSE			{ printf("direct-declarator --> direct_declarator [ type-qualifier-list-opt assignment-expression-opt ]\n"); }
                 | direct_declarator SQUARE_BRACE_OPEN STATIC type_qualifier_list_opt assignment_expression SQUARE_BRACE_CLOSE		{ printf("direct-declarator --> direct_declarator [ static type-qualifier-list-opt assignment-expression ]\n"); }
                 | direct_declarator SQUARE_BRACE_OPEN type_qualifier_list STATIC assignment_expression SQUARE_BRACE_CLOSE			{ printf("direct-declarator --> direct_declarator [ type-qualifier-list static assignment-expression ]\n"); }
                 | direct_declarator SQUARE_BRACE_OPEN type_qualifier_list_opt MULTIPLY SQUARE_BRACE_CLOSE							{ printf("direct-declarator --> direct_declarator [ type-qualifier-list-opt * ]\n"); }
                 | direct_declarator PARENTHESIS_OPEN parameter_type_list PARENTHESIS_CLOSE											{ printf("direct-declarator --> direct_declarator ( parameter-type-list )\n"); }
                 | direct_declarator PARENTHESIS_OPEN identifier_list_opt PARENTHESIS_CLOSE											{ printf("direct-declarator --> direct_declarator ( identifier-list-opt )\n"); }
                 ;

type_qualifier_list_opt: type_qualifier_list																						{ printf("type-qualifier-list-opt --> type-qualifier-list\n"); }
                       |																											{ printf("type-qualifier-list-opt --> epsilon\n"); }
                       ;

assignment_expression_opt: assignment_expression																					{ printf("assignment-expression-opt --> assignment-expression\n"); }
                         |																											{ printf("assignment-expression-opt --> epsilon\n"); }
                         ;

identifier_list_opt: identifier_list																								{ printf("identifier-list-opt --> identifier-list\n"); }
                   |																												{ printf("identifier-list-opt --> epsilon\n"); }
                   ;

pointer: MULTIPLY type_qualifier_list_opt																							{ printf("pointer --> * type-qualifier-list-opt\n"); }
       | MULTIPLY type_qualifier_list_opt pointer																					{ printf("pointer --> * type-qualifier-list-opt pointer\n"); }
       ;

type_qualifier_list: type_qualifier																									{ printf("type-qualifier-list --> type-qualifier\n"); }
                   | type_qualifier_list type_qualifier																				{ printf("type-qualifier-list --> type-qualifier-list type-qualifier\n"); }
                   ;

parameter_type_list: parameter_list																									{ printf("parameter-type-list --> parameter-list\n"); }
                   | parameter_list COMMA THREE_DOTS																				{ printf("parameter-type-list --> parameter-list , ...\n"); }
                   ;

parameter_list: parameter_declaration																								{ printf("parameter-list --> parameter-declaration\n"); }
              | parameter_list COMMA parameter_declaration																			{ printf("parameter-list --> parameter-list , parameter-declaration\n"); }
              ;

parameter_declaration: declaration_specifiers declarator																			{ printf("parameter-declaration --> declaration-specifiers declarator\n"); }
                     | declaration_specifiers																						{ printf("parameter-declaration --> declaration-specifiers\n"); }
                     ;

identifier_list: IDENTIFIERS																											{ printf("identifier-list --> identifier\n"); }
               | identifier_list COMMA IDENTIFIERS																					{ printf("identifier-list --> identifier_list , identifier\n"); }
               ;

type_name: specifier_qualifier_list																									{ printf("type-name --> specifier-qualifier-list\n"); }
         ;

initializer: assignment_expression																									{ printf("initializer --> assignment-expression\n"); }
           | CURLY_BRACE_OPEN initializer_list CURLY_BRACE_CLOSE																	{ printf("initializer --> { initializer-list }\n"); }
           | CURLY_BRACE_OPEN initializer_list COMMA CURLY_BRACE_CLOSE																{ printf("initializer --> { initializer-list , }\n"); }
           ;

initializer_list: designation_opt initializer																						{ printf("initializer-list --> designation-opt initializer\n"); }
                | initializer_list COMMA designation_opt initializer																{ printf("initializer-list --> initializer-list , designation-opt initializer\n"); }
                ;

designation_opt: designation																										{ printf("designation-opt --> designation\n"); }
               |																													{ printf("designation-opt --> epsilon\n"); }
               ;

designation: designator_list ASSIGN																									{ printf("designation --> designator-list =\n"); }
           ;

designator_list: designator																											{ printf("designator-list --> designator\n"); }
               | designator_list designator																							{ printf("designator-list --> designator-list designator\n"); }
               ;

designator: SQUARE_BRACE_OPEN constant_expression SQUARE_BRACE_CLOSE																{ printf("designator --> [ constant-expression ]\n"); }
          | DOT IDENTIFIERS																											{ printf("designator --> . identifier\n"); }
          ;

statement: labeled_statement																										{ printf("statement --> labeled-statement\n"); }
         | compound_statement																										{ printf("statement --> compound-statement\n"); }
         | expression_statement																										{ printf("statement --> expression-statement\n"); }
         | selection_statement																										{ printf("statement --> selection-statement\n"); }
         | iteration_statement																										{ printf("statement --> iteration-statement\n"); }
         | jump_statement																											{ printf("statement --> jump-statement\n"); }
         ;

labeled_statement: IDENTIFIERS COLON statement																						{ printf("labeled-statement --> identifier : statement\n"); }
                 | CASE constant_expression COLON statement																			{ printf("labeled-statement --> case constant-expression : statement\n"); }
                 | DEFAULT COLON statement																							{ printf("labeled-statement --> default : statement\n"); }
                 ;

compound_statement: CURLY_BRACE_OPEN block_item_list_opt CURLY_BRACE_CLOSE															{ printf("compound-statement --> { block-item-list-opt }\n"); }
                  ;

block_item_list_opt: block_item_list																								{ printf("block-item-list-opt --> block-item-list\n"); }
                   |																												{ printf("block-item-list-opt --> epsilon\n"); }
                   ;

block_item_list: block_item																											{ printf("block-item-list --> block-item\n"); }
               | block_item_list block_item																							{ printf("block-item-list --> block-item-list block-item\n"); }
               ;

block_item: declaration																												{ printf("block-item --> declaration\n"); }
          | statement																												{ printf("block-item --> statement\n"); }
          ;

expression_statement: expression_opt SEMICOLON																						{ printf("expression-statement --> expression-opt ;\n"); }
                    ;

expression_opt: expression																											{ printf("expression-opt --> expression\n"); }
              |																														{ printf("expression-opt --> epsilon\n"); }
              ;

selection_statement: IF PARENTHESIS_OPEN expression PARENTHESIS_CLOSE statement														{ printf("selection-statement --> if ( expression ) statement\n"); }
                   | IF PARENTHESIS_OPEN expression PARENTHESIS_CLOSE statement ELSE statement										{ printf("selection-statement --> if ( expression ) statement else statement\n"); }
                   | SWITCH PARENTHESIS_OPEN expression PARENTHESIS_CLOSE statement													{ printf("selection-statement --> switch ( expression ) statement\n"); }
                   ;

iteration_statement: WHILE PARENTHESIS_OPEN expression PARENTHESIS_CLOSE statement													{ printf("iteration-statement --> while ( expression ) statement\n"); }
                   | DO statement WHILE PARENTHESIS_OPEN expression PARENTHESIS_CLOSE SEMICOLON										{ printf("iteration-statement --> do statement while ( expression ) ;\n"); }
                   | FOR PARENTHESIS_OPEN expression_opt SEMICOLON expression_opt SEMICOLON expression_opt PARENTHESIS_CLOSE statement							{ printf("iteration-statement --> for ( expression-opt ; expression-opt ; expression-opt ) statement\n"); }
                   | FOR PARENTHESIS_OPEN  declaration expression_opt SEMICOLON expression_opt PARENTHESIS_CLOSE statement			{ printf("iteration-statement --> for ( declaration expression-opt ; expression-opt ) statement\n"); }
                   ;

jump_statement: GOTO IDENTIFIERS SEMICOLON																							{ printf("jump-statement --> goto identifier ;\n"); }
              | CONTINUE SEMICOLON																									{ printf("jump-statement --> continue ;\n"); }
              | BREAK SEMICOLON																										{ printf("jump-statement --> break ;\n"); }
              | RETURN expression_opt SEMICOLON																						{ printf("jump-statement --> return expression-opt ;\n"); }
              ;

translation_unit: external_declaration																								{ printf("translation-unit --> external-declaration\n"); }
                | translation_unit external_declaration																				{ printf("translation-unit --> translation-unit external-declaration\n"); }
                ;

external_declaration: function_definition																							{ printf("external-declaration --> function-definition\n"); }
                    | declaration																									{ printf("external-declaration --> declaration\n"); }
                    ;

function_definition: declaration_specifiers declarator declaration_list_opt compound_statement										{ printf("function-definition --> declaration-specifiers declarator declaration-list-opt compound-statement\n"); }
                   ;

declaration_list_opt: declaration_list																								{ printf("declaration-list-opt --> declaration-list\n"); }
                    |																												{ printf("declaration-list-opt --> epsilon\n"); }
                    ;

declaration_list: declaration																										{ printf("declaration-list --> declaration\n"); }
                | declaration_list declaration																						{ printf("declaration-list --> declaration-list declaration\n"); }
                ;

%%

void yyerror(char *s) {
    printf("Error occured!      line no.: %d       Error: %s      Unable to parse: %s\n",yylineno, s, yytext);  
}