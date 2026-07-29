:- module(carrinhoController, [pagina_do_carrinho/0,
                               carregar_catalogo/2,
                               carregar_carrinho/2]).
:- use_module(utils, [imprimir_arquivo_completo/1]).
:- use_module(carrinho, [adicionar_ao_carrinho/5,
                         item_no_carrinho/2,
                         remover_do_carrinho/3]).
:- use_module(userController, [pagina_do_usuario/0]).

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
        Escolha_Minuscula == "s" -> userController:pagina_do_usuario;
        imprimir_arquivo_completo('SpritesMenu/tente_novamente.txt'),
        sleep(0.7),
        userController:pagina_do_usuario ).


ver_carrinho :-
    carregar_catalogo('SystemData/catalogo.txt', Catalogo),
    carregar_carrinho('SystemData/carrinho.txt', Carrinho),
    formatar_carrinho(Catalogo, Carrinho, Linhas),
    maplist(writeln, Linhas),
    writeln('Pressione enter para continuar...'),
    read_line_to_string(user_input, _),
    pagina_do_carrinho.


adicionar_no_carrinho :-
    imprimir_arquivo_completo('SpritesMenu/Carrinho/adicionar_id.txt'),
    write("Digite o ID: "),
    read_line_to_string(user_input, IdStr),
    number_string(Id, IdStr),

    imprimir_arquivo_completo('SpritesMenu/Carrinho/adicionar_qant.txt'),
    write("Digite a quantidade: "),
    read_line_to_string(user_input, QantStr),
    number_string(Qant, QantStr),

    carregar_catalogo('SystemData/catalogo.txt', Catalogo),
    carregar_carrinho('SystemData/carrinho.txt', Carrinho),

    adicionar_ao_carrinho(Id, Qant, Catalogo, Carrinho, Resultado),

    ( Resultado = ok(NovoCarrinho) 
        -> salvar_carrinho('SystemData/carrinho.txt', NovoCarrinho),
           produto_adicionado
        ; 
      Resultado = erro('Erro: Produto inexistente!') 
        -> tela_produto_invalido
        ;
      Resultado = erro('Quantidade invalida!')
        -> tela_produto_invalido
        ;
      Resultado = erro(_)
        -> tela_produto_invalido
        ).



produto_adicionado :- 
    imprimir_arquivo_completo('SpritesMenu/Carrinho/produto_adicionado.txt'),
    sleep(0.8),
    pagina_do_carrinho.

tela_produto_invalido:- 
    imprimir_arquivo_completo('SpritesMenu/Carrinho/produto_invalido.txt'),
    sleep(0.8),
    imprimir_arquivo_completo('SpritesMenu/tente_novamente.txt'),
    sleep(0.8),
    pagina_do_carrinho.

% REMOÇÃO DE ITENS

remover_itens :-
    imprimir_arquivo_completo('SpritesMenu/Carrinho/remover_id.txt'),
    writeln('Digite o Id do item: '),
    read_line_to_string(user_input, IdStr),
    number_string(Id, IdStr),

    carregar_carrinho('SystemData/carrinho.txt', Carrinho),

    (item_no_carrinho(Id, Carrinho)
        -> remover_do_carrinho(Id, Carrinho, NovoCarrinho),
           salvar_carrinho('SystemData/carrinho.txt', NovoCarrinho),
           tela_produto_removido
        ; tela_produto_invalido).

tela_produto_removido :- 
    imprimir_arquivo_completo('SpritesMenu/Carrinho/remocao_realizada.txt'),
    sleep(0.8),
    pagina_do_carrinho.


% FORMATAÇÃO, CARREGAMENTO & SUBSTITUIÇÃO
carregar_carrinho(Arquivo, Carrinho) :-
    read_file_to_string(Arquivo, Conteudo, []),
    split_string(Conteudo, "\n", "\r", Linhas),
    include([L]>>(L \= ""), Linhas, LinhasFiltradas),
    maplist(parsear_item, LinhasFiltradas, Carrinho).

parsear_item(Linha, item(Id, Quantidade)) :-
    split_string(Linha, ",", "", [IdStr, QtdStr]),
    number_string(Id, IdStr),
    number_string(Quantidade, QtdStr).

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

salvar_carrinho(Arquivo, Carrinho) :-
    open(Arquivo, write, Stream),
    maplist(escrever_item(Stream), Carrinho),
    close(Stream).

escrever_item(Stream, item(Id, Quantidade)) :-
    format(Stream, "~w,~w~n", [Id, Quantidade]).

formatar_item_carrinho(Catalogo, IdProduto, Quantidade, Linha) :-
    member(produto(IdProduto, Nome, Preco, _, _, _), Catalogo),
    Subtotal is Preco * Quantidade,
    format(atom(Linha), "~w (ID ~w) | Qtd: ~w | Unit.: R$ ~w | Subtotal: R$ ~w",
           [Nome, IdProduto, Quantidade, Preco, Subtotal]).

formatar_carrinho(_, [], []).
formatar_carrinho(Catalogo, [item(Id, Qtd) | Cauda], [Linha | Resultado]) :-
    formatar_item_carrinho(Catalogo, Id, Qtd, Linha),
    formatar_carrinho(Catalogo, Cauda, Resultado).