:- module(carrinhoController, [pagina_do_carrinho/0]).
:- use_module('../utils.pl').
:- use_module('userController.pl').

pagina_do_carrinho :-
    imprimir_pagina_inteira('SpritesMenu/Carrinho/menu_carrinho.txt'),
    write("Para onde deseja ir? "),
    read(user_input, Escolha),
    opcoes_do_carrinho(Escolha).

opcoes_do_carrinho(Escolha) :-
    string_lower(Escolha, Escolha_Minuscula),
    (   Escolha_Minuscula == "v" -> ver_carrinho;
        Escolha_Minuscula == "a" -> adicionar_no_carrinho;
        Escolha_Minuscula == "r" -> remover_itens;
        Escolha_Minuscula == "s" -> pagina_do_usuario;
        mostrar_tente_novamente,
        pagina_do_usuario ).
