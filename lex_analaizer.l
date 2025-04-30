%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *yyin;

void print_error(const char *msg) {
    fprintf(stderr, "\033[1;31m[Error]\033[0m %s\n", msg);
}
%}

%%

"//"[^\n]*              { printf("COMMENT\n"); }

f                       { printf("floatdcl\n"); }
i                       { printf("intdcl\n"); }
p                       { printf("print\n"); }

[a-z][a-z0-9_]*         { printf("id\n");}

=                       { printf("assign\n"); }
\+                      { printf("plus\n"); }

[0-9]+\.[0-9]+          { printf("fnum\n"); }
[0-9]+                  { printf("inum\n"); }

[ \t\r\n]+              { /* ignorar */ }

.                       { fprintf(stderr, "Caracter desconocido: '%s'\n", yytext); }

%%

int main(int argc, char **argv) {
    if (argc > 2) {
        print_error("Uso: ./lex_analaizer [archivo.ac]");
        return EXIT_FAILURE;
    }

    if (argc == 2) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("No se pudo abrir el archivo");
            return EXIT_FAILURE;
        }
        yyin = file;
    } else {
        yyin = stdin;
        printf("\033[1;34m[INFO]\033[0m Lectura desde stdin. Escribe código y presiona Ctrl+D para terminar:\n");
    }

    yylex();

    if (yyin != stdin)
        fclose(yyin);

    return EXIT_SUCCESS;
}

int yywrap() {
    return 1;
}

