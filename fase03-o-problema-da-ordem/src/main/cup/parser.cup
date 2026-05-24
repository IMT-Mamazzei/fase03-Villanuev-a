package br.maua.cic303;

import java_cup.runtime.*;

parser code {:
    // Método chamado pelo CUP quando encontra um erro sintático
    @Override
    public void syntax_error(Symbol cur_token) {
        throw new RuntimeException("Erro Sintático na linha " + cur_token.left + ", coluna " + cur_token.right);
    }
:}

/* ========================================================================= */
/* DECLARAÇÃO DOS TOKENS (TERMINAIS)                                         */
/* ========================================================================= */

terminal IF, THEN, ELSE, WHILE;
terminal ASSIGN, LPAREN, RPAREN, LBRACE, RBRACE, SEMI;
terminal String ID, NUMBER;
terminal String ADD_OP, MUL_OP, REL_OP;

/* ========================================================================= */
/* DECLARAÇÃO DOS NÃO-TERMINAIS (VARIÁVEIS DA GRAMÁTICA)                     */
/* ========================================================================= */

non terminal program, stmt_list, stmt;
non terminal assign_stmt, if_stmt, while_stmt, block_stmt, null_stmt;
non terminal expr;

/* ========================================================================= */
/* PRECEDÊNCIA E ASSOCIATIVIDADE                                             */
/* ========================================================================= */

precedence left REL_OP;
precedence left ADD_OP;
precedence left MUL_OP;

/* ========================================================================= */
/* REGRAS DA GRAMÁTICA                                                       */
/* ========================================================================= */

start with program;

program ::= stmt_list ;

/* Lista de comandos que aceita recursão à esquerda e pode ser vazia.
   Isso permite tratar blocos vazios, sequências de nulos ou códigos sem comandos. */
stmt_list ::= stmt_list stmt
            | /* Vazio */
            ;

stmt ::= assign_stmt
       | if_stmt
       | while_stmt
       | block_stmt
       | null_stmt
       ;

assign_stmt ::= ID ASSIGN expr SEMI ;

/* Estruturas de controle IF/ELSE tratadas explicitamente sem colchetes opcionais */
if_stmt ::= IF LPAREN expr RPAREN THEN block_stmt
          | IF LPAREN expr RPAREN THEN block_stmt ELSE block_stmt
          ;

while_stmt ::= WHILE LPAREN expr RPAREN block_stmt ;

block_stmt ::= LBRACE stmt_list RBRACE ;

null_stmt ::= SEMI ;

/* Expressões matemáticas com árvore resolvida por regras de precedência */
expr ::= expr ADD_OP expr
       | expr MUL_OP expr
       | expr REL_OP expr
       | LPAREN expr RPAREN
       | NUMBER
       | ID
       ;
