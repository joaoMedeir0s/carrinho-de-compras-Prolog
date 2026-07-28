:- module(catalogo, [
    listar_em_estoque/2,
    buscar_por_categoria/3,
    buscar_por_nome/3,
    atualizar_estoque/4
]).

% Formato do produto:
% produto(Id, Nome, Preco, Descricao, Estoque, Categoria)

% Lista apenas produtos com estoque maior que zero
listar_em_estoque([], []).
listar_em_estoque([produto(Id, Nome, Preco, Descricao, Estoque, Categoria) | Cauda], [produto(Id, Nome, Preco, Descricao, Estoque, Categoria) | Resultado]) :-
    Estoque > 0,
    !,
    listar_em_estoque(Cauda, Resultado).
listar_em_estoque([_ | Cauda], Resultado) :-
    listar_em_estoque(Cauda, Resultado).

% Busca por categoria
buscar_por_categoria([], _, []).
buscar_por_categoria([produto(Id, Nome, Preco, Descricao, Estoque, CatProd) | Cauda], CatBuscada, [produto(Id, Nome, Preco, Descricao, Estoque, CatProd) | Resultado]) :-
    CatProd == CatBuscada,
    !,
    buscar_por_categoria(Cauda, CatBuscada, Resultado).
buscar_por_categoria([_ | Cauda], CatBuscada, Resultado) :-
    buscar_por_categoria(Cauda, CatBuscada, Resultado).

% Busca por nome
buscar_por_nome([], _, []).
buscar_por_nome([produto(Id, Nome, Preco, Descricao, Estoque, Categoria) | Cauda], Termo, [produto(Id, Nome, Preco, Descricao, Estoque, Categoria) | Resultado]) :-
    string_lower(Nome, NomeLower),
    string_lower(Termo, TermoLower),
    sub_string(NomeLower, _, _, _, TermoLower),
    !,
    buscar_por_nome(Cauda, Termo, Resultado).
buscar_por_nome([_ | Cauda], Termo, Resultado) :-
    buscar_por_nome(Cauda, Termo, Resultado).

% Atualiza o estoque de um ID específico
atualizar_estoque([], _, _, []).
atualizar_estoque([produto(IdBuscado, Nome, Preco, Descricao, _, Categoria) | Cauda], IdBuscado, NovoEstoque, [produto(IdBuscado, Nome, Preco, Descricao, NovoEstoque, Categoria) | Cauda]) :-
    !.
atualizar_estoque([Par | Cauda], IdBuscado, NovoEstoque, [Par | Resultado]) :-
    atualizar_estoque(Cauda, IdBuscado, NovoEstoque, Resultado).
