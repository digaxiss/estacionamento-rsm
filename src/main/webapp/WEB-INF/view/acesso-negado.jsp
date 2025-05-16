<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <!DOCTYPE html>
  <html lang="pt-br">

  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Acesso Negado - Estacionamento RSM</title>
    <style>
      body {
        font-family: 'Segoe UI', Arial, sans-serif;
        background-color: #2a2b30;
        margin: 0;
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        color: #f8f9fa;
      }

      .container {
        background-color: #232429;
        border-radius: 8px;
        box-shadow: 0 0 0 2px #dc3545;
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
        color: #b0bec5;
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
        transition: background-color 0.3s, transform 0.2s;
      }

      .btn:hover {
        background-color: #27a8d3;
        transform: translateY(-2px);
      }

      .btn-secondary {
        background-color: #6c757d;
        margin-left: 10px;
      }

      .btn-secondary:hover {
        background-color: #5a6268;
      }

      .actions {
        display: flex;
        justify-content: center;
      }

      @media (max-width: 768px) {
        .container {
          margin: 0 20px;
          padding: 30px 20px;
        }

        .actions {
          flex-direction: column;
        }

        .btn {
          display: block;
          margin: 10px 0;
        }

        .btn-secondary {
          margin-left: 0;
        }
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
      <div class="actions">
        <a href="${pageContext.request.contextPath}/dashboard" class="btn">Ir para Dashboard</a>
        <a href="${pageContext.request.contextPath}/entrada" class="btn btn-secondary">Ir para Entrada</a>
      </div>
    </div>
  </body>

  </html>