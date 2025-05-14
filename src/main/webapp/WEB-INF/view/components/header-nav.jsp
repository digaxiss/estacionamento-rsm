<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    String nivelAcesso = (String) session.getAttribute("nivelAcesso");
    boolean isAdmin = "administrador".equals(nivelAcesso);
    
    // Obtém a URL atual para destacar o menu ativo
    String requestURI = request.getRequestURI();
    String contextPath = request.getContextPath();
    String currentPage = requestURI.substring(contextPath.length());
%>

<header class="main-header">
    <div class="header-content">
        <div class="logo">
            <h1><i class="fas fa-parking"></i> Estacionamento</h1>
        </div>
        
        <nav class="main-nav">
            <ul>
                <li>
                    <a href="${pageContext.request.contextPath}/dashboard" class="<%= currentPage.contains("/dashboard") ? "active" : "" %>">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/entrada" class="<%= currentPage.contains("/entrada") ? "active" : "" %>">
                        <i class="fas fa-car"></i> Entrada
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/saida" class="<%= currentPage.contains("/saida") ? "active" : "" %>">
                        <i class="fas fa-sign-out-alt"></i> Saída
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/relatorio" class="<%= currentPage.contains("/relatorio") ? "active" : "" %>">
                        <i class="fas fa-chart-bar"></i> Relatórios
                    </a>
                </li>
                <% if(isAdmin) { %>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="<%= currentPage.contains("/admin") ? "active" : "" %>">
                        <i class="fas fa-cog"></i> Administração
                    </a>
                </li>
                <% } %>
            </ul>
        </nav>
        
        <div class="user-info">
            <div class="user-info-name">
                <p>Olá,</p>
                <span>${sessionScope.usuarioLogado.nome}</span>
            </div>
            <a href="${pageContext.request.contextPath}/login/logout" class="btn btn-primary">Sair</a>
        </div>
    </div>
</header>

<!-- Estilos do componente de cabeçalho e navegação -->
<style>
    /* Variáveis para cores e estilos */
    :root {
        --primary-color: #40c4ff;
        --primary-dark: #0094cc;
        --text-color: #ffffff;
        --light-text: #b0bec5;
        --border-color: #424242;
        --card-bg: #2c2c2c;
        --transition: all 0.3s ease;
        --border-radius: 5px;
    }
    
    /* Estilo para o header principal */
    .main-header {
        background-color: #1a1a1a;
        width: 100%;
        padding: 0;
        box-shadow: none;
        height: 60px;
        border-bottom: 1px solid #333;
        display: flex;
        align-items: stretch;
    }
    
    /* Conteúdo do header - ajustado para centralizar */
    .header-content {
        width: 100%;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 20px;
    }
    
    /* Estilo do logo */
    .logo {
        display: flex;
        align-items: center;
        width: 220px;
    }
    
    .logo h1 {
        color: var(--primary-color);
        font-size: 1.1rem;
        margin: 0;
        font-weight: 500;
        white-space: nowrap;
    }
    
    /* Navegação principal - centralizada */
    .main-nav {
        flex: 1;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    
    .main-nav ul {
        display: flex;
        list-style: none;
        padding: 0;
        margin: 0;
        justify-content: center;
    }
    
    .main-nav ul li {
        display: flex;
        align-items: center;
        height: 60px;
    }
    
    .main-nav ul li a {
        display: flex;
        align-items: center;
        height: 100%;
        gap: 3px;
        text-decoration: none;
        color: var(--light-text);
        transition: var(--transition);
        font-size: 0.9rem;
        font-weight: 400;
        border: none;
        padding: 0 15px;
    }
    
    .main-nav ul li a:hover {
        color: var(--primary-color);
        background-color: transparent;
    }
    
    .main-nav ul li a.active {
        color: var(--primary-color);
        background-color: #252525;
    }
    
    /* Informações do usuário */
    .user-info {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        width: 220px;
    }
    
    .user-info-name {
        display: flex;
        align-items: center;
    }
    
    .user-info p {
        display: inline;
        margin-right: 5px;
        color: #888;
        font-size: 0.85rem;
    }
    
    .user-info span {
        color: white;
        font-size: 0.85rem;
        font-weight: 400;
    }
    
    .user-info .btn {
        background-color: var(--primary-color);
        color: #212121;
        border: none;
        border-radius: 3px;
        padding: 0.2rem 0.6rem;
        font-size: 0.75rem;
        margin-left: 15px;
        cursor: pointer;
        text-decoration: none;
    }
    
    /* Responsive design */
    @media (max-width: 992px) {
        .logo,
        .user-info {
            width: auto;
        }
    }
    
    @media (max-width: 768px) {
        .header-content {
            flex-direction: column;
            height: auto;
            padding: 10px;
        }
        
        .main-nav {
            order: 3;
            width: 100%;
        }
        
        .main-nav ul {
            flex-direction: row;
            flex-wrap: wrap;
            width: 100%;
        }
        
        .main-nav ul li {
            height: 40px;
        }
        
        .user-info {
            width: 100%;
            justify-content: space-between;
            margin: 10px 0;
        }
    }
</style>

<!-- Incluir Font Awesome para os ícones -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
