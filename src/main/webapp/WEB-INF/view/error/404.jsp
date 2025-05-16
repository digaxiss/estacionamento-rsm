<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="pt-br">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Página não encontrada - Estacionamento RSM</title>
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
        color: #30bced;
        margin-top: 0;
      }

      .error-code {
        font-size: 120px;
        font-weight: bold;
        color: #30bced;
        line-height: 1;
        margin: 0;
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
    </style>
  </head>
  <body>
    <div class="container">
      <h1>Página não encontrada</h1>
      <p class="error-code">404</p>
      <p>A página que você está procurando não existe ou foi removida.</p>

      <a href="${pageContext.request.contextPath}/dashboard" class="btn">Voltar para o Dashboard</a>
    </div>
  </body>
</html>
