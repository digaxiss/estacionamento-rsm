# Header Navigation Component

Este componente fornece uma barra de navegação superior responsiva que pode ser facilmente incluída em qualquer página HTML de seu projeto.

![Header Navigation Preview](https://via.placeholder.com/800x100?text=Header+Navigation+Preview)

## Características

- Design responsivo que se adapta a diferentes tamanhos de tela
- Ativação automática do item de menu com base na página atual
- Fácil integração com qualquer página HTML
- Personalização simples de menus e usuário logado

## Como Utilizar

### 1. Inclusão dos Arquivos Necessários

Adicione os seguintes arquivos no cabeçalho (`<head>`) da sua página HTML:

```html
<!-- Font Awesome para ícones -->
<link
  rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
/>

<!-- Script do Header-Nav -->
<script src="/components/header-nav/header-nav.js"></script>
```

### 2. Preparando o Container

Adicione um div que servirá como container para o header no início do seu body:

```html
<div id="header-nav-container"></div>

<!-- Resto do conteúdo da sua página -->
```

### 3. Carregando o Header Dinamicamente

#### Método Simples (Padrão)

Adicione o seguinte código no final do seu HTML, antes do fechamento da tag `</body>`:

```html
<script>
  // Carrega o header com a página atual ativa
  loadHeaderNav('header-nav-container', 'dashboard')
</script>
```

Onde:

- `'header-nav-container'` é o ID do elemento onde o header será carregado
- `'dashboard'` é o nome da página atual (que será ativada no menu)

#### Método Avançado (Detecção Automática)

Para detectar automaticamente a página atual com base na URL:

```html
<script>
  // Extrai o nome da página da URL atual
  const currentPath = window.location.pathname
  const pageName = currentPath.split('/').filter(Boolean).pop().split('.')[0]

  // Carrega o header com a página detectada
  loadHeaderNav('header-nav-container', pageName)
</script>
```

### 4. Exemplos de Uso

#### Exemplo para a Página Dashboard

```html
<!DOCTYPE html>
<html lang="pt-br">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard - Estacionamento</title>

    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
    />
    <script src="/components/header-nav/header-nav.js"></script>
  </head>
  <body>
    <div id="header-nav-container"></div>

    <main>
      <h1>Dashboard</h1>
      <!-- Conteúdo da página -->
    </main>

    <script>
      loadHeaderNav('header-nav-container', 'dashboard')
    </script>
  </body>
</html>
```

#### Exemplo para a Página Relatórios

```html
<!DOCTYPE html>
<html lang="pt-br">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Relatórios - Estacionamento</title>

    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
    />
    <script src="/components/header-nav/header-nav.js"></script>
  </head>
  <body>
    <div id="header-nav-container"></div>

    <main>
      <h1>Relatórios</h1>
      <!-- Conteúdo da página -->
    </main>

    <script>
      loadHeaderNav('header-nav-container', 'relatorios')
    </script>
  </body>
</html>
```

## Personalizando o Menu Ativo

A função `loadHeaderNav` aceita dois parâmetros:

```javascript
loadHeaderNav(containerId, currentPage)
```

Onde:

- `containerId`: O ID do elemento HTML onde o header será renderizado
- `currentPage`: Nome da página atual que deverá ficar ativa no menu

Os valores válidos para `currentPage` são:

- `'dashboard'` - Para ativar o item Dashboard
- `'entrada'` - Para ativar o item Entrada
- `'saida'` - Para ativar o item Saída
- `'relatorios'` - Para ativar o item Relatórios
- `'configuracoes'` - Para ativar o item Configurações

## Estrutura de Pastas Recomendada

```
projeto/
├── components/
│   └── header-nav/
│       ├── header-nav.js
│       ├── header-nav.html
│       └── header-nav.css
├── src/
│   └── Pages/
│       ├── dashboard/
│       │   └── dashboard.html
│       ├── entrada/
│       │   └── entrada.html
│       ├── saida/
│       │   └── saida.html
│       └── relatorios/
│           └── relatorios.html
└── index.html
```

## Solução de Problemas

### O header não está sendo carregado

- Verifique se o caminho para `header-nav.js` está correto
- Verifique se o ID do container existe na sua página
- Abra o console do navegador para verificar possíveis erros

### Os ícones não aparecem

- Verifique se o link para o Font Awesome está corretamente incluído

### O item do menu não fica ativo

- Verifique se o nome da página passado corresponde exatamente ao `data-page` no header-nav.html
- O nome da página diferencia entre maiúsculas e minúsculas, então certifique-se de usar o formato correto
