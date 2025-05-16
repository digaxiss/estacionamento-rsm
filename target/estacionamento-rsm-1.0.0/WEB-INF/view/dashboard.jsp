<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib uri="jakarta.tags.core" prefix="c" %>
    <!DOCTYPE html>
    <html lang="pt-br">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Dashboard - Estacionamento RSM</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          background-color: #2d2d2d;
          margin: 0;
          padding: 0;
          color: #fff;
        }

        main {
          max-width: 1200px;
          margin: 20px auto;
          padding: 0 20px;
        }

        h2 {
          margin-top: 0;
          padding-bottom: 10px;
          border-bottom: 2px solid #30bced;
          color: #fff;
        }

        /* Resumo Financeiro */
        .resumo-section {
          margin-bottom: 20px;
        }

        .resumo-section h2 {
          margin-bottom: 20px;
        }

        .resumo-cards {
          display: flex;
          justify-content: space-between;
          gap: 15px;
        }

        .resumo-card {
          background-color: #333;
          border-radius: 8px;
          padding: 20px;
          flex: 1;
          box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
        }

        .resumo-card .label {
          font-size: 14px;
          color: #ccc;
        }

        .resumo-card .value {
          font-size: 24px;
          font-weight: bold;
          color: #30bced;
          margin-top: 5px;
        }

        /* Estatísticas */
        .stats-cards {
          display: grid;
          grid-template-columns: repeat(4, 1fr);
          gap: 15px;
          margin-bottom: 20px;
        }

        .stat-card {
          background-color: #333;
          border-radius: 8px;
          padding: 20px;
          text-align: center;
          box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
        }

        .stat-card .title {
          font-size: 14px;
          color: #ccc;
          text-transform: uppercase;
          font-weight: bold;
          margin-bottom: 10px;
        }

        .stat-card .value {
          font-size: 32px;
          font-weight: bold;
          color: #30bced;
        }

        /* Grid de duas colunas para os cards principais */
        .dashboard-grid {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 20px;
          margin-bottom: 20px;
        }

        .card {
          background-color: #333;
          border-radius: 8px;
          box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
          padding: 20px;
        }

        /* Tabelas */
        table {
          width: 100%;
          border-collapse: collapse;
          margin-top: 15px;
        }

        th,
        td {
          padding: 12px 15px;
          text-align: left;
          border-bottom: 1px solid #444;
        }

        th {
          background-color: #222;
          color: #ccc;
          font-weight: bold;
        }

        tr:hover {
          background-color: #3a3a3a;
        }

        /* Status de entrada/saída */
        .status {
          display: inline-block;
          padding: 5px 10px;
          border-radius: 20px;
          font-size: 12px;
          font-weight: bold;
        }

        .status-success {
          background-color: #28a745;
          color: #fff;
        }

        .status-danger {
          background-color: #dc3545;
          color: #fff;
        }

        /* Rodapé */
        footer {
          text-align: center;
          padding: 20px;
          margin-top: 30px;
          color: #999;
          font-size: 14px;
          border-top: 1px solid #444;
        }

        /* Layout responsivo */
        @media (max-width: 1024px) {
          .stats-cards {
            grid-template-columns: repeat(2, 1fr);
          }
        }

        @media (max-width: 768px) {
          .dashboard-grid {
            grid-template-columns: 1fr;
          }

          .resumo-cards {
            flex-direction: column;
          }
        }
      </style>
    </head>

    <body>
      <!-- Inclusão do cabeçalho e navegação -->
      <jsp:include page="components/header-nav.jsp" />

      <main>
        <!-- Resumo financeiro -->
        <section class="resumo-section">
          <h2>Resumo Financeiro</h2>
          <div class="resumo-cards">
            <div class="resumo-card">
              <div class="label">Total Semana:</div>
              <div class="value">R$ ${totalSemana}</div>
            </div>
            <div class="resumo-card">
              <div class="label">Total Mês:</div>
              <div class="value">R$ ${totalMes}</div>
            </div>
            <div class="resumo-card">
              <div class="label">Ticket Médio:</div>
              <div class="value">R$ ${ticketMedio}</div>
            </div>
          </div>
        </section>

        <!-- Grid layout para estatísticas -->
        <div class="stats-cards">
          <div class="stat-card">
            <div class="title">Vagas Disponíveis</div>
            <div class="value">${vagasDisponiveis}</div>
          </div>
          <div class="stat-card">
            <div class="title">Vagas Ocupadas</div>
            <div class="value">${vagasOcupadas}</div>
          </div>
          <div class="stat-card">
            <div class="title">Total de Vagas</div>
            <div class="value">${totalVagas}</div>
          </div>
          <div class="stat-card">
            <div class="title">Faturamento Hoje</div>
            <div class="value">R$ ${faturamentoHoje}</div>
          </div>
        </div>

        <!-- Grid de duas colunas para os cards principais -->
        <div class="dashboard-grid">
          <!-- Veículos estacionados -->
          <div class="card">
            <h2>Veículos Estacionados</h2>
            <table>
              <thead>
                <tr>
                  <th>Placa</th>
                  <th>Entrada</th>
                  <th>Tempo</th>
                  <th>Valor Atual</th>
                </tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${not empty veiculosEstacionados}">
                    <c:forEach items="${veiculosEstacionados}" var="veiculo">
                      <tr>
                        <td>${veiculo.placa}</td>
                        <td>${veiculo.horaEntradaFormatada}</td>
                        <td>${veiculo.tempoPermanencia}</td>
                        <td>R$ ${veiculo.valorAtual}</td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr>
                      <td colspan="4" style="text-align: center">
                        Nenhum veículo estacionado no momento.
                      </td>
                    </tr>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>

          <!-- Últimas movimentações -->
          <div class="card">
            <h2>Últimas Movimentações</h2>
            <table>
              <thead>
                <tr>
                  <th>Placa</th>
                  <th>Tipo</th>
                  <th>Horário</th>
                  <th>Valor</th>
                </tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${not empty ultimasMovimentacoes}">
                    <c:forEach items="${ultimasMovimentacoes}" var="mov">
                      <tr>
                        <td>${mov.placa}</td>
                        <td>
                          <c:choose>
                            <c:when test="${mov.dataSaida == null}">
                              <span class="status status-success">ENTRADA</span>
                            </c:when>
                            <c:otherwise>
                              <span class="status status-danger">SAÍDA</span>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td>
                          <c:choose>
                            <c:when test="${mov.dataSaida == null}">
                              ${mov.horaEntradaFormatada}
                            </c:when>
                            <c:otherwise> ${mov.horaSaidaFormatada} </c:otherwise>
                          </c:choose>
                        </td>
                        <td>
                          <c:choose>
                            <c:when test="${mov.dataSaida == null}">-</c:when>
                            <c:otherwise>R$ ${mov.valorPagoFormatado}</c:otherwise>
                          </c:choose>
                        </td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr>
                      <td colspan="4" style="text-align: center">Nenhuma movimentação registrada.</td>
                    </tr>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>
        </div>
      </main>

      <footer>
        <p>&copy; 2025 Estacionamento RSM - Todos os direitos reservados</p>
      </footer>
    </body>

    </html>