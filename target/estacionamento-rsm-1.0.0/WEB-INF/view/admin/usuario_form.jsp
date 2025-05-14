<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty usuario ? 'Novo Usuário' : 'Editar Usuário'} - Estacionamento 24 Horas</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .content {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }
        
        h1 {
            color: #333;
            border-bottom: 2px solid #30bced;
            padding-bottom: 10px;
            margin-top: 0;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        input[type="text"],
        input[type="email"],
        input[type="password"],
        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
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
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .erro {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .actions {
            margin-top: 30px;
            display: flex;
        }
        
        .password-info {
            font-size: 12px;
            color: #666;
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
            
            .btn-voltar, .btn-salvar {
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
            <c:if test="${not empty mensagemSucesso}">
                <div class="mensagem sucesso">
                    ${mensagemSucesso}
                </div>
            </c:if>
            
            <c:if test="${not empty mensagemErro}">
                <div class="mensagem erro">
                    ${mensagemErro}
                </div>
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
                    <input type="password" id="senha" name="senha" ${empty usuario ? 'required' : ''}>
                    <c:if test="${not empty usuario}">
                        <div class="password-info">Deixe em branco para manter a senha atual.</div>
                    </c:if>
                </div>
                
                <div class="form-group">
                    <label for="nivelAcesso">Nível de Acesso</label>
                    <select id="nivelAcesso" name="nivelAcesso" required>
                        <option value="">Selecione...</option>
                        <option value="administrador" ${usuario.nivelAcesso == 'administrador' ? 'selected' : ''}>Administrador</option>
                        <option value="operador" ${usuario.nivelAcesso == 'operador' ? 'selected' : ''}>Operador</option>
                    </select>
                </div>
                
                <div class="actions">
                    <a href="${pageContext.request.contextPath}/admin/usuarios" class="btn-voltar">Voltar</a>
                    <button type="submit" class="btn-salvar">Salvar</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
