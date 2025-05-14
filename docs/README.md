# Documentação do Componente Header-Nav

Este documento explica como utilizar o componente Header-Nav em novos projetos JSP, incluindo a funcionalidade de validação de permissões para exibir ou ocultar opções do menu conforme o nível de acesso do usuário.

## Estrutura do Componente

O componente header-nav consiste em:

1. **Arquivo JSP do cabeçalho**: Contém HTML, CSS e lógica para renderizar o menu de navegação
2. **Verificação de permissões**: Verifica o nível de acesso do usuário para mostrar ou ocultar opções
3. **Estilização integrada**: CSS embutido para facilitar a portabilidade
4. **Ícones Font Awesome**: Elementos visuais para melhorar a usabilidade

## Como Utilizar em Novos Projetos

### Passo 1: Copiar o Arquivo do Componente

Copie o arquivo `header-nav.jsp` para o diretório `WEB-INF/view/components/` do seu novo projeto.

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    String nivelAcesso = (String) session.getAttribute("nivelAcesso");
    boolean isAdmin = "administrador".equals(nivelAcesso);

    // Obtém a URL atual para destacar o menu ativo
    String requestURI = request.getRequestURI();
    String contextPath = request.getContextPath();
    String currentPage = requestURI.substring(contextPath.length());
%>

<header class="main-header">
    <div class="header-content">
        <div class="logo">
            <h1><i class="fas fa-parking"></i> Estacionamento</h1>
        </div>

        <nav class="main-nav">
            <ul>
                <li>
                    <a href="${pageContext.request.contextPath}/dashboard" class="<%= currentPage.contains("/dashboard") ? "active" : "" %>">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/entrada" class="<%= currentPage.contains("/entrada") ? "active" : "" %>">
                        <i class="fas fa-car"></i> Entrada
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/saida" class="<%= currentPage.contains("/saida") ? "active" : "" %>">
                        <i class="fas fa-sign-out-alt"></i> Saída
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/relatorio" class="<%= currentPage.contains("/relatorio") ? "active" : "" %>">
                        <i class="fas fa-chart-bar"></i> Relatórios
                    </a>
                </li>
                <% if(isAdmin) { %>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="<%= currentPage.contains("/admin") ? "active" : "" %>">
                        <i class="fas fa-cog"></i> Administração
                    </a>
                </li>
                <% } %>
            </ul>
        </nav>

        <div class="user-info">
            <div class="user-info-name">
                <p>Olá,</p>
                <span>${sessionScope.usuarioLogado.nome}</span>
            </div>
            <a href="${pageContext.request.contextPath}/login/logout" class="btn btn-primary">Sair</a>
        </div>
    </div>
</header>

<style>
    /* Variáveis para cores e estilos */
    :root {
        --primary-color: #40c4ff;
        --primary-dark: #0094cc;
        --text-color: #ffffff;
        --light-text: #b0bec5;
        --border-color: #424242;
        --card-bg: #2c2c2c;
        --transition: all 0.3s ease;
        --border-radius: 5px;
    }

    /* Estilo para o header principal */
    .main-header {
        background-color: #1a1a1a;
        width: 100%;
        padding: 0;
        box-shadow: none;
        height: 60px;
        border-bottom: 1px solid #333;
        display: flex;
        align-items: stretch;
    }

    /* Conteúdo do header - ajustado para centralizar */
    .header-content {
        width: 100%;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 20px;
    }

    /* Estilo do logo */
    .logo {
        display: flex;
        align-items: center;
        width: 220px;
    }

    .logo h1 {
        color: var(--primary-color);
        font-size: 1.1rem;
        margin: 0;
        font-weight: 500;
        white-space: nowrap;
    }

    /* Navegação principal - centralizada */
    .main-nav {
        flex: 1;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .main-nav ul {
        display: flex;
        list-style: none;
        padding: 0;
        margin: 0;
        justify-content: center;
    }

    .main-nav ul li {
        display: flex;
        align-items: center;
        height: 60px;
    }

    .main-nav ul li a {
        display: flex;
        align-items: center;
        height: 100%;
        gap: 3px;
        text-decoration: none;
        color: var(--light-text);
        transition: var(--transition);
        font-size: 0.9rem;
        font-weight: 400;
        border: none;
        padding: 0 15px;
    }

    .main-nav ul li a:hover {
        color: var(--primary-color);
        background-color: transparent;
    }

    .main-nav ul li a.active {
        color: var(--primary-color);
        background-color: #252525;
    }

    /* Informações do usuário */
    .user-info {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        width: 220px;
    }

    .user-info-name {
        display: flex;
        align-items: center;
    }

    .user-info p {
        display: inline;
        margin-right: 5px;
        color: #888;
        font-size: 0.85rem;
    }

    .user-info span {
        color: white;
        font-size: 0.85rem;
        font-weight: 400;
    }

    .user-info .btn {
        background-color: var(--primary-color);
        color: #212121;
        border: none;
        border-radius: 3px;
        padding: 0.2rem 0.6rem;
        font-size: 0.75rem;
        margin-left: 15px;
        cursor: pointer;
        text-decoration: none;
    }

    /* Responsive design */
    @media (max-width: 992px) {
        .logo,
        .user-info {
            width: auto;
        }
    }

    @media (max-width: 768px) {
        .header-content {
            flex-direction: column;
            height: auto;
            padding: 10px;
        }

        .main-nav {
            order: 3;
            width: 100%;
        }

        .main-nav ul {
            flex-direction: row;
            flex-wrap: wrap;
            width: 100%;
        }

        .main-nav ul li {
            height: 40px;
        }

        .user-info {
            width: 100%;
            justify-content: space-between;
            margin: 10px 0;
        }
    }
</style>

<!-- Incluir Font Awesome para os ícones -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
```

### Passo 2: Incluir o Cabeçalho nas Páginas JSP

Para incluir o cabeçalho em qualquer página JSP, adicione o seguinte código no corpo da página:

```jsp
<!-- Inclusão do cabeçalho e navegação -->
<jsp:include page="components/header-nav.jsp" />
```

> **Nota**: Ajuste o caminho do arquivo conforme a estrutura de diretórios do seu projeto.
> Para páginas em subdiretórios, use caminhos relativos. Exemplo:
>
> ```jsp
> <jsp:include page="../components/header-nav.jsp" />
> ```

### Passo 3: Configuração do Sistema de Autenticação

Para que a verificação de permissões funcione corretamente, você precisa:

1. **Criar o modelo de Usuário**: Inclua o campo `nivelAcesso` para diferenciar tipos de usuário

   ```java
   public class Usuario {
       private int id;
       private String nome;
       private String email;
       private String senha;
       private String nivelAcesso; // "administrador" ou "operador"

       // Getters e setters
   }
   ```

2. **Armazenar o nível de acesso na sessão**: Durante o login, adicione o nível de acesso à sessão

   ```java
   // No LoginController
   protected void doPost(HttpServletRequest request, HttpServletResponse response) {
       // Autenticação...
       if (usuario != null) {
           HttpSession session = request.getSession();
           session.setAttribute("usuarioLogado", usuario);
           session.setAttribute("nivelAcesso", usuario.getNivelAcesso());

           // Redirecionar...
       }
   }
   ```

3. **Criar um filtro de autorização**: Para proteger URLs administrativas

   ```java
   @WebFilter("/admin/*")
   public class AdminAuthFilter implements Filter {
       public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
               throws IOException, ServletException {
           HttpServletRequest request = (HttpServletRequest) req;
           HttpServletResponse response = (HttpServletResponse) resp;
           HttpSession session = request.getSession(false);

           String nivelAcesso = (session != null) ?
                   (String) session.getAttribute("nivelAcesso") : null;

           if (!"administrador".equals(nivelAcesso)) {
               response.sendRedirect(request.getContextPath() + "/acesso-negado");
               return;
           }

           chain.doFilter(request, response);
       }
   }
   ```

### Passo 4: Personalização do Componente

Você pode personalizar o componente de várias formas:

#### Alterando o Logo

Modifique o texto ou o ícone:

```html
<div class="logo">
  <h1><i class="fas fa-building"></i> Minha Empresa</h1>
  <!-- Ou use uma imagem -->
  <!-- <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo"> -->
</div>
```

#### Adicionando Novas Opções de Menu

Para adicionar novas opções, insira novos itens na lista:

```html
<nav class="main-nav">
    <ul>
        <!-- Itens existentes -->
        <li>
            <a href="${pageContext.request.contextPath}/nova-funcionalidade" class="<%= currentPage.contains("/nova-funcionalidade") ? "active" : "" %>">
                <i class="fas fa-star"></i> Nova Funcionalidade
            </a>
        </li>
    </ul>
</nav>
```

#### Adicionando Níveis de Acesso Adicionais

Para ter mais níveis de acesso além de "administrador":

```jsp
<%
    String nivelAcesso = (String) session.getAttribute("nivelAcesso");
    boolean isAdmin = "administrador".equals(nivelAcesso);
    boolean isGerente = "gerente".equals(nivelAcesso);
%>

<!-- No menu: -->
<% if(isAdmin || isGerente) { %>
    <li>
        <a href="${pageContext.request.contextPath}/relatorios-avancados" class="<%= currentPage.contains("/relatorios-avancados") ? "active" : "" %>">
            <i class="fas fa-chart-line"></i> Relatórios Avançados
        </a>
    </li>
<% } %>

<% if(isAdmin) { %>
    <li>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="<%= currentPage.contains("/admin") ? "active" : "" %>">
            <i class="fas fa-cog"></i> Administração
        </a>
    </li>
<% } %>
```

## Dicas e Boas Práticas

1. **Sessão de Usuário**: Certifique-se de que a sessão esteja configurada corretamente no `web.xml`:

   ```xml
   <session-config>
       <session-timeout>30</session-timeout>
   </session-config>
   ```

2. **Proteção contra Acessos Não Autorizados**: Use filtros para proteger URLs restritas, não dependa apenas da ocultação dos links no menu.

3. **Padronização de Nomes de Atributos**: Mantenha a mesma convenção de nomes para atributos de sessão em todo o projeto.

4. **Tratamento de Erros**: Adicione tratamento para casos em que o usuário não esteja logado ou ocorra algum erro na renderização.

5. **Responsividade**: O CSS já é responsivo, mas você pode adicionar mais regras específicas para seu projeto.

## Solução de Problemas

### O Menu Não Está Aparecendo

- Verifique se o caminho para o arquivo JSP está correto
- Certifique-se de que o diretório `/components/` existe
- Verifique se as bibliotecas JSTL estão configuradas no projeto
- Confirme se o Font Awesome está sendo carregado corretamente

### Links do Menu Não Funcionam

- Verifique se o `contextPath` está sendo obtido corretamente
- Confirme se os servlets estão mapeados corretamente no `web.xml` ou com anotações `@WebServlet`

### A Validação de Permissões Não Funciona

- Confirme se o atributo "nivelAcesso" está sendo armazenado na sessão durante o login
- Verifique se o tipo do atributo corresponde ao usado na comparação (String vs. Object)
- Examine o valor do atributo com ferramentas de debug ou logs

### Os Ícones Não Aparecem

- Verifique se a linha de inclusão do Font Awesome está presente no header-nav.jsp
- Teste se o link para o CDN do Font Awesome está acessível
- Confirme se os nomes das classes dos ícones estão corretos (ex: "fas fa-tachometer-alt")

## Exemplo Completo

Veja um exemplo completo de uma página JSP que utiliza o componente:

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Minha Página - Sistema</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }

        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            color: #333;
            border-bottom: 2px solid #30bced;
            padding-bottom: 10px;
        }
    </style>
</head>
<body>
    <!-- Inclusão do cabeçalho e navegação -->
    <jsp:include page="components/header-nav.jsp" />

    <div class="container">
        <h1>Minha Página</h1>
        <p>Conteúdo da página...</p>
    </div>
</body>
</html>
```

---

Este guia fornece as informações essenciais para implementar e personalizar o componente header-nav em seus projetos JSP. Para mais detalhes ou suporte, consulte a documentação completa do projeto ou entre em contato com a equipe de desenvolvimento.
