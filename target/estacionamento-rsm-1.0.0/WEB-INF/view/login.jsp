<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <!DOCTYPE html>
  <html lang="pt-br">

  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login - Estacionamento RSM</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        background-color: #2d2d2d;
        margin: 0;
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
      }

      .login-container {
        background-color: #333;
        border-radius: 8px;
        padding: 30px;
        width: 350px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        border: 2px solid #30bced;
      }

      h1 {
        text-align: center;
        color: #fff;
        margin-bottom: 30px;
        font-size: 28px;
        text-transform: uppercase;
      }

      .form-group {
        margin-bottom: 20px;
      }

      label {
        display: block;
        color: #fff;
        margin-bottom: 8px;
      }

      input[type='email'],
      input[type='password'] {
        width: 100%;
        padding: 12px;
        border-radius: 5px;
        border: 1px solid #ddd;
        box-sizing: border-box;
        font-size: 16px;
      }

      .btn-login {
        background-color: #30bced;
        color: #fff;
        border: none;
        padding: 12px 20px;
        border-radius: 5px;
        width: 100%;
        font-size: 16px;
        cursor: pointer;
        transition: background-color 0.3s;
      }

      .btn-login:hover {
        background-color: #27a8d3;
      }

      .error-message {
        color: #ff6b6b;
        margin-bottom: 20px;
        text-align: center;
      }

      .logo {
        text-align: center;
        margin-bottom: 20px;
      }

      .logo h2 {
        color: #30bced;
        font-size: 24px;
        margin: 0;
      }

      .logo span {
        color: #fff;
        font-size: 12px;
      }
    </style>
    <!-- Link para CSS externo quando separar -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/login.css" disabled>
  </head>

  <body>
    <div class="login-container">
      <div class="logo">
        <h2>ESTACIONAMENTO RSM</h2>
      </div>

      <h1>Login</h1>

      <!-- Exibe mensagem de erro se houver -->
      <% if(request.getAttribute("mensagemErro") !=null) { %>
        <div class="error-message">
          <%= request.getAttribute("mensagemErro") %>
        </div>
        <% } %>

          <form action="<%= request.getContextPath() %>/login" method="post">
            <div class="form-group">
              <label for="email">Email</label>
              <input type="email" id="email" name="email" required />
            </div>

            <div class="form-group">
              <label for="senha">Senha</label>
              <input type="password" id="senha" name="senha" required />
            </div>

            <button type="submit" class="btn-login">Entrar</button>
          </form>
    </div>
  </body>

  </html>