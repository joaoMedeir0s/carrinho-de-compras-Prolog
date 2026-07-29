:- module(utils, [imprimir_arquivo_completo/1,
                  limpar_arquivo/1]).
:- use_module(library(dcg/basics)).

imprimir_arquivo_completo(Arquivo) :-
    read_file_to_string(Arquivo, Conteudo, []),
    write(Conteudo),
    nl.

limpar_arquivo(Arquivo) :-
    open(Arquivo, write, Stream),
    close(Stream).
