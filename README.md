# Carrinho de Compras - Prolog

Projeto desenvolvido para a disciplina Paradigmas de Linguagens da Programacao (PLP).

O sistema simula a logica de um carrinho de compras, com catalogo de produtos, controle de carrinho, usuarios, promocoes e finalizacao de pedido.

## Modulos

- `catalogo.pl`: lista produtos, busca por nome/categoria e atualiza estoque.
- `carrinho.pl`: adiciona, remove, atualiza e visualiza itens do carrinho.
- `usuario.pl`: cadastra, busca e autentica usuarios.
- `promocao.pl`: calcula e aplica descontos.
- `finalizacao.pl`: finaliza a compra, atualiza o estoque e gera o resumo do pedido.

## Fluxo

1. O usuario faz cadastro ou login.
2. O sistema mostra ou busca produtos no catalogo.
3. O usuario adiciona produtos ao carrinho.
4. O sistema aplica as promocoes.
5. A compra e finalizada e o estoque e atualizado.
