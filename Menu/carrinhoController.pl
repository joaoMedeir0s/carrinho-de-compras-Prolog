:- module(carrinhoController, [pagina_do_carrinho/0]).
:- use_module(utils, [imprimir_arquivo_completo/1]).
:- use_module(userController, [pagina_do_usuario/0]).
:- use_module('Menu/userController.pl').

pagina_do_carrinho :-
    imprimir_arquivo_completo('SpritesMenu/Carrinho/menu_carrinho.txt'),
    write("Para onde deseja ir? "),
    read_line_to_string(user_input, Escolha),
    opcoes_do_carrinho(Escolha).

opcoes_do_carrinho(Escolha) :-
    string_lower(Escolha, Escolha_Minuscula),
    (   Escolha_Minuscula == "v" -> ver_carrinho;
        Escolha_Minuscula == "a" -> adicionar_no_carrinho;
        Escolha_Minuscula == "r" -> remover_itens;
        Escolha_Minuscula == "s" -> pagina_do_usuario;
        mostrar_tente_novamente,
        pagina_do_usuario ).

ver_carrinho :- 
    


