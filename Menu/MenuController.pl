:- set_prolog_flag(source_search_working_directory, false).
:- use_module('../utils', [imprimir_arquivo_completo/1]).
:- use_module(userController, [pagina_do_usuario/0]).

% MENU INICIAL-------------------------------------------------------------------------------
menu_inicial :-
    imprimir_arquivo_completo('SpritesMenu/start_menu.txt'),
    write("Digite uma opção: "),
    read_line_to_string(user_input, Escolha),
    opcoes_menu_inicial(Escolha).

opcoes_menu_inicial(Escolha) :-
    string_lower(Escolha, Escolha_minuscula),
    (Escolha_minuscula == "l" 
    -> menu_login
    ; Escolha_minuscula == "c" 
    -> menu_cadastro
    ; mostrar_tente_novamente,
      menu_inicial).

% LOGIN ----------------------------------------------------------------------------------
menu_login :-
    imprimir_arquivo_completo('SpritesMenu/Login/faca_login.txt'),
    sleep(1.0),

    imprimir_arquivo_completo('SpritesMenu/Login/login_menu_email.txt'),
    write("Digite seu email: "),
    read_line_to_string(user_input, Email),

    imprimir_arquivo_completo('SpritesMenu/Login/login_menu_senha.txt'),
    write("Digite sua senha: "),
    read_line_to_string(user_input, Senha),

    fazer_login(Email, Senha). 

fazer_login(Email, Senha) :-
    (   verificar_usuario(Email, Senha) -> login_realizado;
        login_falhou).

login_realizado:-
    sleep(0.8),
    imprimir_arquivo_completo('SpritesMenu/Login/login_feito_feliz_menu.txt'),
    sleep(1.0),
    pagina_do_usuario.

%-CADASTRO---------------------------------------------------------------------------------
menu_cadastro :-
    imprimir_arquivo_completo('SpritesMenu/Cadastro/cadastro_nome_menu.txt'),
    write("Digite seu nome: "),
    read_line_to_string(user_input , Nome),

    imprimir_arquivo_completo('SpritesMenu/Cadastro/cadastro_email_menu.txt'),
    write("Digite seu email: "),
    read_line_to_string(user_input , Email),

    imprimir_arquivo_completo('SpritesMenu/Cadastro/cadastro_senha_menu.txt'),
    write("Digite sua senha: "),
    read_line_to_string(user_input , Senha),

    cadastrar_novo_usuario(Email, Senha, Nome).

cadastrar_novo_usuario(Email, Senha, Nome) :-
    (verificar_email(Email) -> usuario_ja_cadastrado;
        cadastrar_usuario(Email, Senha, Nome),
        cadastro_realizado ).

cadastrar_usuario(Email, Senha, Nome) :-
    open('SystemData/usuarios.txt', append, Stream),
    format(Stream, "~w:~w:~w~n", [Email, Senha, Nome]),
    close(Stream).

% VERIFICAÇÕES -------------------------------------------------------------------------------- 
verificar_usuario(Email, Senha) :-
    read_file_to_string('../SystemData/usuarios.txt', Conteudo, []),
    split_string(Conteudo, "\n", "", Linhas),
    member(Linha, Linhas),
    split_string(Linha, ":", "", [EmailArquivo, SenhaArquivo, _NomeArquivo]),
    Email == EmailArquivo,
    Senha == SenhaArquivo.

verificar_email(Email) :-
    read_file_to_string('../SystemData/usuarios.txt', Conteudo, []),
    split_string(Conteudo, "\n", "", Linhas),
    member(Linha, Linhas),
    split_string(Linha, ":", "", [EmailArquivo|_]),
    Email == EmailArquivo,
    !.

% EXCESSÕES E INTERMEIOS ------------------------------------------------------------------------------------

mostrar_tente_novamente :-
    imprimir_arquivo_completo('tente_novamente.txt').

usuario_ja_cadastrado :-
    imprimir_arquivo_completo('SpritesMenu/Cadastro/usuario_ja_existe.txt'),
    sleep(1.0),
    imprimir_arquivo_completo('SpritesMenu/tente_novamente.txt'),
    sleep(1.0),
    menu_inicial.

cadastro_realizado :-
    imprimir_arquivo_completo('SpritesMenu/Cadastro/cadastro_realizado.txt'),
    sleep(0.8),
    imprimir_arquivo_completo('SpritesMenu/Login/faca_login.txt'),
    sleep(0.8),
    menu_inicial.

login_falhou :-
    imprimir_arquivo_completo('SpritesMenu/Login/login_falhou_triste_menu.txt'),
    sleep(1),
    imprimir_arquivo_completo('SpritesMenu/tente_novamente.txt'),
    sleep(1),
    menu_inicial.

adeus :-
    imprimir_arquivo_completo('SpritesMenu/adeus.txt'),
    sleep(1.5),
    halt.

:- menu_inicial.