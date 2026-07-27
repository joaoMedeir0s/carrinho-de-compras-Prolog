:- module(catalogo, [
    listar_em_estoque/2,
    buscar_por_categoria/3,
    buscar_por_nome/3,
    atualizar_estoque/4
]).

% Lista apenas produtos com estoque maior que zero
listar_em_estoque([], []).
listar_em_estoque([_Key - produto(Nome, Cat, Preco, Estoque) | Cauda], [produto(Nome, Cat, Preco, Estoque) | Resultado]) :-
    Estoque > 0,
    !,
    listar_em_estoque(Cauda, Resultado).
listar_em_estoque([_ | Cauda], Resultado) :-
    listar_em_estoque(Cauda, Resultado).

% Busca por categoria
buscar_por_categoria([], _, []).
buscar_por_categoria([_Key - produto(Nome, CatProd, Preco, Estoque) | Cauda], CatBuscada, [produto(Nome, CatProd, Preco, Estoque) | Resultado]) :-
    CatProd == CatBuscada,
    !,
    buscar_por_categoria(Cauda, CatBuscada, Resultado).
buscar_por_categoria([_ | Cauda], CatBuscada, Resultado) :-
    buscar_por_categoria(Cauda, CatBuscada, Resultado).

% Busca por nome
buscar_por_nome([], _, []).
buscar_por_nome([_Key - produto(Nome, Cat, Preco, Estoque) | Cauda], Termo, [produto(Nome, Cat, Preco, Estoque) | Resultado]) :-
    string_lower(Nome, NomeLower),
    string_lower(Termo, TermoLower),
    sub_string(NomeLower, _, _, _, TermoLower),
    !,
    buscar_por_nome(Cauda, Termo, Resultado).
buscar_por_nome([_ | Cauda], Termo, Resultado) :-
    buscar_por_nome(Cauda, Termo, Resultado).

% Atualiza o estoque de um ID específico
atualizar_estoque([], _, _, []).
atualizar_estoque([IdBuscado - produto(Nome, Cat, Preco, _) | Cauda], IdBuscado, NovoEstoque, [IdBuscado - produto(Nome, Cat, Preco, NovoEstoque) | Cauda]) :-
    !.
atualizar_estoque([Par | Cauda], IdBuscado, NovoEstoque, [Par | Resultado]) :-
    atualizar_estoque(Cauda, IdBuscado, NovoEstoque, Resultado).
