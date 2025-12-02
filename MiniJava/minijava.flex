import java_cup.runtime.*;
import java.io.*;

%%

%class MiniJavaScanner
%unicode
%public
%cup
%line
%column

%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
    
%}

%eofval{
  return symbol(sym.EOF);
%eofval}

%state IN_COMMENT

%%

// ---------- PALAVRAS-RESERVADAS ----------
"class"             { return symbol(sym.CLASS); }
"public"            { return symbol(sym.PUBLIC); }
"static"            { return symbol(sym.STATIC); }
"void"              { return symbol(sym.VOID); }
"main"              { return symbol(sym.MAIN); }
"String"            { return symbol(sym.STRING); }
"extends"           { return symbol(sym.EXTENDS); }
"return"            { return symbol(sym.RETURN); }
"int"               { return symbol(sym.INT); }
"boolean"           { return symbol(sym.BOOLEAN); }
"if"                { return symbol(sym.IF); }
"else"              { return symbol(sym.ELSE); }
"while"             { return symbol(sym.WHILE); }
"System.out.println" { return symbol(sym.PRINT); }
"true"              { return symbol(sym.TRUE); }
"false"             { return symbol(sym.FALSE); }
"this"              { return symbol(sym.THIS); }
"new"               { return symbol(sym.NEW); }
"length"            { return symbol(sym.LENGTH); }

// ---------- OPERADORES E SÍMBOLOS ----------

"="                 { return symbol(sym.ATRIB); }
"=="                { return symbol(sym.IGUAL); }
"!="                { return symbol(sym.DIFERENTE); }
"<="                { return symbol(sym.MENOR_IGUAL); }
"<"                 { return symbol(sym.MENORQ); }
"&&"                { return symbol(sym.E); }
"||"                { return symbol(sym.OU); }
"+"                 { return symbol(sym.MAIS); }
"-"                 { return symbol(sym.MENOS); }
"*"                 { return symbol(sym.VEZES); }
"/"                 { return symbol(sym.DIV); }
"%"                 { return symbol(sym.MOD); }
"!"                 { return symbol(sym.NEGACAO); }
"{"                 { return symbol(sym.A_CHAVE); }
"}"                 { return symbol(sym.F_CHAVE); }
"("                 { return symbol(sym.A_PAREN); }
")"                 { return symbol(sym.F_PAREN); }
"["                 { return symbol(sym.A_COLC); }
"]"                 { return symbol(sym.F_COLC); }
";"                 { return symbol(sym.PONTO_VIRGULA); }
"."                 { return symbol(sym.PONTO); }
"," 		    { return symbol(sym.VIRGULA); }

// ---------- IDENTIFICADORES E NÚMEROS ----------
[0-9]+              { return symbol(sym.NUM, Integer.valueOf(yytext())); }
[a-zA-Z][a-zA-Z0-9_]* { return symbol(sym.ID, yytext()); }

// ---------- STRINGS ----------
\"([^\"\\\n]|\\.)*\"   { return symbol(sym.TEXTO, yytext()); }

// String não fechada (Opcional: lançar erro ou retornar token de erro)
\"([^\"\\\n]|\\.)* { throw new RuntimeException("String não fechada na linha " + (yyline+1)); }

// ---------- ESPAÇOS E COMENTÁRIOS ----------
[ \t\r\n\f]+        { /* ignora */ }
"//" [^\n]* { /* ignora */ }
"/*"                { yybegin(IN_COMMENT); }

<IN_COMMENT> {
    "*/"            { yybegin(YYINITIAL); }
    [^*]+           { /* ignora */ }
    "*"             { /* ignora */ }
}

// ---------- ERROS ----------
. { throw new RuntimeException("Caractere ilegal: " + yytext() + " na linha " + (yyline+1)); }