<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib uri="jakarta.tags.core" prefix="c" %>
    <!DOCTYPE html>
    <html lang="pt-br">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Entrada de Veículos - Estacionamento RSM</title>
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
          margin: 20px auto;
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

        .form-group {
          margin-bottom: 20px;
        }

        label {
          display: block;
          margin-bottom: 8px;
          font-weight: 500;
          color: #f8f9fa;
        }

        input[type='text'],
        select,
        textarea {
          width: 100%;
          padding: 10px;
          border: 1px solid #444;
          border-radius: 5px;
          background-color: #333;
          color: #fff;
          font-family: 'Segoe UI', sans-serif;
          font-size: 14px;
          box-sizing: border-box;
        }

        input:focus,
        select:focus,
        textarea:focus {
          outline: none;
          border-color: #30bced;
          box-shadow: 0 0 5px rgba(48, 188, 237, 0.5);
        }

        button {
          background-color: #30bced;
          color: #fff;
          border: none;
          padding: 12px 20px;
          border-radius: 5px;
          cursor: pointer;
          font-size: 16px;
          transition: all 0.2s ease;
          box-shadow: 0 2px 5px rgba(48, 188, 237, 0.2);
        }

        button:hover {
          background-color: #28a0c9;
          transform: translateY(-2px);
        }

        .status-bar {
          background-color: #2c2e3e;
          padding: 15px;
          margin-bottom: 20px;
          border-radius: 6px;
          display: flex;
          justify-content: space-between;
          color: #f8f9fa;
          border-left: 4px solid #30bced;
        }

        .status-bar strong {
          color: #30bced;
        }

        .mensagem {
          padding: 15px;
          margin-bottom: 20px;
          border-radius: 6px;
          font-size: 15px;
          animation: fadeIn 0.5s;
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

        @keyframes fadeIn {
          from {
            opacity: 0;
            transform: translateY(-10px);
          }

          to {
            opacity: 1;
            transform: translateY(0);
          }
        }

        /* Layout responsivo */
        @media (max-width: 768px) {
          .container {
            padding: 10px;
          }

          button {
            width: 100%;
          }
        }
      </style>
    </head>

    <body>
      <!-- Inclusão do cabeçalho e navegação -->
      <jsp:include page="components/header-nav.jsp" />

      <div class="container">
        <div class="content">
          <h1>Registro de Entrada de Veículos</h1>

          <!-- Exibe mensagens de sucesso ou erro se houver -->
          <c:if test="${not empty mensagemSucesso}">
            <div class="mensagem sucesso">${mensagemSucesso}</div>
          </c:if>

          <c:if test="${not empty mensagemErro}">
            <div class="mensagem erro">${mensagemErro}</div>
          </c:if>

          <!-- Status das vagas -->
          <div class="status-bar">
            <div>
              <% Integer vagasDisponiveis=(Integer)request.getAttribute("vagasDisponiveis"); Integer
                totalVagas=(Integer)request.getAttribute("totalVagas"); if(vagasDisponiveis==null) vagasDisponiveis=0;
                if(totalVagas==null) totalVagas=0; %> Vagas disponíveis:
                <strong>
                  <%= vagasDisponiveis %> de <%= totalVagas %>
                </strong>
            </div>
            <div id="dataHoraAtual"></div>
          </div>

          <!-- Formulário de registro de entrada -->
          <form action="<%= request.getContextPath() %>/entrada" method="post" id="entradaForm">
            <div class="form-group">
              <label for="placa">Placa do Veículo</label>
              <input type="text" id="placa" name="placa" placeholder="Formato: ABC1D23 ou ABC1234" required />
            </div>

            <div class="form-group">
              <label for="tipoVeiculo">Tipo de Veículo</label>
              <select id="tipoVeiculo" name="tipoVeiculo" required>
                <option value="">Selecione...</option>
                <option value="carro">Carro</option>
                <option value="suv">SUV</option>
                <option value="pickup">Pickup</option>
              </select>
            </div>

            <div class="form-group">
              <label for="observacoes">Observações (opcional)</label>
              <textarea id="observacoes" name="observacoes" rows="3"></textarea>
            </div>

            <button type="submit">Registrar Entrada</button>
          </form>
        </div>
      </div>

      <script>
        // Função para atualizar a data e hora atual
        function atualizarDataHora() {
          const now = new Date()
          const dataHora = now.toLocaleDateString('pt-BR') + ' ' + now.toLocaleTimeString('pt-BR')
          document.getElementById('dataHoraAtual').textContent = dataHora
        }

        // Atualiza a cada segundo
        setInterval(atualizarDataHora, 1000)
        atualizarDataHora()

        // Verifica se o formulário foi enviado com sucesso
        document.getElementById('entradaForm').addEventListener('submit', function (e) {
          localStorage.setItem('formSubmitted', 'true');
        });

        // Verifica se há uma mensagem de sucesso na URL (para redirecionamentos)
        window.onload = function () {
          const urlParams = new URLSearchParams(window.location.search);
          const success = urlParams.get('success');

          if (success === 'true' && !document.querySelector('.mensagem.sucesso')) {
            const mensagemDiv = document.createElement('div');
            mensagemDiv.className = 'mensagem sucesso';
            mensagemDiv.textContent = 'Veículo registrado com sucesso!';

            const container = document.querySelector('.container');
            container.insertBefore(mensagemDiv, container.querySelector('.status-bar'));

            // Remove o parâmetro da URL sem recarregar a página
            window.history.replaceState({}, document.title, window.location.pathname);
          }

          // Limpa o flag de formulário enviado
          localStorage.removeItem('formSubmitted');
        }
      </script>
    </body>

    </html>