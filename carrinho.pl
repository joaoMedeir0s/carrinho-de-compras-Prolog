:- encoding(utf8).

:- module(carrinho, [visualizar_carrinho/3, adicionar_ao_carrinho/5,
                      remover_do_carrinho/3, atualizar_quantidade/5]).

% Auxiliares

% buscar_produto(+ProdutoID, +Catalogo, -Produto)
buscar_produto(ProdutoID, Catalogo, produto(ProdutoID, Nome, Preco, Desc, Estoque)) :-
    member(produto(ProdutoID, Nome, Preco, Desc, Estoque), Catalogo), !.

% buscar_quantidade_atual(+ProdutoID, +Carrinho, -Qtd)
% Se o produto já está no carrinho, devolve a quantidade; senão devolve 0.
buscar_quantidade_atual(ProdutoID, Carrinho, Qtd) :-
    member(item(ProdutoID, Qtd), Carrinho), !.
buscar_quantidade_atual(_ProdutoID, _Carrinho, 0).

% substituir_item(+ProdutoID, +NovaQtd, +Carrinho, -NovoCarrinho)
% Remove a entrada antiga (se existir) e insere item(ProdutoID, NovaQtd).
substituir_item(ProdutoID, NovaQtd, Carrinho, [item(ProdutoID, NovaQtd) | Resto]) :-
    exclude([item(Id, _)] >> (Id == ProdutoID), Carrinho, Resto).

% Predicados principais 

% visualizar_carrinho(+Catalogo, +Carrinho, -ItensExibicao)
visualizar_carrinho(_Catalogo, [], []).
visualizar_carrinho(Catalogo, [item(ProdutoID, Qtd) | Resto], [par(Produto, Qtd) | RestoExibicao]) :-
    buscar_produto(ProdutoID, Catalogo, Produto),
    visualizar_carrinho(Catalogo, Resto, RestoExibicao).

% adiciona itens ao carrinho
adicionar_ao_carrinho(ProdutoID, Qtd, Catalogo, Carrinho, Resultado) :-
    ( \+ buscar_produto(ProdutoID, Catalogo, _) ->
        Resultado = erro('Erro: Produto inexistente!')
    ;
        buscar_produto(ProdutoID, Catalogo, produto(ProdutoID, _, _, _, Estoque)),
        buscar_quantidade_atual(ProdutoID, Carrinho, QtdAtual),
        QtdTotal is QtdAtual + Qtd,
        ( QtdTotal =< 0 ->
            Resultado = erro('Quantidade invalida!')
        ; Estoque >= QtdTotal ->
            substituir_item(ProdutoID, QtdTotal, Carrinho, NovoCarrinho),
            Resultado = ok(NovoCarrinho)
        ;
            format(atom(Msg), 'Estoque insuficiente! Disponivel: ~w', [Estoque]),
            Resultado = erro(Msg)
        )
    ).

% remove itens do carrinho
remover_do_carrinho(ProdutoID, Carrinho, NovoCarrinho) :-
    exclude([item(Id, _)] >> (Id == ProdutoID), Carrinho, NovoCarrinho).

% atualiza a quantidade de itens do carrinho
atualizar_quantidade(ProdutoID, NovaQtd, _Catalogo, Carrinho, Resultado) :-
    NovaQtd =< 0,
    !,
    remover_do_carrinho(ProdutoID, Carrinho, NovoCarrinho),
    Resultado = ok(NovoCarrinho).
atualizar_quantidade(ProdutoID, NovaQtd, Catalogo, Carrinho, Resultado) :-
    ( \+ buscar_produto(ProdutoID, Catalogo, _) ->
        Resultado = erro('Erro: Produto inexistente!')
    ;
        buscar_produto(ProdutoID, Catalogo, produto(ProdutoID, _, _, _, Estoque)),
        ( Estoque >= NovaQtd ->
            substituir_item(ProdutoID, NovaQtd, Carrinho, NovoCarrinho),
            Resultado = ok(NovoCarrinho)
        ;
            Resultado = erro('Estoque insuficiente!')
        )
    ).