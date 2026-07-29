:- module(promocao, [
    calcular_desconto/2,
    aplicar_desconto/2
]).

% 15%
calcular_desconto(Subtotal, Desconto) :-
    Subtotal >= 2000,
    !,
    Desconto is Subtotal * 0.15.

% 10%
calcular_desconto(Subtotal, Desconto) :-
    Subtotal >= 1000,
    !,
    Desconto is Subtotal * 0.10.

% 5%
calcular_desconto(Subtotal, Desconto) :-
    Subtotal >= 500,
    !,
    Desconto is Subtotal * 0.05.

% 3%
calcular_desconto(Subtotal, Desconto) :-
    Subtotal >= 200,
    !,
    Desconto is Subtotal * 0.03.

% Sem desconto
calcular_desconto(_, 0).

aplicar_desconto(Subtotal, TotalFinal) :-
    calcular_desconto(Subtotal, Desconto),
    TotalFinal is Subtotal - Desconto.