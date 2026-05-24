package br.maua.cic303;

import java_cup.runtime.Symbol; // Importação necessária para o CUP

%%

%class Lexer
%public
%unicode
%cup       // <-- CRÍTICO: Ativa a integração nativa com o CUP e muda o tipo de retorno para Symbol
%line
%column

%{
    // Funções auxiliares para gerar objetos Symbol para o CUP
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

/* ========================================================================= */
/* MACROS                                                                    */
/* ========================================================================= */
LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?

Letter = [a-zA-Z]
Digit  = [0-9]
Identifier = {Letter}({Letter}|{Digit}|_){0,31}

%%

<YYINITIAL> {

    /* Ignorar espaços */
    {WhiteSpace}    { /* Não faz nada */ }

    /* ========================= */
    /* PALAVRAS RESERVADAS       */
    /* ========================= */
    "if"            { return symbol(sym.IF); }
    "then"          { return symbol(sym.THEN); }
    "else"          { return symbol(sym.ELSE); }
    "while"         { return symbol(sym.WHILE); }

    /* ========================= */
    /* PONTUAÇÃO                 */
    /* ========================= */
    "("             { return symbol(sym.LPAREN); }
    ")"             { return symbol(sym.RPAREN); }
    "{"             { return symbol(sym.LBRACE); }
    "}"             { return symbol(sym.RBRACE); }
    ";"             { return symbol(sym.SEMI); }

    /* ========================= */
    /* OPERADORES RELACIONAIS    */
    /* ========================= */
    "=="            { return symbol(sym.REL_OP, yytext()); }
    "!="            { return symbol(sym.REL_OP, yytext()); }
    "<="            { return symbol(sym.REL_OP, yytext()); }
    ">="            { return symbol(sym.REL_OP, yytext()); }
    "<"             { return symbol(sym.REL_OP, yytext()); }
    ">"             { return symbol(sym.REL_OP, yytext()); }

    /* ========================= */
    /* ATRIBUIÇÃO                */
    /* ========================= */
    "="             { return symbol(sym.ASSIGN); }

    /* ========================= */
    /* OPERADORES MATEMÁTICOS    */
    /* ========================= */
    "+" | "-"       { return symbol(sym.ADD_OP, yytext()); }
    "*" | "/" | "%" { return symbol(sym.MUL_OP, yytext()); }

    /* ========================= */
    /* IDENTIFICADORES E NÚMEROS */
    /* ========================= */
    {Identifier}    { return symbol(sym.ID, yytext()); }
    {Number}        { return symbol(sym.NUMBER, yytext()); }

    /* ERRO: identificador > 32 chars */
    /* Consome os 32 caracteres excedentes mais o restante do nome inválido */
    {Letter}({Letter}|{Digit}|_){32}({Letter}|{Digit}|_)* {
        return symbol(sym.error, "Erro Léxico: Identificador ultrapassou 32 caracteres -> " + yytext());
    }

    /* ERRO genérico */
    . {
        return symbol(sym.error, "Erro Léxico: Caractere Ilegal -> " + yytext());
    }
}

/* EOF */
<<EOF>> { return symbol(sym.EOF); }
