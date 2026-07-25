:- module(utils, [imprimir_arquivo_completo/1]).

imprimir_arquivo_completo(Arquivo) :-
    read_file_to_string(Arquivo, Conteudo, []),
    write(Conteudo),
    nl.