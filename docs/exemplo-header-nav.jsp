<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib uri="jakarta.tags.core"
prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Exemplo de Implementação do Header-Nav</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f0f2f5;
      }

      .container {
        max-width: 1000px;
        margin: 30px auto;
        padding: 25px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }

      h1 {
        color: #333;
        border-bottom: 2px solid #30bced;
        padding-bottom: 15px;
        margin-top: 0;
      }

      pre {
        background-color: #f8f9fa;
        padding: 15px;
        border-radius: 4px;
        overflow-x: auto;
        border: 1px solid #ddd;
      }

      code {
        font-family: Consolas, Monaco, 'Andale Mono', monospace;
        color: #333;
      }

      .note {
        background-color: #e7f3fe;
        border-left: 4px solid #2196f3;
        padding: 15px;
        margin: 20px 0;
      }

      .warning {
        background-color: #fff3cd;
        border-left: 4px solid #ffc107;
        padding: 15px;
        margin: 20px 0;
      }
    </style>
  </head>
  <body>
    <!-- Aqui é onde o header-nav seria incluído em uma implementação real -->
    <!-- <jsp:include page="components/header-nav.jsp" /> -->

    <!-- Simulação do header-nav apenas para demonstração visual -->
    <header
      style="
        display: flex;
        justify-content: space-between;
        align-items: center;
        background-color: #2d2d2d;
        color: #fff;
        padding: 10px 20px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
      "
    >
      <div>
        <h2 style="color: #30bced; margin: 0; font-size: 22px">ESTACIONAMENTO 24H</h2>
      </div>

      <nav>
        <ul style="display: flex; list-style: none; margin: 0; padding: 0">
          <li style="margin: 0 15px">
            <a
              href="#"
              style="
                color: #fff;
                text-decoration: none;
                font-size: 16px;
                padding: 10px 0;
                display: inline-block;
              "
              >Dashboard</a
            >
          </li>
          <li style="margin: 0 15px">
            <a
              href="#"
              style="
                color: #fff;
                text-decoration: none;
                font-size: 16px;
                padding: 10px 0;
                display: inline-block;
              "
              >Entrada</a
            >
          </li>
          <li style="margin: 0 15px">
            <a
              href="#"
              style="
                color: #fff;
                text-decoration: none;
                font-size: 16px;
                padding: 10px 0;
                display: inline-block;
              "
              >Saída</a
            >
          </li>
          <li style="margin: 0 15px">
            <a
              href="#"
              style="
                color: #fff;
                text-decoration: none;
                font-size: 16px;
                padding: 10px 0;
                display: inline-block;
              "
              >Relatórios</a
            >
          </li>
          <li style="margin: 0 15px">
            <a
              href="#"
              style="
                color: #30bced;
                text-decoration: none;
                font-size: 16px;
                padding: 10px 0;
                display: inline-block;
              "
              >Administração</a
            >
          </li>
        </ul>
      </nav>

      <div style="display: flex; align-items: center">
        <span style="margin-right: 15px">Usuário Demo</span>
        <a
          href="#"
          style="
            background-color: #ff6b6b;
            color: #fff;
            padding: 6px 12px;
            border-radius: 4px;
            text-decoration: none;
          "
          >Sair</a
        >
      </div>
    </header>

    <div class="container">
      <h1>Implementação do Header-Nav</h1>

      <p>
        Este é um exemplo visual de como o componente header-nav aparecerá quando implementado
        corretamente em suas páginas JSP.
      </p>

      <div class="note">
        <strong>Nota:</strong> Para implementação real, consulte o arquivo README.md na pasta docs.
      </div>

      <h2>Código de Inclusão</h2>

      <p>Este é o código que você precisará adicionar ao corpo de suas páginas JSP:</p>

      <pre><code>&lt;!-- Inclusão do cabeçalho e navegação --&gt;
&lt;jsp:include page="components/header-nav.jsp" /&gt;</code></pre>

      <div class="warning">
        <strong>Importante:</strong> Certifique-se de ajustar o caminho do arquivo conforme a
        estrutura de diretórios do seu projeto.
      </div>

      <h2>Verificação de Permissões</h2>

      <p>
        O componente automaticamente verifica o nível de acesso do usuário através do atributo
        <code>nivelAcesso</code> na sessão e exibe ou oculta a opção "Administração" com base nessa
        verificação.
      </p>

      <pre><code>// Trecho do código header-nav.jsp
&lt;%
    String nivelAcesso = (String) session.getAttribute("nivelAcesso");
    boolean isAdmin = "administrador".equals(nivelAcesso);
%&gt;

// ...

&lt;% if(isAdmin) { %&gt;
&lt;li class="&lt;%= currentPage.contains("/admin") ? "active" : "" %&gt;"&gt;
    &lt;a href="${pageContext.request.contextPath}/admin/dashboard"&gt;Administração&lt;/a&gt;
&lt;/li&gt;
&lt;% } %&gt;</code></pre>
    </div>
  </body>
</html>
