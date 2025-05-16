<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib uri="jakarta.tags.core" prefix="c" %>
    <!DOCTYPE html>
    <html lang="pt-br">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Gerenciar Usuários - Estacionamento RSM</title>
      <style>
        body {
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
          background-color: #2a2b30;
          margin: 0;
          padding: 0;
          color: #f8f9fa;
        }

        .container {
          max-width: 1200px;
          margin: 0 auto;
          padding: 20px;
        }

        .content {
          background-color: #232429;
          border-radius: 10px;
          box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
          padding: 25px;
          border: 1px solid #30bced;
        }

        h1 {
          color: #fff;
          border-bottom: 2px solid #30bced;
          padding-bottom: 15px;
          margin-top: 0;
          font-size: 24px;
          font-weight: 600;
          text-align: center;
        }

        table {
          width: 100%;
          border-collapse: collapse;
          margin-top: 20px;
          border-radius: 5px;
          overflow: hidden;
        }

        th,
        td {
          padding: 14px 15px;
          border-bottom: 1px solid #34364a;
          text-align: left;
        }

        th {
          background-color: #2c2e3e;
          font-weight: 600;
          color: #30bced;
          font-size: 14px;
        }

        tr:hover {
          background-color: #2c2e3e;
        }

        tr:last-child td {
          border-bottom: none;
        }

        .btn {
          display: inline-block;
          padding: 8px 16px;
          border-radius: 5px;
          text-decoration: none;
          font-size: 14px;
          margin-right: 5px;
          text-align: center;
          transition: all 0.2s ease;
          border: none;
          cursor: pointer;
          font-weight: 500;
        }

        .btn-novo {
          background-color: #30bced;
          color: #fff;
          padding: 10px 18px;
          font-size: 15px;
          margin-bottom: 20px;
          box-shadow: 0 2px 5px rgba(48, 188, 237, 0.2);
        }

        .btn-novo:hover {
          background-color: #28a0c9;
          transform: translateY(-2px);
        }

        .btn-editar {
          background-color: #ffc107;
          color: #212529;
          box-shadow: 0 2px 5px rgba(255, 193, 7, 0.2);
        }

        .btn-editar:hover {
          background-color: #e0a800;
          transform: translateY(-2px);
        }

        .btn-excluir {
          background-color: #dc3545;
          color: #fff;
          box-shadow: 0 2px 5px rgba(220, 53, 69, 0.2);
        }

        .btn-excluir:hover {
          background-color: #c82333;
          transform: translateY(-2px);
        }

        .btn-voltar {
          background-color: #6c757d;
          color: #fff;
          margin-top: 20px;
          box-shadow: 0 2px 5px rgba(108, 117, 125, 0.2);
        }

        .btn-voltar:hover {
          background-color: #5a6268;
          transform: translateY(-2px);
        }

        .acoes {
          white-space: nowrap;
        }

        .mensagem {
          padding: 15px;
          margin-bottom: 20px;
          border-radius: 6px;
          font-size: 15px;
        }

        .sucesso {
          background-color: rgba(40, 167, 69, 0.2);
          color: #28a745;
          border-left: 4px solid #28a745;
        }

        .erro {
          background-color: rgba(220, 53, 69, 0.2);
          color: #dc3545;
          border-left: 4px solid #dc3545;
        }

        .sem-usuarios {
          text-align: center;
          padding: 20px;
          color: #aaa;
        }

        /* Layout responsivo */
        @media (max-width: 768px) {
          .container {
            padding: 10px;
          }

          table {
            display: block;
            overflow-x: auto;
          }

          .btn {
            display: block;
            margin-bottom: 5px;
            width: 100%;
          }

          h1 {
            font-size: 20px;
          }
        }
      </style>
    </head>

    <body>
      <!-- Inclusão do cabeçalho e navegação -->
      <jsp:include page="../components/header-nav.jsp" />

      <div class="container">
        <div class="content">
          <h1>Gerenciar Usuários</h1>

          <!-- Exibe mensagens de sucesso ou erro se houver -->
          <c:if test="${not empty sessionScope.mensagemSucesso}">
            <div class="mensagem sucesso">${sessionScope.mensagemSucesso}</div>
            <c:remove var="mensagemSucesso" scope="session" />
          </c:if>

          <c:if test="${not empty sessionScope.mensagemErro}">
            <div class="mensagem erro">${sessionScope.mensagemErro}</div>
            <c:remove var="mensagemErro" scope="session" />
          </c:if>

          <a href="${pageContext.request.contextPath}/admin/usuario/cadastrar" class="btn btn-novo">Novo Usuário</a>

          <c:choose>
            <c:when test="${not empty usuarios}">
              <table>
                <thead>
                  <tr>
                    <th>Nome</th>
                    <th>Email</th>
                    <th>Nível de Acesso</th>
                    <th>Ações</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach items="${usuarios}" var="usuario">
                    <tr>
                      <td>${usuario.nome}</td>
                      <td>${usuario.email}</td>
                      <td>${usuario.nivelAcesso}</td>
                      <td class="acoes">
                        <a href="${pageContext.request.contextPath}/admin/usuario/editar?id=${usuario.id}"
                          class="btn btn-editar">Editar</a>
                        <a href="#" onclick="confirmarExclusao(${usuario.id}, '${usuario.nome}')"
                          class="btn btn-excluir">Excluir</a>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </c:when>
            <c:otherwise>
              <div class="sem-usuarios">
                <p>Nenhum usuário cadastrado no sistema.</p>
              </div>
            </c:otherwise>
          </c:choose>

          <a href="${pageContext.request.contextPath}/admin" class="btn btn-voltar">Voltar</a>
        </div>
      </div>

      <script>
        // Função para confirmar exclusão de usuário
        function confirmarExclusao(id, nome) {
          if (confirm('Tem certeza que deseja excluir o usuário ' + nome + '?')) {
            window.location.href = '${pageContext.request.contextPath}/admin/usuario/excluir?id=' + id
          }
        }
      </script>
    </body>

    </html>