%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int yylex();
	void yyerror(char *s);
	extern FILE *yyin;
	extern int yylineno;
	extern int flag;
	extern char *yytext;
	extern char final_string[1000];
    	int rows=6, cols=8;
	int flag2=0, flag_error=0, counter=1;
	struct node* mknode(struct node *child1, struct node *child2, struct node *child3, char *token);
	
	struct node *head;
    	struct node { 
		struct node *child1; 
		struct node *child2;
		struct node *child3; 
		char *token; 
    	};
    	
    	struct queueNode {
    		struct node *treeNode;
    		struct queueNode *next;
	};

	struct queue {
    		struct queueNode *front;
    		struct queueNode *rear;
	};

	void enqueue(struct queue *q, struct node *treeNode) {
    		struct queueNode *newNode = (struct queueNode *)malloc(sizeof(struct queueNode));
    		newNode->treeNode = treeNode;
    		newNode->next = NULL;
    		if (q->rear == NULL) {
        		q->front = q->rear = newNode;
    		} else {
       	 	q->rear->next = newNode;
        	q->rear = newNode;
    	}
	}

	struct node *dequeue(struct queue *q) {
    		if (q->front == NULL) {
       	 		return NULL;
    		}
    		struct queueNode *temp = q->front;
    		struct node *treeNode = temp->treeNode;
    		q->front = q->front->next;
    		if (q->front == NULL) {
        		q->rear = NULL;
    		}
    		free(temp);
    		return treeNode;
	}

	int isEmpty(struct queue *q) {
    		return q->front == NULL;
	}

	void levelOrderTraversal(struct node *root) {
    		if (root == NULL) return;

		struct queue q;
		q.front = q.rear = NULL;

    		enqueue(&q, root);
    		int level = 1;  // Keep track of the level

    		while (!isEmpty(&q)) {
        		int levelSize = 0;  // Number of nodes at the current level
        		struct queueNode *current = q.front;

        		// Count nodes at the current level
        		while (current != NULL) {
            			levelSize++;
            			current = current->next;
        		}
	
        		printf("Level - %d : ", level);
        		for (int i = 0; i < levelSize; i++) {
        		    	struct node *currentNode = dequeue(&q);
        		    	printf("%s ", currentNode->token);
		
		            	// Enqueue child nodes	
		            	if (currentNode->child1 != NULL) {
        			    enqueue(&q, currentNode->child1);
       			    	}
        	    	    	if (currentNode->child2 != NULL) {
        	        	    enqueue(&q, currentNode->child2);
        	    		}
        	    		if (currentNode->child3 != NULL) {
        	        		enqueue(&q, currentNode->child3);
       		     		}
        		}
        		printf("\n");  // New line after each level
        		level++;  // Move to the next level
    		}
	}
%}


%union { 
	struct var_name { 
		char name[100]; 
		struct node* nd;
	} nd_obj; 
} 

%token <nd_obj> WORD START_WORD STOP COMMA HYPHEN QUOTATION
%type <nd_obj> stmt mid_sentence words punctuations combos

%%
stmt : START_WORD mid_sentence STOP
     {
     	$1.nd = mknode(NULL, NULL, NULL, "START_WORD");
     	$3.nd = mknode(NULL, NULL, NULL, "STOP");
     	$$.nd = mknode($1.nd, $2.nd, $3.nd, "stmt");
     	head = $$.nd;
     }	
     ;  
     
mid_sentence : words mid_sentence
	     {
    		$$.nd = mknode($1.nd, $2.nd, NULL, "mid_sentence");
	     }
	     | punctuations words mid_sentence
	     {
	     	$$.nd = mknode($1.nd, $2.nd, $3.nd, "mid_sentence");
	     }
	     |
	     {
	     	$$.nd = NULL; 
	     }
	     ;
	     
words : START_WORD 
      {
        $1.nd = mknode(NULL, NULL, NULL, "START_WORD");
      	$$.nd = mknode($1.nd, NULL, NULL, "words");
      }
      | WORD 
      {
      	$1.nd = mknode(NULL, NULL, NULL, "WORD");
      	$$.nd = mknode($1.nd, NULL, NULL, "words");
      }
      | QUOTATION
      {
      	$1.nd = mknode(NULL, NULL, NULL, "QUOTATION");
      	$$.nd = mknode($1.nd, NULL, NULL, "words");
      }
      ;	      
	     	     
punctuations : COMMA 
	     {
	     	$1.nd = mknode(NULL, NULL, NULL, "COMMA"); 
	     	$$.nd = mknode($1.nd, NULL, NULL, "punctuations");
	     }
	     | combos
	     {
	     	$$.nd = mknode($1.nd, NULL, NULL, "punctuations");
	     }
	     ;	     	     
	    
combos : COMMA HYPHEN combos
       {
       	 $1.nd = mknode(NULL, NULL, NULL, "COMMA");
       	 $2.nd = mknode(NULL, NULL, NULL, "HYPHEN");
       	 $$.nd = mknode($1.nd, $2.nd, $3.nd, "combos");
       }
       | HYPHEN combos
       {
         $1.nd = mknode(NULL, NULL, NULL, "HYPHEN");
       	 $$.nd = mknode($1.nd, $2.nd, NULL, "combos");
       }
       |
       {
       	 $$.nd = NULL;
       }
       ;
%%

void printSymbolTable();
void printErrorTable();
void insertErrorTable(char *, char*);

void yyerror(char *msg){
	flag=1;
	flag2=1;
	flag_error=1;
	insertErrorTable(yytext, "Syntax Error ");
	printf("Invalid due to %s\n", msg);
}

void parseTable(){
	char ***matrix;

    	matrix = malloc(rows * sizeof(char **));
    	if (matrix == NULL) {
        	fprintf(stderr, "Memory allocation failed\n");
        	return;
    	}

    	for (int i = 0; i < rows; i++) {
        	matrix[i] = malloc(cols * sizeof(char *));
        	if (matrix[i] == NULL) {
            		fprintf(stderr, "Memory allocation failed\n");
            		return;
        	}

        	for (int j = 0; j < cols; j++) {
            		matrix[i][j] = malloc(100 * sizeof(char));
            		if (matrix[i][j] == NULL) {
                		fprintf(stderr, "Memory allocation failed\n");
                		return;
            		}
        	}
    	}
    	
    	strcpy(matrix[0][0], "Non-Ter|Ter");
    	strcpy(matrix[0][1], "START_WORD");
    	strcpy(matrix[0][2], "WORD");
    	strcpy(matrix[0][3], "QUOTATION");
    	strcpy(matrix[0][4], "STOP");
    	strcpy(matrix[0][5], "COMMA");
    	strcpy(matrix[0][6], "HYPHEN");
    	strcpy(matrix[0][7], "$");
    	strcpy(matrix[1][0], "stmt");
    	strcpy(matrix[1][1], "1");
    	strcpy(matrix[1][7], "1");
    	strcpy(matrix[2][0], "mid_sentence");
    	strcpy(matrix[2][1], "2");
    	strcpy(matrix[2][2], "2");
	strcpy(matrix[2][3], "2");
	strcpy(matrix[2][4], "4");
	strcpy(matrix[2][5], "3");
	strcpy(matrix[2][6], "3");
	strcpy(matrix[3][0], "words");
	strcpy(matrix[3][1], "5");
	strcpy(matrix[3][2], "6");
	strcpy(matrix[3][3], "7");
	strcpy(matrix[4][0], "punctuations");
	strcpy(matrix[4][1], "10");
	strcpy(matrix[4][2], "10");
	strcpy(matrix[4][3], "10");
	strcpy(matrix[4][5], "8");
	strcpy(matrix[4][6], "9");
	strcpy(matrix[5][0], "combos");
	strcpy(matrix[5][1], "13");
	strcpy(matrix[5][2], "13");
	strcpy(matrix[5][3], "13");
	strcpy(matrix[5][5], "11");
	strcpy(matrix[5][6], "12");
	
	printf("%100s\n", "LL(1) Parsing table");
	printf("------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    	for (int i = 0; i < rows; i++) {
        	for (int j = 0; j < cols; j++) {
            		if (j == 0) {
                		printf("  %-20s |", matrix[i][j]);
            		} else {
                		printf("  %-20s |", matrix[i][j]);
            		}
        	}
        	printf("\n------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    	}
}  

struct node* mknode(struct node *child1, struct node *child2, struct node *child3, char *token) {	
	struct node *newnode = (struct node *)malloc(sizeof(struct node));
	char *newstr = (char *)malloc(strlen(token)+1);
	strcpy(newstr, token);
	newnode->child1 = child1;
	newnode->child2 = child2;
	newnode->child3 = child3;
	newnode->token = newstr;
	return(newnode);
}

int main(){
	yyin=fopen("input.txt", "r");
	strcpy(final_string, ""); 
	yyparse(); 
	if(flag==0){
		printf("Valid sentence\n");
		printf("Accepted string: %s\n", final_string);
	}
	else if(flag2==0){
		yyerror("lexical error");
	}
	printf("\n");
	printf(" %30s ", "Symbol Table\n");
	printf("----------------------------------------------------------\n");
	printSymbolTable();
	printf("-----------------------------------------------------------\n\n\n");
	if(flag_error==1){
		printf(" %30s ", "Error Table\n");
		printf("------------------------------------------\n");
		printErrorTable();
		printf("------------------------------------------\n\n\n");
		printf("\nNo AST\n");
	}
	else{
		printf("No errors\n\n\n");
		printf("\nLevel Order Traversal of the Parse Tree:\n");
    		levelOrderTraversal(head);
    		printf("\n");
	}
	parseTable();
	return 0;
}
