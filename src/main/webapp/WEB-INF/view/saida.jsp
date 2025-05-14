<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="pt-br">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Saída de Veículos - Estacionamento 24 Horas</title>
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

                input[type="text"],
                select {
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
                select:focus {
                    outline: none;
                    border-color: #30bced;
                    box-shadow: 0 0 5px rgba(48, 188, 237, 0.5);
                }

                .btn-buscar,
                .btn-registrar {
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

                .btn-buscar:hover,
                .btn-registrar:hover {
                    background-color: #28a0c9;
                    transform: translateY(-2px);
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

                .veiculo-info {
                    background-color: #2c2e3e;
                    padding: 20px;
                    border-radius: 6px;
                    margin-bottom: 20px;
                    border-left: 5px solid #30bced;
                }

                .info-line {
                    margin-bottom: 10px;
                    display: flex;
                }

                .info-label {
                    font-weight: bold;
                    width: 150px;
                    color: #30bced;
                }

                .valor-pagar {
                    font-size: 24px;
                    color: #4ade80;
                    text-align: right;
                    margin-top: 20px;
                    font-weight: bold;
                }

                .two-columns {
                    display: flex;
                    justify-content: space-between;
                    flex-wrap: wrap;
                }

                .column {
                    flex: 1;
                    min-width: 250px;
                    margin-right: 20px;
                }

                .column:last-child {
                    margin-right: 0;
                }

                /* Layout responsivo */
                @media (max-width: 768px) {
                    .container {
                        padding: 10px;
                    }

                    .two-columns {
                        flex-direction: column;
                    }

                    .column {
                        margin-right: 0;
                        margin-bottom: 20px;
                    }

                    .btn-buscar,
                    .btn-registrar {
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
                    <h1>Registro de Saída de Veículos</h1>

                    <!-- Exibe mensagens de sucesso ou erro se houver -->
                    <c:if test="${not empty mensagemSucesso}">
                        <div class="mensagem sucesso">
                            ${mensagemSucesso}
                            <c:if test="${not empty valorPago}">
                                <p>Valor pago: R$ ${valorPago}</p>
                            </c:if>
                        </div>
                    </c:if>

                    <!-- Exibe mensagem de erro apenas se não houve uma saída registrada com sucesso -->
                    <c:if test="${not empty mensagemErro && empty mensagemSucesso}">
                        <div class="mensagem erro">
                            ${mensagemErro}
                        </div>
                    </c:if>

                    <!-- Formulário de busca de veículo -->
                    <form action="${pageContext.request.contextPath}/saida" method="get" id="formBusca">
                        <div class="form-group">
                            <label for="placa">Buscar Veículo por Placa</label>
                            <div style="display: flex;">
                                <input type="text" id="placa" name="placa" placeholder="Informe a placa do veículo"
                                    required style="flex: 1; margin-right: 10px;">
                                <button type="submit" class="btn-buscar">Buscar</button>
                            </div>
                        </div>
                    </form>

                    <!-- Exibe as informações do veículo encontrado -->
                    <c:if test="${not empty veiculo}">
                        <div class="veiculo-info">
                            <div class="info-line">
                                <div class="info-label">Placa:</div>
                                <div>${veiculo.placa}</div>
                            </div>

                            <div class="info-line">
                                <div class="info-label">Tipo:</div>
                                <div>${veiculo.tipoVeiculo}</div>
                            </div>

                            <div class="info-line">
                                <div class="info-label">Entrada:</div>
                                <div>${veiculo.dataEntradaFormatada} (${veiculo.horaEntradaFormatada})</div>
                            </div>

                            <div class="info-line">
                                <div class="info-label">Permanência:</div>
                                <div>${horasPermanencia}h ${minutosPermanencia}min</div>
                            </div>

                            <c:if test="${not empty veiculo.observacoes}">
                                <div class="info-line">
                                    <div class="info-label">Observações:</div>
                                    <div>${veiculo.observacoes}</div>
                                </div>
                            </c:if>

                            <div class="valor-pagar">
                                Valor a Pagar: R$ ${valorAPagar}
                            </div>
                        </div>

                        <!-- Formulário de registro de saída -->
                        <form action="${pageContext.request.contextPath}/saida" method="post">
                            <input type="hidden" name="placa" value="${veiculo.placa}">

                            <div class="form-group">
                                <label for="formaPagamento">Forma de Pagamento</label>
                                <select id="formaPagamento" name="formaPagamento" required>
                                    <option value="">Selecione...</option>
                                    <option value="dinheiro">Dinheiro</option>
                                    <option value="cartao_debito">Cartão de Débito</option>
                                    <option value="pix">PIX</option>
                                </select>
                            </div>

                            <button type="submit" class="btn-registrar">Registrar Saída</button>
                        </form>
                    </c:if>
                </div>
            </div>

            <script>
                // Função para validar o formato da placa
                document.getElementById('placa').addEventListener('input', function () {
                    this.value = this.value.toUpperCase();
                });

                // Limpa o campo de busca quando a saída for registrada com sucesso
                document.addEventListener('DOMContentLoaded', function () {
                    const sucessoMsg = document.querySelector('.mensagem.sucesso');
                    if (sucessoMsg) {
                        document.getElementById('placa').value = '';

                        // Limpa os parâmetros da URL para evitar problemas de recarregamento
                        if (window.history && window.history.replaceState) {
                            const cleanUrl = window.location.protocol + "//" +
                                window.location.host +
                                window.location.pathname;
                            window.history.replaceState({}, document.title, cleanUrl);
                        }
                    }
                });
            </script>
        </body>

        </html>