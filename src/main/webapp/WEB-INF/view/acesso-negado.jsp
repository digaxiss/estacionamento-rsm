<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Acesso Negado - Estacionamento 24 Horas</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        background-color: #f5f5f5;
        margin: 0;
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
      }

      .container {
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        padding: 40px;
        max-width: 500px;
        width: 100%;
        text-align: center;
      }

      h1 {
        color: #dc3545;
        margin-top: 0;
      }

      .icon {
        font-size: 80px;
        margin-bottom: 20px;
        color: #dc3545;
      }

      p {
        color: #555;
        line-height: 1.6;
        margin-bottom: 30px;
      }

      .btn {
        display: inline-block;
        background-color: #30bced;
        color: #fff;
        text-decoration: none;
        padding: 12px 25px;
        border-radius: 4px;
        font-weight: bold;
        transition: background-color 0.3s;
      }

      .btn:hover {
        background-color: #27a8d3;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="icon">🔒</div>
      <h1>Acesso Negado</h1>
      <p>
        Você não tem permissão para acessar esta página. Esta funcionalidade está disponível apenas
        para administradores do sistema.
      </p>
      <a href="${pageContext.request.contextPath}/entrada" class="btn">Voltar para Entrada</a>
    </div>
  </body>
</html>
