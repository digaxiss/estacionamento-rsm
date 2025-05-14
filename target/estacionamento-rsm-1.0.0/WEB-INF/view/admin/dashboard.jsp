<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib uri="jakarta.tags.core" prefix="c" %>
    <!DOCTYPE html>
    <html lang="pt-br">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Administração - Estacionamento 24 Horas</title>
      <style>
        body {
          font-family: 'Segoe UI', sans-serif;
          background-color: #2a2b30;
          color: #ffffff;
          margin: 0;
          padding: 0;
        }

        .container {
          max-width: 1200px;
          margin: 0 auto;
          padding: 20px;
        }

        .content {
          background-color: #2a2b30;
          border-radius: 8px;
          box-shadow: 0 0 0 2px #00bfff;
          padding: 20px;
        }

        h1 {
          color: #ffffff;
          border-bottom: 2px solid #30bced;
          padding-bottom: 10px;
          margin-top: 0;
          text-align: center;
          font-size: 32px;
        }

        .admin-cards {
          display: flex;
          flex-wrap: wrap;
          gap: 20px;
          margin-top: 20px;
        }

        .admin-card {
          background-color: #333;
          border-radius: 8px;
          padding: 20px;
          flex: 1;
          min-width: 250px;
          box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
          transition: transform 0.3s, box-shadow 0.3s;
          text-decoration: none;
          color: #ffffff;
        }

        .admin-card:hover {
          transform: translateY(-5px);
          box-shadow: 0 5px 15px rgba(0, 0, 0, 0.5);
          border: 1px solid #30bced;
        }

        .admin-card h2 {
          color: #30bced;
          margin-top: 0;
        }

        .admin-card p {
          margin-bottom: 0;
          color: #b0bec5;
        }

        .admin-card .icon {
          font-size: 48px;
          margin-bottom: 10px;
          color: #30bced;
        }

        .mensagem {
          padding: 15px;
          margin-bottom: 20px;
          border-radius: 4px;
        }

        .sucesso {
          background-color: rgba(212, 237, 218, 0.2);
          color: #d4edda;
          border: 1px solid #28a745;
        }

        .erro {
          background-color: rgba(248, 215, 218, 0.2);
          color: #f8d7da;
          border: 1px solid #dc3545;
        }

        /* Layout responsivo */
        @media (max-width: 768px) {
          .container {
            padding: 10px;
          }

          .admin-card {
            min-width: 100%;
          }
        }
      </style>
    </head>

    <body>
      <!-- Inclusão do cabeçalho e navegação -->
      <jsp:include page="../components/header-nav.jsp" />

      <div class="container">
        <div class="content">
          <h1>Painel de Administração</h1>

          <!-- Exibe mensagens de sucesso ou erro se houver -->
          <c:if test="${not empty mensagemSucesso}">
            <div class="mensagem sucesso">${mensagemSucesso}</div>
          </c:if>

          <c:if test="${not empty mensagemErro}">
            <div class="mensagem erro">${mensagemErro}</div>
          </c:if>

          <div class="admin-cards">
            <a href="${pageContext.request.contextPath}/admin/usuarios" class="admin-card">
              <div class="icon">👤</div>
              <h2>Gerenciar Usuários</h2>
              <p>Cadastre, edite e remova funcionários do sistema.</p>
            </a>

            <a href="${pageContext.request.contextPath}/admin/configuracoes" class="admin-card">
              <div class="icon">⚙️</div>
              <h2>Configurações</h2>
              <p>Configure valores de estacionamento e número de vagas.</p>
            </a>
          </div>
        </div>
      </div>
    </body>

    </html>