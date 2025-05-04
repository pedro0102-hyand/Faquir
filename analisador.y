%{
#include <string>
#include <iostream>

int yylex();
int yyerror(const char*);

#define MAX_INSTRUCOES 100
#define MAX_SIMBOLOS 100

struct Instrucao {
    std::string temp;
    std::string operacao;
    std::string tipo;
};

struct Simbolo {
    char nome;
    std::string temp;
    std::string tipo;
};

Instrucao instrucoes[MAX_INSTRUCOES];
int total_instrucoes = 0;
int contador_temp = 1;

Simbolo tabela[MAX_SIMBOLOS];
int total_simbolos = 0;

std::string tipos_temp[MAX_INSTRUCOES];

std::string novo_temp(std::string tipo) {
    std::string nome = "T" + std::to_string(contador_temp);
    tipos_temp[contador_temp] = tipo;
    contador_temp++;
    return nome;
}

std::string get_temp_from_id(char id, bool is_declaration = false) {
    for (int i = 0; i < total_simbolos; i++) {
        if (tabela[i].nome == id)
            return tabela[i].temp;
    }

    if (is_declaration) {
        std::string novo = novo_temp("int");
        tabela[total_simbolos].nome = id;
        tabela[total_simbolos].temp = novo;
        tabela[total_simbolos].tipo = "int";
        total_simbolos++;
        return novo;
    } else {
        return std::string(1, id);
    }
}

std::string get_tipo_from_id(char id) {
    for (int i = 0; i < total_simbolos; i++) {
        if (tabela[i].nome == id)
            return tabela[i].tipo;
    }
    return "int";
}

struct Resultado {
    std::string nome;
    std::string tipo;
};
%}

%union {
    int valor;
    float fval;
    char letra;
    struct Resultado* resultado;
}

%token <valor> NUM
%token <fval> REAL
%token <letra> ID
%token <letra> CARACTERE
%token INT FLOAT CHAR BOOL TRUE FALSE
%token TK_SOMA TK_SUB TK_MUL TK_DIV
%token TK_EQ TK_NE TK_LT TK_LE TK_GT TK_GE
%token TK_AND TK_OR TK_NOT

%left TK_SOMA TK_SUB
%left TK_MUL TK_DIV
%left TK_EQ TK_NE TK_LT TK_LE TK_GT TK_GE
%left TK_AND TK_OR
%right TK_NOT

%type <resultado> expr

%%

entrada:
    comando entrada
  | comando
;

comando:
    declaracao
  | atribuicao
;

declaracao:
    INT ID ';' {
        get_temp_from_id($2, true);
    }
  | FLOAT ID ';' {
        get_temp_from_id($2, true);
        for (int i = 0; i < total_simbolos; i++) {
            if (tabela[i].nome == $2)
                tabela[i].tipo = "float";
        }
    }
  | CHAR ID ';' {
        get_temp_from_id($2, true);
        for (int i = 0; i < total_simbolos; i++) {
            if (tabela[i].nome == $2)
                tabela[i].tipo = "char";
        }
    }
  | BOOL ID ';' {
        get_temp_from_id($2, true);
        for (int i = 0; i < total_simbolos; i++) {
            if (tabela[i].nome == $2)
                tabela[i].tipo = "bool";
        }
    }
;

atribuicao:
    ID '=' expr ';' {
        std::string tipo_dest = get_tipo_from_id($1);
        std::string nome_var = std::string(1, $1);

        if (tipo_dest == "int" && $3->tipo == "float") {
            for (int i = 0; i < total_instrucoes; i++) {
                if (instrucoes[i].temp == $3->nome)
                    instrucoes[i].tipo = "int";
            }
            tipos_temp[contador_temp - 1] = "int";
            $3->tipo = "int";
        }

        Instrucao inst;
        inst.temp = nome_var;
        inst.operacao = $3->nome;
        inst.tipo = tipo_dest;
        instrucoes[total_instrucoes++] = inst;
    }
;


expr:
    expr TK_SOMA expr {
        Resultado* r = new Resultado;
        std::string tipo1 = $1->tipo, tipo2 = $3->tipo;
        std::string op1 = $1->nome, op2 = $3->nome;

        if (tipo1 == "float" || tipo2 == "float") {
            r->tipo = "float";
            if (tipo1 == "int") {
                std::string t = novo_temp("float");
                Instrucao conv;
                conv.temp = t;
                conv.operacao = "(float) " + op1;
                conv.tipo = "float";
                instrucoes[total_instrucoes++] = conv;
                op1 = t;
            }
            if (tipo2 == "int") {
                std::string t = novo_temp("float");
                Instrucao conv;
                conv.temp = t;
                conv.operacao = "(float) " + op2;
                conv.tipo = "float";
                instrucoes[total_instrucoes++] = conv;
                op2 = t;
            }
        } else {
            r->tipo = "int";
        }

        r->nome = novo_temp(r->tipo);
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = op1 + " + " + op2;
        inst.tipo = r->tipo;
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | expr TK_SUB expr {
        Resultado* r = new Resultado;
        std::string tipo1 = $1->tipo, tipo2 = $3->tipo;
        std::string op1 = $1->nome, op2 = $3->nome;

        if (tipo1 == "float" || tipo2 == "float") {
            r->tipo = "float";
            if (tipo1 == "int") {
                std::string t = novo_temp("float");
                Instrucao conv;
                conv.temp = t;
                conv.operacao = "(float) " + op1;
                conv.tipo = "float";
                instrucoes[total_instrucoes++] = conv;
                op1 = t;
            }
            if (tipo2 == "int") {
                std::string t = novo_temp("float");
                Instrucao conv;
                conv.temp = t;
                conv.operacao = "(float) " + op2;
                conv.tipo = "float";
                instrucoes[total_instrucoes++] = conv;
                op2 = t;
            }
        } else {
            r->tipo = "int";
        }

        r->nome = novo_temp(r->tipo);
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = op1 + " - " + op2;
        inst.tipo = r->tipo;
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | expr TK_MUL expr {
        Resultado* r = new Resultado;
        std::string tipo1 = $1->tipo, tipo2 = $3->tipo;
        std::string op1 = $1->nome, op2 = $3->nome;

        if (tipo1 == "float" || tipo2 == "float") {
            r->tipo = "float";
            if (tipo1 == "int") {
                std::string t = novo_temp("float");
                Instrucao conv;
                conv.temp = t;
                conv.operacao = "(float) " + op1;
                conv.tipo = "float";
                instrucoes[total_instrucoes++] = conv;
                op1 = t;
            }
            if (tipo2 == "int") {
                std::string t = novo_temp("float");
                Instrucao conv;
                conv.temp = t;
                conv.operacao = "(float) " + op2;
                conv.tipo = "float";
                instrucoes[total_instrucoes++] = conv;
                op2 = t;
            }
        } else {
            r->tipo = "int";
        }

        r->nome = novo_temp(r->tipo);
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = op1 + " * " + op2;
        inst.tipo = r->tipo;
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | expr TK_DIV expr {
        Resultado* r = new Resultado;
        std::string tipo1 = $1->tipo, tipo2 = $3->tipo;
        std::string op1 = $1->nome, op2 = $3->nome;

        if (tipo1 == "float" || tipo2 == "float") {
            r->tipo = "float";
            if (tipo1 == "int") {
                std::string t = novo_temp("float");
                Instrucao conv;
                conv.temp = t;
                conv.operacao = "(float) " + op1;
                conv.tipo = "float";
                instrucoes[total_instrucoes++] = conv;
                op1 = t;
            }
            if (tipo2 == "int") {
                std::string t = novo_temp("float");
                Instrucao conv;
                conv.temp = t;
                conv.operacao = "(float) " + op2;
                conv.tipo = "float";
                instrucoes[total_instrucoes++] = conv;
                op2 = t;
            }
        } else {
            r->tipo = "int";
        }

        r->nome = novo_temp(r->tipo);
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = op1 + " / " + op2;
        inst.tipo = r->tipo;
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }

  | expr TK_LT expr {
        Resultado* r = new Resultado;
        r->tipo = "int";
        r->nome = novo_temp("int");
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = $1->nome + " < " + $3->nome;
        inst.tipo = "int";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | expr TK_LE expr {
        Resultado* r = new Resultado;
        r->tipo = "int";
        r->nome = novo_temp("int");
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = $1->nome + " <= " + $3->nome;
        inst.tipo = "int";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | expr TK_GT expr {
        Resultado* r = new Resultado;
        r->tipo = "int";
        r->nome = novo_temp("int");
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = $1->nome + " > " + $3->nome;
        inst.tipo = "int";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | expr TK_GE expr {
        Resultado* r = new Resultado;
        r->tipo = "int";
        r->nome = novo_temp("int");
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = $1->nome + " >= " + $3->nome;
        inst.tipo = "int";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | expr TK_EQ expr {
        Resultado* r = new Resultado;
        r->tipo = "int";
        r->nome = novo_temp("int");
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = $1->nome + " == " + $3->nome;
        inst.tipo = "int";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | expr TK_NE expr {
        Resultado* r = new Resultado;
        r->tipo = "int";
        r->nome = novo_temp("int");
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = $1->nome + " != " + $3->nome;
        inst.tipo = "int";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | expr TK_AND expr {
        if ($1->tipo != "bool" || $3->tipo != "bool") {
            std::cerr << "Erro: operador && requer bool.\n";
            YYABORT;
        }
        Resultado* r = new Resultado;
        r->tipo = "bool";
        r->nome = novo_temp("bool");
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = $1->nome + " && " + $3->nome;
        inst.tipo = "bool";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | expr TK_OR expr {
        if ($1->tipo != "bool" || $3->tipo != "bool") {
            std::cerr << "Erro: operador || requer bool.\n";
            YYABORT;
        }
        Resultado* r = new Resultado;
        r->tipo = "bool";
        r->nome = novo_temp("bool");
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = $1->nome + " || " + $3->nome;
        inst.tipo = "bool";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | TK_NOT expr {
        if ($2->tipo != "bool") {
            std::cerr << "Erro: operador ! requer bool.\n";
            YYABORT;
        }
        Resultado* r = new Resultado;
        r->tipo = "bool";
        r->nome = novo_temp("bool");
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = "!" + $2->nome;
        inst.tipo = "bool";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | '(' expr ')' {
        $$ = $2;
    }
  | NUM {
        Resultado* r = new Resultado;
        r->nome = novo_temp("int");
        r->tipo = "int";
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = std::to_string($1);
        inst.tipo = "int";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | REAL {
        Resultado* r = new Resultado;
        r->nome = novo_temp("float");
        r->tipo = "float";
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = std::to_string($1);
        inst.tipo = "float";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | CARACTERE {
        Resultado* r = new Resultado;
        r->nome = novo_temp("char");
        r->tipo = "char";
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = "'" + std::string(1, $1) + "'";
        inst.tipo = "char";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | TRUE {
        Resultado* r = new Resultado;
        r->nome = novo_temp("int");
        r->tipo = "int";
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = "1";
        inst.tipo = "int";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | FALSE {
        Resultado* r = new Resultado;
        r->nome = novo_temp("int");
        r->tipo = "int";
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = "0";
        inst.tipo = "int";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | ID {
        Resultado* r = new Resultado;
        r->nome = get_temp_from_id($1, false);
        r->tipo = get_tipo_from_id($1);
        $$ = r;
    }
  | '(' INT ')' expr {
        Resultado* r = new Resultado;
        r->tipo = "int";
        r->nome = novo_temp("int");
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = "(int) " + $4->nome;
        inst.tipo = "int";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | '(' FLOAT ')' expr {
        Resultado* r = new Resultado;
        r->tipo = "float";
        r->nome = novo_temp("float");
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = "(float) " + $4->nome;
        inst.tipo = "float";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | '(' CHAR ')' expr {
        Resultado* r = new Resultado;
        r->tipo = "char";
        r->nome = novo_temp("char");
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = "(char) " + $4->nome;
        inst.tipo = "char";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
  | '(' BOOL ')' expr {
        Resultado* r = new Resultado;
        r->tipo = "bool";
        r->nome = novo_temp("bool");
        Instrucao inst;
        inst.temp = r->nome;
        inst.operacao = "(bool) " + $4->nome;
        inst.tipo = "bool";
        instrucoes[total_instrucoes++] = inst;
        $$ = r;
    }
;


%%

#include <string>
#include <iostream>
extern void yy_scan_string(const char*);

int main() {
    std::string linha;
    std::cout << "Digite sua entrada:\n";
    std::getline(std::cin, linha);

    yy_scan_string(linha.c_str());
    yyparse();

    std::cout << "Código Intermediário:\n";
    for (int i = 1; i < contador_temp; i++) {
        std::cout << tipos_temp[i] << " T" << i << ";\n";
    }

    std::cout << "\n";
    for (int i = 0; i < total_instrucoes; i++) {
        std::cout << instrucoes[i].temp << " = " << instrucoes[i].operacao << ";\n";
    }

    return 0;
}

int yyerror(const char *s) {
    return 1;
}




















































