<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib uri="jakarta.tags.core" prefix="c" %>
    <!DOCTYPE html>
    <html lang="pt-br">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Configurações - Estacionamento 24 Horas</title>
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
          margin: auto;
          padding: 20px;
        }

        .content {
          background-color: #2a2b30;
          padding: 20px;
          border-radius: 8px;
          box-shadow: 0 0 0 2px #00bfff;
        }

        h1 {
          color: #ffffff;
          border-bottom: 2px solid #30bced;
          padding-bottom: 10px;
          margin-top: 0;
          text-align: center;
          font-size: 32px;
        }

        .form-group {
          margin-bottom: 20px;
        }

        label {
          display: block;
          margin-bottom: 5px;
          font-weight: bold;
          color: #ffffff;
        }

        input[type='number'] {
          width: 100%;
          padding: 10px;
          border: 1px solid #444;
          border-radius: 4px;
          background-color: #333;
          color: #ffffff;
          box-sizing: border-box;
        }

        .btn-salvar {
          background-color: #30bced;
          color: #fff;
          border: none;
          padding: 12px 20px;
          border-radius: 4px;
          cursor: pointer;
          font-size: 16px;
          transition: background-color 0.3s;
        }

        .btn-salvar:hover {
          background-color: #1aaad7;
        }

        .btn-voltar {
          background-color: #6c757d;
          color: #fff;
          border: none;
          padding: 12px 20px;
          border-radius: 4px;
          cursor: pointer;
          font-size: 16px;
          text-decoration: none;
          display: inline-block;
          margin-right: 10px;
          transition: background-color 0.3s;
        }

        .btn-voltar:hover {
          background-color: #5a6268;
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

        .actions {
          margin-top: 30px;
          display: flex;
        }

        /* Layout responsivo */
        @media (max-width: 768px) {
          .container {
            padding: 10px;
          }

          .actions {
            flex-direction: column;
          }

          .btn-voltar,
          .btn-salvar {
            width: 100%;
            margin-bottom: 10px;
            margin-right: 0;
            text-align: center;
          }
        }
      </style>
    </head>

    <body>
      <!-- Inclusão do cabeçalho e navegação -->
      <jsp:include page="../components/header-nav.jsp" />

      <div class="container">
        <div class="content">
          <h1>Configurações do Sistema</h1>

          <!-- Exibe mensagens de sucesso ou erro se houver -->
          <c:if test="${not empty mensagemSucesso}">
            <div class="mensagem sucesso">${mensagemSucesso}</div>
          </c:if>

          <c:if test="${not empty mensagemErro}">
            <div class="mensagem erro">${mensagemErro}</div>
          </c:if>

          <form action="${pageContext.request.contextPath}/admin/configuracoes/salvar" method="post" id="configForm">
            <div class="form-group">
              <label for="valorPrimeiraHora">Valor da Primeira Hora (R$)</label>
              <input type="number" id="valorPrimeiraHora" name="valorPrimeiraHora" step="0.01" min="0"
                value="${configuracoes.valorPrimeiraHora}" required />
            </div>

            <div class="form-group">
              <label for="valorHoraAdicional">Valor da Hora Adicional (R$)</label>
              <input type="number" id="valorHoraAdicional" name="valorHoraAdicional" step="0.01" min="0"
                value="${configuracoes.valorHoraAdicional}" required />
            </div>

            <div class="form-group">
              <label for="totalVagas">Número de Vagas no Estacionamento</label>
              <input type="number" id="totalVagas" name="totalVagas" min="1" max="100"
                value="${configuracoes.totalVagas}" required />
            </div>

            <div class="actions">
              <a href="${pageContext.request.contextPath}/admin" class="btn-voltar">Voltar</a>
              <button type="submit" class="btn-salvar">Salvar Configurações</button>
            </div>
          </form>
        </div>
      </div>

      <script>
        document.addEventListener('DOMContentLoaded', function () {
          // Verificar se há algum problema no formulário
          const form = document.getElementById('configForm');

          form.addEventListener('submit', function (event) {
            // Verificar valores antes de enviar
            const valorPrimeiraHora = document.getElementById('valorPrimeiraHora').value;
            const valorHoraAdicional = document.getElementById('valorHoraAdicional').value;
            const totalVagas = document.getElementById('totalVagas').value;

            // Validação extra
            if (parseFloat(valorPrimeiraHora) <= 0) {
              alert('O valor da primeira hora deve ser maior que zero');
              event.preventDefault();
              return false;
            }

            if (parseFloat(valorHoraAdicional) < 0) {
              alert('O valor da hora adicional não pode ser negativo');
              event.preventDefault();
              return false;
            }

            if (parseInt(totalVagas) <= 0) {
              alert('O número de vagas deve ser maior que zero');
              event.preventDefault();
              return false;
            }

            // Adicionar debug para confirmação
            console.log('Enviando formulário com os valores:', {
              valorPrimeiraHora,
              valorHoraAdicional,
              totalVagas
            });
          });

          // Verificar se há mensagem de sucesso e redirecionar após alguns segundos
          const sucessoMsg = document.querySelector('.mensagem.sucesso');
          if (sucessoMsg) {
            setTimeout(function () {
              window.location.href = '${pageContext.request.contextPath}/admin/configuracoes';
            }, 3000); // Redireciona após 3 segundos
          }
        });
      </script>
    </body>

    </html>