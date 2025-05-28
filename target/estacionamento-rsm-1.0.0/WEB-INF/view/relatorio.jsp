<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib uri="jakarta.tags.core" prefix="c" %>
    <!DOCTYPE html>
    <html lang="pt-br">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Relatórios - Estacionamento RSM</title>
      <style>
        body {
          font-family: 'Segoe UI', sans-serif;
          margin: 0;
          padding: 0;
          background-color: #2a2b30;
          color: #ffffff;
        }

        h1 {
          text-align: center;
          font-size: 32px;
          margin-top: 20px;
        }

        .container {
          max-width: 1000px;
          margin: auto;
          padding: 20px;
        }

        .content {
          background-color: #2a2b30;
          padding: 20px;
          border-radius: 8px;
          box-shadow: 0 0 0 2px #00bfff;
        }

        .filtro {
          display: flex;
          flex-direction: column;
          gap: 15px;
          margin-bottom: 20px;
        }

        .filtro-row {
          display: flex;
          align-items: center;
          flex-wrap: wrap;
          gap: 10px;
        }

        .filtro label {
          font-size: 14px;
        }

        .filtro input[type="date"],
        .filtro input[type="month"],
        .filtro select {
          padding: 8px;
          border-radius: 5px;
          border: none;
          outline: none;
          background-color: #343a40;
          color: #fff;
        }

        .btn-filtrar,
        .btn-imprimir {
          background-color: #30bced;
          border: none;
          padding: 10px 16px;
          color: white;
          font-weight: bold;
          border-radius: 5px;
          cursor: pointer;
          transition: 0.3s;
        }

        .btn-filtrar:hover,
        .btn-imprimir:hover {
          background-color: #1aaad7;
        }

        .btn-imprimir {
          float: right;
          margin-top: -50px;
        }

        .tipo-filtro {
          display: flex;
          gap: 10px;
          margin-bottom: 10px;
          align-items: center;
        }

        .tipo-filtro label {
          display: flex;
          align-items: center;
          gap: 5px;
          cursor: pointer;
        }

        .resumo {
          display: flex;
          justify-content: center;
          gap: 60px;
          margin-top: 40px;
          margin-bottom: 20px;
        }

        .resumo-item {
          text-align: center;
        }

        .resumo-valor {
          font-size: 26px;
          font-weight: bold;
          color: #30bced;
        }

        .resumo-label {
          font-size: 14px;
          color: #bbb;
        }

        .periodo-info {
          text-align: center;
          font-size: 18px;
          margin: 20px 0;
          color: #30bced;
        }

        table {
          width: 100%;
          border-collapse: collapse;
          margin-top: 20px;
        }

        th,
        td {
          padding: 12px 15px;
          text-align: center;
          border-bottom: 1px solid #444;
        }

        th {
          font-weight: bold;
          color: #ffffff;
        }

        tr:hover {
          background-color: #3c3d42;
        }

        .sem-registros {
          text-align: center;
          padding: 30px;
          color: #ccc;
        }

        .status {
          padding: 5px 10px;
          border-radius: 4px;
          font-size: 12px;
          font-weight: bold;
          display: inline-block;
        }

        .completo {
          background-color: #28a745;
          color: white;
        }

        .pendente {
          background-color: #ffc107;
          color: #000;
        }

        .mensagem {
          padding: 15px;
          margin-bottom: 20px;
          border-radius: 6px;
          font-size: 15px;
        }

        .erro {
          background-color: rgba(220, 53, 69, 0.2);
          color: #dc3545;
          border-left: 4px solid #dc3545;
        }

        @media (max-width: 768px) {
          .filtro-row {
            flex-direction: column;
            align-items: flex-start;
          }

          .btn-imprimir {
            float: none;
            align-self: flex-end;
            margin: 10px 0;
          }

          .resumo {
            flex-direction: column;
            align-items: center;
            gap: 20px;
          }

          table {
            display: block;
            overflow-x: auto;
          }
        }
      </style>
    </head>

    <body>
      <jsp:include page="components/header-nav.jsp" />

      <div class="container">
        <div class="content">
          <h1>Relatório de Faturamento</h1>

          <c:if test="${not empty mensagemErro}">
            <div class="mensagem erro">${mensagemErro}</div>
          </c:if>

          <form action="${pageContext.request.contextPath}/relatorio" method="get" class="filtro">
            <div class="tipo-filtro">
              <label for="tipoFiltro">Tipo de relatório:</label>
              <label><input type="radio" name="tipoFiltro" value="diario" ${tipoFiltro=='diario' || empty tipoFiltro
                  ? 'checked' : '' } onclick="alternarTipoFiltro()"> Diário</label>
              <label><input type="radio" name="tipoFiltro" value="semanal" ${tipoFiltro=='semanal' ? 'checked' : '' }
                  onclick="alternarTipoFiltro()"> Semanal</label>
              <label><input type="radio" name="tipoFiltro" value="mensal" ${tipoFiltro=='mensal' ? 'checked' : '' }
                  onclick="alternarTipoFiltro()"> Mensal</label>
            </div>

            <div class="filtro-row">
              <div id="filtro-diario" class="filtro-option">
                <label for="dataDiaria">Selecione a data:</label>
                <input type="date" id="dataDiaria" name="dataDiaria" value="${dataDiaria}">
              </div>

              <div id="filtro-semanal" class="filtro-option" style="display: none;">
                <label for="dataSemanal">Selecione o último dia da semana:</label>
                <input type="date" id="dataSemanal" name="dataSemanal" value="${dataSemanal}">
              </div>

              <div id="filtro-mensal" class="filtro-option" style="display: none;">
                <label for="dataMensal">Selecione o mês e ano:</label>
                <input type="month" id="dataMensal" name="dataMensal" value="${dataMensal}">
              </div>

              <button type="submit" class="btn-filtrar">Filtrar</button>
            </div>
          </form>

          <button onclick="window.print()" class="btn-imprimir">Imprimir Relatório</button>

          <c:if test="${not empty periodoFormatado}">
            <div class="periodo-info">
              ${periodoFormatado}
            </div>
          </c:if>

          <div class="resumo">
            <div class="resumo-item">
              <div class="resumo-valor">${totalMovimentacoes}</div>
              <div class="resumo-label">Veículos</div>
            </div>
            <div class="resumo-item">
              <div class="resumo-valor">R$ ${totalValor}</div>
              <div class="resumo-label">Faturamento</div>
            </div>
          </div>

          <c:choose>
            <c:when test="${empty movimentacoes}">
              <div class="sem-registros">Nenhum registro encontrado para este período.</div>
            </c:when>
            <c:otherwise>
              <table>
                <thead>
                  <tr>
                    <th>Placa</th>
                    <th>Tipo</th>
                    <th>Entrada</th>
                    <th>Saída</th>
                    <th>Valor</th>
                    <th>Pagamento</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach items="${movimentacoes}" var="mov">
                    <tr>
                      <td>${mov.placa}</td>
                      <td>${mov.tipoVeiculo}</td>
                      <td>${mov.horaEntradaFormatada}</td>
                      <td>${mov.dataSaida != null ? mov.horaSaidaFormatada : '-'}</td>
                      <td>${mov.valorPago != null ? mov.valorPagoFormatado : '-'}</td>
                      <td>${mov.formaPagamento != null ? mov.formaPagamento : '-'}</td>
                      <td>
                        <c:choose>
                          <c:when test="${mov.dataSaida != null}">
                            <span class="status completo">Completo</span>
                          </c:when>
                          <c:otherwise>
                            <span class="status pendente">Em Aberto</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <script>
        function alternarTipoFiltro() {
          const tipoDiario = document.getElementById('filtro-diario');
          const tipoSemanal = document.getElementById('filtro-semanal');
          const tipoMensal = document.getElementById('filtro-mensal');

          const tipoFiltroSelecionado = document.querySelector('input[name="tipoFiltro"]:checked').value;

          tipoDiario.style.display = tipoFiltroSelecionado === 'diario' ? 'block' : 'none';
          tipoSemanal.style.display = tipoFiltroSelecionado === 'semanal' ? 'block' : 'none';
          tipoMensal.style.display = tipoFiltroSelecionado === 'mensal' ? 'block' : 'none';
        }

        // Inicializar o estado correto dos filtros ao carregar a página
        document.addEventListener('DOMContentLoaded', function () {
          alternarTipoFiltro();
        });
      </script>
    </body>

    </html>