:- module(usuario,
    [
        usuario_existe/2,
        buscar_usuario/3,
        cadastrar_usuario/5,
        autenticar_usuario/4
    ]).

% Estrutura:
% usuario(Nome, Email, Senha)

usuario_existe([usuario(_, Email, _)|_], Email).
usuario_existe([_|Usuarios], Email) :-
    usuario_existe(Usuarios, Email).

buscar_usuario([usuario(Nome, Email, Senha)|_],
            Email,
            usuario(Nome, Email, Senha)).

buscar_usuario([_|Usuarios], Email, Usuario) :-
    buscar_usuario(Usuarios, Email, Usuario).

cadastrar_usuario(Usuarios,
                Nome,
                Email,
                Senha,
                [usuario(Nome, Email, Senha)|Usuarios]) :-
    \+ usuario_existe(Usuarios, Email).

autenticar_usuario(
    [usuario(Nome, Email, Senha)|_],
    Email,
    Senha,
    usuario(Nome, Email, Senha)
).

autenticar_usuario([_|Usuarios], Email, Senha, Usuario) :-
    autenticar_usuario(Usuarios, Email, Senha, Usuario).