
# Template de Microsserviços — Laravel

Uma base para construir microsserviços com Laravel, orientada a APIs e pronta para uso com Docker.

## Principais versões

- PHP: ^8.2
- Laravel: ^12.0

## Sumário

- Sobre
- Requisitos
- Inicialização rápida (Docker)
- Comandos úteis
- Estrutura do projeto
- Boas práticas e sugestões
- Contribuição
- Licença

## Sobre

Este repositório fornece um template inicial para microsserviços usando Laravel. O foco é simplificar o setup local (via Docker) e fornecer uma estrutura clara para APIs.

## Requisitos

- Docker & docker-compose
- PHP >= 8.2 (quando executar localmente sem Docker)
- Composer (geralmente executado dentro do container)

## Inicialização rápida (Docker)

1. Subir e construir containers (constrói a imagem e instala dependências):

```bash
docker-compose up -d --build
```

2. Criar arquivo de ambiente e gerar chave da aplicação:

```bash
docker-compose exec app cp .env.example .env
docker-compose exec app php artisan key:generate
```

3. (Opcional) Instalar dependências manualmente no container:

```bash
docker-compose exec app composer install
```

Depois disso, a aplicação estará acessível em http://localhost (verifique as portas no `docker-compose.yml`).

## Variáveis de ambiente

Copie `.env.example` para `.env` e ajuste valores conforme necessário (banco, fila, serviços externos). Valores comuns a verificar:

- APP_ENV
- APP_DEBUG
- DB_CONNECTION, DB_HOST, DB_PORT, DB_DATABASE, DB_USERNAME, DB_PASSWORD
- QUEUE_CONNECTION

## Comandos úteis

- Rodar migrações:

```bash
docker-compose exec app php artisan migrate
```

- Rodar testes (PHPUnit/Laravel):

```bash
docker-compose exec app php artisan test
```

- Limpar caches e otimizar:

```bash
docker-compose exec app php artisan optimize:clear
```

- Acessar shell do container:

```bash
docker-compose exec app bash
```

- Rodar seeders:

```bash
docker-compose exec app php artisan db:seed
```

- Rodar migrations reset (aviso: apaga dados):

```bash
docker-compose exec app php artisan migrate:fresh --seed
```

## Estrutura do projeto (visão rápida)

- `app/` — Modelos, Controladores, Providers
- `app/Domain` — Entidades
- `bootstrap/` — Inicialização do framework
- `config/` — Arquivos de configuração
- `database/` — Migrations, seeders e factories
- `public/` — Front controller e assets
- `routes/` — Definições de rotas (`api.php`)
- `storage/` — Logs, cache, uploads
- `tests/` — Testes automatizados

Veja o repositório para mais detalhes e adaptações específicas para microsserviços.

## Boas práticas e sugestões

- Mantenha as variáveis sensíveis fora do controle de versão (`.env`).
- Use migrations e seeders para reproduzir ambiente de desenvolvimento.
- Documente endpoints principais em um arquivo separado (por exemplo, `docs/` ou Swagger/OpenAPI).
- Considere um pipeline CI que rode linter, testes e análise estática.

## Contribuições

Contribuições são bem-vindas. Para contribuir:

1. Fork o repositório
2. Crie uma branch com sua feature/bugfix
3. Abra um Pull Request descrevendo as mudanças

## Licença

Este projeto usa a licença MIT (verifique a raiz do projeto para o arquivo LICENSE).

---
