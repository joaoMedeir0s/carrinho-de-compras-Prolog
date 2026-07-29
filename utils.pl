:- module(utils, [imprimir_arquivo_completo/1
                  ,mostrar_tente_novamente/0]).
:- use_module(library(dcg/basics)).

imprimir_arquivo_completo(Arquivo) :-
    read_file_to_string(Arquivo, Conteudo, []),
    write(Conteudo),
    nl.

mostrar_tente_novamente :-
    imprimir_arquivo_completo('tente_novamente.txt').