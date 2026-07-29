:- module(userController, [pagina_do_usuario/0,
                           finalizar_compra_usuario/0]).
:- use_module('../utils', [imprimir_arquivo_completo/1,
                           limpa_arquivo/1]).
:- use_module(finalizacao, [finalizar_compra/4]).
:- use_module(carrinhoController, [pagina_do_carrinho/0,
                                   carregar_carrinho/2]).


pagina_do_usuario :-
    imprimir_arquivo_completo('SpritesMenu/pagina_do_usuario.txt'),
    write("Para onde desenha ir? "),
    read_line_to_string(user_input, Escolha),
    opcoes_pagina_do_usuario(Escolha).

opcoes_pagina_do_usuario(Escolha) :-
    string_lower(Escolha, Escolha_Minuscula),
    (   Escolha_Minuscula == "v" -> catalogo;
        Escolha_Minuscula == "a" -> pagina_do_carrinho;
        Escolha_Minuscula == "f" -> finalizar_compra_usuario;
        Escolha_Minuscula == "s" -> adeus;
        imprimir_arquivo_completo('SpritesMenu/tente_novamente.txt'),
        sleep(0.7),
        pagina_do_usuario).

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

finalizar_compra_usuario :-
    carregar_usuario('../SystemData/usuarios.txt', Usuario),
    carregar_catalogo('../SystemData/catalogo.txt', Catalogo),
    carregar_carrinho('../SystemData/carrinho.txt', Carrinho),

    finalizar_compra(Usuario, Catalogo, Carrinho, Resultado),
    
    ( Resultado = ok(NovoCatalogo, Resumo) ->
        salvar_catalogo('SystemData/catalogo.txt', NovoCatalogo),
        limpar_arquivo('SystemData/carrinho.txt'),
        exibir_resumo(Resumo)

        ; Resultado = erro('Erro: O carrinho esta vazio!')
        -> imprimir_arquivo_completo('SpritesMenu/Carrinho/carrinho_vazio.txt'),
           sleep(0.8),
           pagina_do_usuario).


salvar_catalogo(Arquivo, Catalogo) :-
    open(Arquivo, write, Stream),
    maplist(escrever_produto(Stream), Catalogo),
    close(Stream).

escrever_produto(Stream, produto(Id, Nome, Preco, Descricao, Estoque, Categoria)) :-
    format(Stream, "~w,~w,~w,~w,~w,~w~n", [Id, Nome, Preco, Descricao, Estoque, Categoria]).

exibir_resumo(resumo_pedido(_, _, _, Mensagem)) :-
        writeln(Mensagem),
        writeln('Pressione uma tecla para continuar...: '),
        read_line_to_string(user_input, _),
        pagina_do_usuario.

carregar_usuario(Arquivo, usuario(Nome, Email, Senha)) :-
    read_file_to_string(Arquivo, Conteudo, []),
    split_string(Conteudo, "\n", "\r", Linhas),
    include([L]>>(L \= ""), Linhas, [Linha|_]),
    split_string(Linha, ":", "", [Nome, Email, Senha]).

parsear_usuario(Linha, usuario(Nome, Email, Senha)) :-
    split_string(Linha, ":", "", [Nome, Email, Senha]).


limpar_arquivo(Arquivo) :-
    open(Arquivo, write, Stream),
    close(Stream).


adeus :-
    imprimir_arquivo_completo('SpritesMenu/adeus.txt'),
    limpar_arquivo('SystemData/usuarios.txt'),
    limpar_arquivo('SystemData/carrinho.txt'),
    sleep(1.5),
    halt.

carregar_catalogo(Arquivo, Catalogo) :-
    read_file_to_string(Arquivo, Conteudo, []),
    split_string(Conteudo, "\n", "\r", Linhas),
    include([L]>>(L \= ""), Linhas, LinhasFiltradas),
    maplist(parsear_produto, LinhasFiltradas, Catalogo).

parsear_produto(Linha, produto(Id, Nome, Preco, Descricao, Estoque, Categoria)) :-
    split_string(Linha, ",", "", [IdStr, Nome, PrecoStr, Descricao, EstoqueStr, Categoria]),
    number_string(Id, IdStr),
    number_string(Preco, PrecoStr),
    number_string(Estoque, EstoqueStr).
