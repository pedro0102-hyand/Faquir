/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     NUM = 258,
     REAL = 259,
     ID = 260,
     CARACTERE = 261,
     INT = 262,
     FLOAT = 263,
     CHAR = 264,
     BOOL = 265,
     TRUE = 266,
     FALSE = 267,
     TK_SOMA = 268,
     TK_SUB = 269,
     TK_MUL = 270,
     TK_DIV = 271,
     TK_EQ = 272,
     TK_NE = 273,
     TK_LT = 274,
     TK_LE = 275,
     TK_GT = 276,
     TK_GE = 277,
     TK_AND = 278,
     TK_OR = 279,
     TK_NOT = 280
   };
#endif
/* Tokens.  */
#define NUM 258
#define REAL 259
#define ID 260
#define CARACTERE 261
#define INT 262
#define FLOAT 263
#define CHAR 264
#define BOOL 265
#define TRUE 266
#define FALSE 267
#define TK_SOMA 268
#define TK_SUB 269
#define TK_MUL 270
#define TK_DIV 271
#define TK_EQ 272
#define TK_NE 273
#define TK_LT 274
#define TK_LE 275
#define TK_GT 276
#define TK_GE 277
#define TK_AND 278
#define TK_OR 279
#define TK_NOT 280




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 71 "analisador.y"
{
    int valor;
    float fval;
    char letra;
    struct Resultado* resultado;
}
/* Line 1529 of yacc.c.  */
#line 106 "analisador.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

