<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
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

            .filtros {
                background-color: #3c3d42;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
            }

            .filtro-row {
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 15px;
                flex-wrap: wrap;
            }

            .filtro-group {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .filtro-group label {
                font-size: 14px;
                font-weight: bold;
                min-width: 80px;
            }

            .filtro-group select,
            .filtro-group input[type="date"] {
                padding: 8px 12px;
                border-radius: 5px;
                border: 1px solid #555;
                background-color: #2a2b30;
                color: #ffffff;
                outline: none;
            }

            .periodo-personalizado {
                display: none;
                align-items: center;
                gap: 10px;
                margin-top: 10px;
                padding: 15px;
                background-color: #2a2b30;
                border-radius: 5px;
                border: 1px solid #555;
            }

            .btn-filtrar,
            .btn-imprimir,
            .btn-exportar {
                background-color: #30bced;
                border: none;
                padding: 10px 16px;
                color: white;
                font-weight: bold;
                border-radius: 5px;
                cursor: pointer;
                transition: 0.3s;
                margin-right: 10px;
            }

            .btn-filtrar:hover,
            .btn-imprimir:hover,
            .btn-exportar:hover {
                background-color: #1aaad7;
            }

            .btn-exportar {
                background-color: #28a745;
            }

            .btn-exportar:hover {
                background-color: #218838;
            }

            .acoes {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                margin-bottom: 20px;
            }

            .resumo-geral {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .resumo-card {
                background-color: #3c3d42;
                padding: 20px;
                border-radius: 8px;
                text-align: center;
                border-left: 4px solid #30bced;
            }

            .resumo-valor {
                font-size: 28px;
                font-weight: bold;
                color: #30bced;
                margin-bottom: 5px;
            }

            .resumo-label {
                font-size: 14px;
                color: #bbb;
                margin-bottom: 10px;
            }

            .resumo-detalhe {
                font-size: 12px;
                color: #999;
            }

            .periodo-info {
                background-color: #3c3d42;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                text-align: center;
            }

            .periodo-info strong {
                color: #30bced;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                background-color: #3c3d42;
                border-radius: 8px;
                overflow: hidden;
            }

            th,
            td {
                padding: 12px 15px;
                text-align: center;
                border-bottom: 1px solid #555;
            }

            th {
                background-color: #2a2b30;
                font-weight: bold;
                color: #ffffff;
            }

            tr:hover {
                background-color: #4a4b50;
            }

            .sem-registros {
                text-align: center;
                padding: 40px;
                color: #ccc;
                background-color: #3c3d42;
                border-radius: 8px;
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

            .em-aberto {
                background-color: #dc3545;
                color: white;
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

            .grafico-container {
                background-color: #3c3d42;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
            }

            .progress-bar {
                width: 100%;
                height: 20px;
                background-color: #2a2b30;
                border-radius: 10px;
                overflow: hidden;
                margin-top: 10px;
            }

            .progress-fill {
                height: 100%;
                background: linear-gradient(90deg, #30bced, #1aaad7);
                transition: width 0.3s ease;
            }

            @media print {
                .filtros,
                .acoes,
                .btn-filtrar,
                .btn-imprimir,
                .btn-exportar {
                    display: none !important;
                }

                body {
                    background-color: white;
                    color: black;
                }

                .content,
                .resumo-card,
                table {
                    background-color: white;
                    color: black;
                    box-shadow: none;
                }
            }

            @media (max-width: 768px) {
                .filtro-row {
                    flex-direction: column;
                    align-items: flex-start;
                }

                .resumo-geral {
                    grid-template-columns: 1fr;
                }

                .acoes {
                    flex-direction: column;
                }

                table {
                    display: block;
                    overflow-x: auto;
                    white-space: nowrap;
                }
            }
        </style>
    </head>

    <body>
        <jsp:include page="components/header-nav.jsp" />

        <div class="container">
            <div class="content">
                <h1>Relatório de Movimentação</h1>

                <c:if test="${not empty mensagemErro}">
                    <div class="mensagem erro">${mensagemErro}</div>
                </c:if>

                <div class="filtros">
                    <form action="${pageContext.request.contextPath}/relatorio" method="get">
                        <div class="filtro-row">
                            <div class="filtro-group">
                                <label for="tipoFiltro">Período:</label>
                                <select id="tipoFiltro" name="tipoFiltro" onchange="togglePeriodoPersonalizado()">
                                    <option value="diario" ${tipoFiltro == 'diario' ? 'selected' : ''}>Hoje</option>
                                    <option value="semanal" ${tipoFiltro == 'semanal' ? 'selected' : ''}>Esta Semana</option>
                                    <option value="mensal" ${tipoFiltro == 'mensal' ? 'selected' : ''}>Este Mês</option>
                                    <option value="personalizado" ${tipoFiltro == 'personalizado' ? 'selected' : ''}>Período Personalizado</option>
                                </select>
                            </div>
                            <button type="submit" class="btn-filtrar">Filtrar</button>
                        </div>

                        <div id="periodoPersonalizado" class="periodo-personalizado">
                            <div class="filtro-group">
                                <label for="dataInicio">De:</label>
                                <input type="date" id="dataInicio" name="dataInicio" value="${dataInicio}" />
                            </div>
                            <div class="filtro-group">
                                <label for="dataFim">Até:</label>
                                <input type="date" id="dataFim" name="dataFim" value="${dataFim}" />
                            </div>
                        </div>
                    </form>
                </div>

                <div class="acoes">
                    <button onclick="exportarCSV()" class="btn-exportar">Exportar CSV</button>
                    <button onclick="window.print()" class="btn-imprimir">Imprimir Relatório</button>
                </div>

                <div class="periodo-info">
                    <strong>Período: </strong>
                    <fmt:parseDate value="${dataInicio}" pattern="yyyy-MM-dd" var="dataInicioFormatada"/>
                    <fmt:parseDate value="${dataFim}" pattern="yyyy-MM-dd" var="dataFimFormatada"/>
                    <fmt:formatDate value="${dataInicioFormatada}" pattern="dd/MM/yyyy"/> - 
                    <fmt:formatDate value="${dataFimFormatada}" pattern="dd/MM/yyyy"/>
                </div>

                <div class="resumo-geral">
                    <div class="resumo-card">
                        <div class="resumo-valor">${totalVeiculos}</div>
                        <div class="resumo-label">Total de Veículos</div>
                        <div class="resumo-detalhe">
                            ${veiculosCompletos} finalizados • ${veiculosEmAberto} em aberto
                        </div>
                    </div>

                    <div class="resumo-card">
                        <div class="resumo-valor">
                            <fmt:formatNumber value="${totalValor}" type="currency" currencySymbol="R$"/>
                        </div>
                        <div class="resumo-label">Faturamento Total</div>
                        <div class="resumo-detalhe">
                            Média diária: <fmt:formatNumber value="${mediaDiaria}" type="currency" currencySymbol="R$"/>
                        </div>
                    </div>

                    <div class="resumo-card">
                        <div class="resumo-valor">
                            <fmt:formatNumber value="${percentualOcupacao}" pattern="#0.0"/>%
                        </div>
                        <div class="resumo-label">Taxa de Ocupação</div>
                        <div class="resumo-detalhe">
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: ${percentualOcupacao}%"></div>
                            </div>
                        </div>
                    </div>

                    <div class="resumo-card">
                        <div class="resumo-valor">
                            <fmt:formatNumber value="${totalVeiculos > 0 ? totalValor / totalVeiculos : 0}" type="currency" currencySymbol="R$"/>
                        </div>
                        <div class="resumo-label">Ticket Médio</div>
                        <div class="resumo-detalhe">
                            Valor médio por veículo
                        </div>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty movimentacoes}">
                        <div class="sem-registros">
                            <h3>Nenhum registro encontrado</h3>
                            <p>Não há movimentações registradas para o período selecionado.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table id="tabelaMovimentacoes">
                            <thead>
                                <tr>
                                    <th>Placa</th>
                                    <th>Tipo</th>
                                    <th>Data</th>
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
                                        <td style="font-weight: bold;">${mov.placa}</td>
                                        <td>${mov.tipoVeiculo}</td>
                                        <td>${mov.dataEntradaFormatada}</td>
                                        <td>${mov.horaEntradaFormatada}</td>
                                        <td>${mov.dataSaida != null ? mov.horaSaidaFormatada : '-'}</td>
                                        <td style="font-weight: bold; color: #30bced;">
                                            ${mov.valorPago != null ? mov.valorPagoFormatado : '-'}
                                        </td>
                                        <td>${mov.formaPagamento != null ? mov.formaPagamento : '-'}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${mov.dataSaida != null && mov.valorPago != null}">
                                                    <span class="status completo">Finalizado</span>
                                                </c:when>
                                                <c:when test="${mov.dataSaida != null && mov.valorPago == null}">
                                                    <span class="status pendente">Saiu s/ Pagto</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status em-aberto">Em Aberto</span>
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
            function togglePeriodoPersonalizado() {
                const tipoFiltro = document.getElementById('tipoFiltro').value;
                const periodoDiv = document.getElementById('periodoPersonalizado');

                if (tipoFiltro === 'personalizado') {
                    periodoDiv.style.display = 'flex';
                } else {
                    periodoDiv.style.display = 'none';
                }
            }

            function exportarCSV() {
                const tabela = document.getElementById('tabelaMovimentacoes');
                if (!tabela) {
                    alert('Nenhum dado para exportar');
                    return;
                }

                let csv = [];
                const linhas = tabela.querySelectorAll('tr');

                linhas.forEach(linha => {
                    const colunas = linha.querySelectorAll('th, td');
                    const linhaCsv = [];
                    colunas.forEach(coluna => {
                        linhaCsv.push('"' + coluna.textContent.replace(/"/g, '""') + '"');
                    });
                    csv.push(linhaCsv.join(','));
                });

                const csvContent = csv.join('\n');
                const blob = new Blob([csvContent], {type: 'text/csv;charset=utf-8;'});
                const link = document.createElement('a');

                if (link.download !== undefined) {
                    const url = URL.createObjectURL(blob);
                    link.setAttribute('href', url);
                    link.setAttribute('download', 'relatorio_movimentacao.csv');
                    link.style.visibility = 'hidden';
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                }
            }

            // Inicializa a visibilidade do período personalizado
            document.addEventListener('DOMContentLoaded', function () {
                togglePeriodoPersonalizado();
            });
        </script>
    </body>

</html>
