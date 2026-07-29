# Carrinho de Compras - Prolog

Projeto desenvolvido para a disciplina Paradigmas de Linguagens da Programação (PLP).

O sistema simula a lógica de um carrinho de compras, com catálogo de produtos, controle de carrinho, usuários, promoções e finalização de pedido.

## Módulos

- `catalogo.pl`: lista produtos, busca por nome/categoria e atualiza estoque.
- `carrinho.pl`: adiciona, remove, atualiza e visualiza itens do carrinho.
- `usuario.pl`: cadastra, busca e autentica usuários.
- `promocao.pl`: calcula e aplica descontos.
- `finalizacao.pl`: finaliza a compra, atualiza o estoque e gera o resumo do pedido.

## Fluxo

1. O usuário faz cadastro ou login.
2. O sistema mostra ou busca produtos no catálogo.
3. O usuário adiciona produtos ao carrinho.
4. O sistema aplica as promoções.
5. A compra é finalizada e o estoque é atualizado.
