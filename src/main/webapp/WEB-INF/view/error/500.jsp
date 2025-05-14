<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="pt-br">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Erro no Sistema - Estacionamento 24 Horas</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        background-color: #f5f5f5;
        margin: 0;
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
      }

      .container {
        max-width: 600px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        padding: 30px;
        text-align: center;
      }

      h1 {
        color: #dc3545;
        margin-top: 0;
      }

      .error-icon {
        font-size: 80px;
        margin-bottom: 20px;
        color: #dc3545;
      }

      p {
        color: #666;
        line-height: 1.6;
      }

      .btn {
        display: inline-block;
        background-color: #30bced;
        color: #fff;
        text-decoration: none;
        padding: 10px 20px;
        border-radius: 4px;
        margin-top: 20px;
        transition: background-color 0.3s;
      }

      .btn:hover {
        background-color: #27a8d3;
      }

      .error-details {
        margin-top: 30px;
        padding: 15px;
        background-color: #f8f9fa;
        border-radius: 4px;
        text-align: left;
        font-size: 14px;
        color: #666;
        display: none;
      }

      .toggle-details {
        cursor: pointer;
        color: #0066cc;
        text-decoration: underline;
        margin-top: 10px;
        display: inline-block;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="error-icon">⚠️</div>
      <h1>Erro no Sistema</h1>
      <p>Ocorreu um erro inesperado ao processar sua solicitação.</p>
      <p>Nossa equipe técnica foi notificada e está trabalhando para resolver o problema.</p>

      <a href="${pageContext.request.contextPath}/dashboard" class="btn">Voltar para o Dashboard</a>

      <p>
        <a href="#" class="toggle-details" onclick="toggleDetails(); return false;"
          >Mostrar detalhes técnicos</a
        >
      </p>

      <div class="error-details" id="errorDetails">
        <h3>Detalhes técnicos:</h3>
        <p><%= exception != null ? exception.getMessage() : "Erro desconhecido" %></p>
        <% if (exception != null) { %>
        <pre>
                    <% exception.printStackTrace(new java.io.PrintWriter(out)); %>
                </pre
        >
        <% } %>
      </div>
    </div>

    <script>
      function toggleDetails() {
        var details = document.getElementById('errorDetails')
        if (details.style.display === 'none' || details.style.display === '') {
          details.style.display = 'block'
          document.querySelector('.toggle-details').textContent = 'Ocultar detalhes técnicos'
        } else {
          details.style.display = 'none'
          document.querySelector('.toggle-details').textContent = 'Mostrar detalhes técnicos'
        }
      }
    </script>
  </body>
</html>
