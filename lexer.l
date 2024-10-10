%{
	#include<stdio.h>
	#include"y.tab.h"
	int curlycount=0, index_new=0, index_new1=0;
    #define TABLE_SIZE 100
    
    struct SymbolTable{
    	char symbol_name[100];
    	char symbol_type[100];
    	char array_dimensions[100];
    	char class[100];
    	char pdl[100];
    	int line_number;
    	char parameters[100];
    	int nesting_level;
    }ST[TABLE_SIZE];
    
    struct ConstantTable{
    	char constant_name[100];
    	char constant_type[100];
    }CT[TABLE_SIZE];
    
    struct error_table{
		char error_name[20];
		int line_number;
		char error_type[20];
	}error_table[100];
	
	int error_count=0;
    
    int searchSymbolTable(char *name){
    	for(int i=0;i<TABLE_SIZE;i++){
    		if(strcmp(ST[i].symbol_name, name)==0){
    			return 1;
    		}
    	}
    	return 0;	
    }
    
    void insertSymbolTable(char *name, char *type){
    	if(searchSymbolTable(name)==1)
    	return;
    	else{
    		if(index_new>=TABLE_SIZE){
    			printf("Error: Symbol Table is full\n");
    			return;
    		}
    		else{
    			strcpy(ST[index_new].symbol_name,name);
    			strcpy(ST[index_new].symbol_type,type);
    			strcpy(ST[index_new].class, "");
    			strcpy(ST[index_new].array_dimensions, "No dimensions");
    			strcpy(ST[index_new].pdl, "No PDL");
    			ST[index_new].line_number=yylineno;
    			strcpy(ST[index_new].parameters, "No parameters");
    			ST[index_new].nesting_level=curlycount;
    			index_new++;
    		}
    	}
    }
    
    void insertSymbolClass(char *name, char *symbol_class){
    	for(int i=0;i<index_new;i++){
    		if(strcmp(ST[i].symbol_name, name)==0){
    			strcpy(ST[i].class, symbol_class);
    			break;
    		}
    	}
    }
    
    void insertSymbolPDL(char *name, char *symbol_PDL){
    	for(int i=0;i<index_new;i++){
    		if(strcmp(ST[i].symbol_name, name)==0){
    			strcpy(ST[i].pdl, symbol_PDL);
    			break;
    		}
    	}
    }
    
    void insertSymbolParameter(char *name, char *parameter){
    	for(int i=0;i<index_new;i++){
    		if(strcmp(ST[i].symbol_name, name)==0){
    			strcpy(ST[i].parameters, parameter);
    			break;
    		}
    	}
    }
    
    void insertSymbolDimension(char *name, char *dimension){
    	for(int i=0;i<index_new;i++){
    		if(strcmp(ST[i].symbol_name, name)==0){
    			strcpy(ST[i].array_dimensions, dimension);
    			break;
    		}
    	}
    }
    
    void printSymbolTable(){
    	printf("| %10s | %10s | %10s | %12s | %10s | %10s | %10s | %10s |\n", "SYMBOL NAME", "TYPE", "CLASS","DIMENSIONS","LINE", "PARAMETERS","PDL","NESTING_LEVEL");
    	for(int i=0;i<index_new;i++){
    		 printf("| %11s | %10s | %10s | %10s |        %d | %10s | %10s | %d |\n", ST[i].symbol_name, ST[i].symbol_type, ST[i].class,ST[i].array_dimensions,ST[i].line_number, ST[i].parameters, ST[i].pdl, ST[i].nesting_level);
    	}
    }
    
    int searchConstantTable(char *name){
    	for(int i=0;i<TABLE_SIZE;i++){
    		if(strcmp(CT[i].constant_name, name)==0){
    			return 1;
    		}
    	}
    	return 0;
    }
    
    void insertConstantTable(char *name, char *type){
    	if(searchConstantTable(name)==1)
    	return;
    	else{
    		if(index_new1>=TABLE_SIZE){
    			printf("Error: Constant Table is full\n");
    			return;
    		}
    		else{
    			strcpy(CT[index_new1].constant_name,name);
    			strcpy(CT[index_new1].constant_type, type);
    			index_new1++;
    		}
    	}
    }
    
    void printConstantTable(){
    	printf("| %10s | %10s |\n", "CONSTANT NAME", "CONSTANT TYPE");
    	for(int i=0;i<index_new1;i++){
    		printf("| %10s | %10s |\n", CT[i].constant_name, CT[i].constant_type);
    	}
    }
    
    void printErrorTable(){
	printf("| %10s | %10s | %10s |\n", "ERROR", "LINE", "TYPE");
	for(int i=0;i<error_count;i++){
		printf("| %10s |  %d  | %10s |\n", error_table[i].error_name, error_table[i].line_number, error_table[i].error_type);
	} 	
    }
%}

%%
"//"[^\n]*		{}
"int"			{insertSymbolTable(yytext,"Keyword");return INT;}
"main"			{insertSymbolTable(yytext,"Identifier");return MAIN;}
"printf"		{insertSymbolTable(yytext,"Keyword");return PRINTF;}
"scanf"			{insertSymbolTable(yytext,"Keyword");return SCANF;}
"while"			{insertSymbolTable(yytext,"Keyword");return WHILE;}
"return"                {insertSymbolTable(yytext,"Keyword");return RETURN;}
"("			{return '(';}
")"			{return ')';}
"{"			{return '{';}
"}"			{return '}';}
";"			{return ';';}
","			{return ',';}
"&"			{return '&';}
"="			{return '=';}
">"			{return '>';}
"."			{return '.';}
[_a-zA-Z][a-zA-Z0-9_]*	{insertSymbolTable(yytext,"Identifier");return IDENTIFIER;}
[+-]?[0-9]+		{insertConstantTable(yytext, "Integer");return INTEGER;}
"\""[^\n]*"\""		{insertConstantTable(yytext, "Integer");return STRING;}
"+"			{return '+';}
"-"			{return '-';}
"*"			{return '*';}
"/"			{return '/';}
"%"			{return '%';}
[\n]			{yylineno++;}
[ \t\v\f]		{ }
.			{
				printf("Error %s at line %d and type : %s\n", yytext, yylineno, "lexical error");
			}
%%

int yywrap(void){
	return 1;
}
