# Loja de Roupas

Aplicativo mobile desenvolvido em Flutter e Dart para gerenciamento de compras de uma loja de roupas, como atividade da disciplina de Programação para Dispositivos Móveis II, do curso de Desenvolvimento de Software Multiplataforma (DSM) da Fatec.

## Desenvolvedor

**Nome:** Guilherme Laurindo

## Tecnologias utilizadas

### Aplicativo Mobile
- Flutter
- Dart
- SQLite
- HTTP

### API
- Node.js
- Express
- PostgreSQL
- Render

## Funcionalidades

- Cadastro de compras, informando número da venda e valor.
- Armazenamento local utilizando SQLite.
- Integração com API própria.
- Persistência dos dados em banco PostgreSQL.
- Funcionamento offline-first.
- Identificação de compras sincronizadas e pendentes.
- Sincronização manual dos registros pendentes quando a conexão é restabelecida.

## API

A API foi desenvolvida em Node.js com Express e está hospedada no Render.

**URL:** https://loja-roupas-api.onrender.com

### Rotas disponíveis

| Método | Rota | Descrição |
|---|---|---|
| GET | `/` | Verifica se a API está funcionando. |
| GET | `/teste` | Testa a comunicação com a API. |
| GET | `/compras` | Lista as compras cadastradas. |
| POST | `/compras` | Cadastra uma nova compra. |

## Funcionamento Offline-First

O aplicativo tenta enviar os dados da compra para a API.

- Quando a API está disponível, a compra é cadastrada no PostgreSQL e identificada como sincronizada.
- Quando não há conexão com a API, a compra é armazenada localmente no SQLite como pendente.
- Quando a conexão é restabelecida, o usuário pode utilizar o botão de sincronização para enviar os registros pendentes ao servidor.

Após a sincronização, os registros são marcados como sincronizados no banco local.

## Banco de Dados

O projeto utiliza SQLite para armazenamento local e PostgreSQL hospedado no Render para armazenamento remoto.

A tabela `compras` possui os seguintes campos:

- `id`
- `numero_venda`
- `valor_compra`
- `sincronizado`
- `criado_em` (banco remoto)

## Projeto acadêmico

Atividade desenvolvida para a disciplina de Programação para Dispositivos Móveis II — 5º semestre do curso de Desenvolvimento de Software Multiplataforma (DSM), Fatec.