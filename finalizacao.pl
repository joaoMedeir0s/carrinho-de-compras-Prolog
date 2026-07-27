:- encoding(utf8).

:- module(finalizacao, [
    finalizar_compra/4,
    calcular_total/3,
    atualizar_estoque_do_pedido/3,
    formatar_itens/2,
    gerar_mensagem_sucesso/4
]).

:- use_module(catalogo, [atualizar_estoque/4]).
:- use_module(carrinho, [visualizar_carrinho/3]).

buscar_produto(ProdutoID, Catalogo, Produto) :-
    Produto = produto(ProdutoID, _, _, _, _, _),
    member(Produto, Catalogo),
    !.

calcular_total(_, [], 0).
calcular_total(Catalogo, [item(ProdutoID, Quantidade) | Restante], Total) :-
    calcular_total(Catalogo, Restante, TotalRestante),
    ( buscar_produto(ProdutoID, Catalogo, produto(ProdutoID, _, Preco, _, _, _)) ->
        SubtotalItem is Preco * Quantidade,
        Total is SubtotalItem + TotalRestante
    ;
        Total is TotalRestante
    ).

atualizar_estoque_do_pedido(Catalogo, [], ok(Catalogo)).
atualizar_estoque_do_pedido(Catalogo, [item(ProdutoID, Quantidade) | Restante], Resultado) :-
    ( Quantidade =< 0 ->
        Resultado = erro('Erro: quantidade invalida no carrinho.')
    ; \+ buscar_produto(ProdutoID, Catalogo, _) ->
        format(atom(Mensagem), 'Produto com ID ~w nao existe no catalogo.', [ProdutoID]),
        Resultado = erro(Mensagem)
    ;
        buscar_produto(ProdutoID, Catalogo, produto(ProdutoID, Nome, _, _, Estoque, _)),
        ( Estoque < Quantidade ->
            format(atom(Mensagem), 'Estoque insuficiente para ''~w''.', [Nome]),
            Resultado = erro(Mensagem)
        ;
            NovoEstoque is Estoque - Quantidade,
            atualizar_estoque(Catalogo, ProdutoID, NovoEstoque, CatalogoAtualizado),
            atualizar_estoque_do_pedido(CatalogoAtualizado, Restante, Resultado)
        )
    ).
atualizar_estoque_do_pedido(_, [_ | _], erro('Erro: item invalido no carrinho.')).

formatar_itens([], '').
formatar_itens([par(produto(_, Nome, Preco, _, _, _), Quantidade) | Restante], Texto) :-
    SubtotalItem is Preco * Quantidade,
    format(atom(Linha), '- ~w (x~w): R$ ~2f~n', [Nome, Quantidade, SubtotalItem]),
    formatar_itens(Restante, TextoRestante),
    atom_concat(Linha, TextoRestante, Texto).

dados_usuario(usuario(Nome, Email, _, _), Nome, Email) :- !.
dados_usuario(usuario(Nome, Email, _), Nome, Email) :- !.
dados_usuario(usuario(Nome, Email), Nome, Email) :- !.
dados_usuario(Usuario, Usuario, '').

gerar_mensagem_sucesso(Usuario, Itens, Total, Mensagem) :-
    dados_usuario(Usuario, Nome, Email),
    formatar_itens(Itens, TextoItens),
    format(atom(LinhaCliente), 'Cliente: ~w (~w)', [Nome, Email]),
    format(atom(LinhaTotal), 'Total Pago: R$ ~2f', [Total]),
    atomic_list_concat([
        '===========================================',
        '             COMPRA CONCLUIDA              ',
        '===========================================',
        LinhaCliente,
        '-------------------------------------------',
        'Itens:',
        TextoItens,
        '-------------------------------------------',
        LinhaTotal,
        '==========================================='
    ], '\n', Mensagem).

finalizar_compra(_, _, [], erro('Erro: O carrinho esta vazio!')) :- !.
finalizar_compra(Usuario, Catalogo, Carrinho, Resultado) :-
    atualizar_estoque_do_pedido(Catalogo, Carrinho, ResultadoEstoque),
    ( ResultadoEstoque = erro(Mensagem) ->
        Resultado = erro(Mensagem)
    ; ResultadoEstoque = ok(NovoCatalogo) ->
        visualizar_carrinho(Catalogo, Carrinho, Itens),
        calcular_total(Catalogo, Carrinho, Total),
        gerar_mensagem_sucesso(Usuario, Itens, Total, Mensagem),
        Resumo = resumo_pedido(Usuario, Itens, Total, Mensagem),
        Resultado = ok(NovoCatalogo, Resumo)
    ).
