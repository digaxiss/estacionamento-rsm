<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="pt-br">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${empty usuario ? 'Novo Usuário' : 'Editar Usuário'} - Estacionamento RSM</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
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
                    border-radius: 8px;
                    box-shadow: 0 0 0 2px #30bced;
                    padding: 20px;
                }

                h1 {
                    color: #fff;
                    border-bottom: 2px solid #30bced;
                    padding-bottom: 10px;
                    margin-top: 0;
                    text-align: center;
                }

                .form-group {
                    margin-bottom: 20px;
                }

                label {
                    display: block;
                    margin-bottom: 5px;
                    font-weight: bold;
                    color: #fff;
                }

                input[type="text"],
                input[type="email"],
                input[type="password"],
                select {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #444;
                    border-radius: 4px;
                    background-color: #333;
                    color: #fff;
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
                    background-color: #27a8d3;
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

                .password-info {
                    font-size: 12px;
                    color: #aaa;
                    margin-top: 5px;
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
                    <h1>${empty usuario ? 'Novo Usuário' : 'Editar Usuário'}</h1>

                    <!-- Exibe mensagens de sucesso ou erro se houver -->
                    <c:if test="${not empty sessionScope.mensagemSucesso}">
                        <div class="mensagem sucesso">
                            ${sessionScope.mensagemSucesso}
                        </div>
                        <c:remove var="mensagemSucesso" scope="session" />
                    </c:if>

                    <c:if test="${not empty sessionScope.mensagemErro}">
                        <div class="mensagem erro">
                            ${sessionScope.mensagemErro}
                        </div>
                        <c:remove var="mensagemErro" scope="session" />
                    </c:if>

                    <form action="${pageContext.request.contextPath}/admin/usuario/salvar" method="post">
                        <c:if test="${not empty usuario}">
                            <input type="hidden" name="id" value="${usuario.id}">
                        </c:if>

                        <div class="form-group">
                            <label for="nome">Nome</label>
                            <input type="text" id="nome" name="nome" value="${usuario.nome}" required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="${usuario.email}" required>
                        </div>

                        <div class="form-group">
                            <label for="senha">Senha</label>
                            <input type="password" id="senha" name="senha" ${empty usuario ? 'required' : '' }>
                            <c:if test="${not empty usuario}">
                                <div class="password-info">Deixe em branco para manter a senha atual.</div>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="nivelAcesso">Nível de Acesso</label>
                            <select id="nivelAcesso" name="nivelAcesso" required>
                                <option value="">Selecione...</option>
                                <option value="administrador" ${usuario.nivelAcesso=='administrador' ? 'selected' : ''
                                    }>Administrador</option>
                                <option value="operador" ${usuario.nivelAcesso=='operador' ? 'selected' : '' }>Operador
                                </option>
                            </select>
                        </div>

                        <div class="actions">
                            <a href="${pageContext.request.contextPath}/admin/usuarios" class="btn-voltar">Voltar</a>
                            <button type="submit" class="btn-salvar">Salvar</button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    // Validação do formulário antes do envio
                    const form = document.querySelector('form');

                    form.addEventListener('submit', function (event) {
                        const nome = document.getElementById('nome').value.trim();
                        const email = document.getElementById('email').value.trim();
                        const senha = document.getElementById('senha').value;
                        const nivelAcesso = document.getElementById('nivelAcesso').value;

                        if (nome === '') {
                            alert('Por favor, informe o nome do usuário.');
                            event.preventDefault();
                            return;
                        }

                        if (email === '') {
                            alert('Por favor, informe o e-mail do usuário.');
                            event.preventDefault();
                            return;
                        }

                        // Verificar se é um novo usuário (sem ID) e se a senha foi informada
                        const isNovoUsuario = !document.querySelector('input[name="id"]');
                        if (isNovoUsuario && senha === '') {
                            alert('Por favor, informe a senha para o novo usuário.');
                            event.preventDefault();
                            return;
                        }

                        if (nivelAcesso === '') {
                            alert('Por favor, selecione o nível de acesso do usuário.');
                            event.preventDefault();
                            return;
                        }
                    });
                });
            </script>
        </body>

        </html>