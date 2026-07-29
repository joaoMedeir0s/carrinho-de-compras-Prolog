:- module(userController, [pagina_do_usuario/0]).
:- use_module('carrinhoController.pl', [pagina_do_carrinho/0]).
:- use_module('../utils', [imprimir_arquivo_completo/1,
                           mostrar_tente_novamente/0]).

pagina_do_usuario :-
    imprimir_arquivo_completo('SpritesMenu/pagina_do_usuario.txt'),
    write("Para onde desenha ir? "),
    read_line_to_string(user_input, Escolha),
    opcoes_pagina_do_usuario(Escolha).

opcoes_pagina_do_usuario(Escolha) :-
    string_lower(Escolha, Escolha_Minuscula),
    (   Escolha_Minuscula == "v" -> catalogo;
        Escolha_Minuscula == "a" -> pagina_do_carrinho;
        Escolha_Minuscula == "f" -> finalizar_compra;
        Escolha_Minuscula == "s" -> adeus;
        mostrar_tente_novamente,
        pagina_do_usuario ).

catalogo :- 
    formatar_catalogo,
    write("Pressione enter para continuar... "),
    read_line_to_string(user_input, _),
    pagina_do_usuario.

formatar_catalogo :-
    write("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"),
    nl,
    imprimir_arquivo_completo('../SystemData/catalogo.txt'),
    write("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"),
    nl.

