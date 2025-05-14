package rsm.estacionamento.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filtro para garantir que apenas usuários autenticados acessem páginas restritas
 */
@WebFilter(urlPatterns = {"/dashboard", "/entrada", "/saida", "/relatorio", "/admin/*"})
public class AutenticacaoFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inicialização do filtro
    }
    
    /**
     * Filtra requisições para verificar se o usuário está autenticado
     * e tem permissão para acessar a página solicitada
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Obtém a sessão sem criar uma nova se não existir
        HttpSession session = httpRequest.getSession(false);
        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Verifica se o usuário está logado
        boolean isLogado = (session != null && session.getAttribute("usuarioLogado") != null);
        
        System.out.println("AutenticacaoFilter: URI = " + uri + ", Logged in = " + isLogado);
        
        // Se for uma página de administrador, verifica também o nível de acesso
        if (uri.contains("/admin/")) {
            String nivelAcesso = (session != null) ? (String) session.getAttribute("nivelAcesso") : null;
            System.out.println("AutenticacaoFilter: Área administrativa, nível de acesso = " + nivelAcesso);
            
            if (!"administrador".equals(nivelAcesso)) {
                // Se não for administrador, redireciona para página inicial ou de acesso negado
                System.out.println("AutenticacaoFilter: Acesso negado à área administrativa");
                
                if (isLogado) {
                    // Se estiver logado mas não for admin, redireciona para a entrada
                    httpResponse.sendRedirect(contextPath + "/entrada");
                } else {
                    // Se não estiver logado, redireciona para o login
                    httpResponse.sendRedirect(contextPath + "/login");
                }
                return;
            }
        }
        
        if (isLogado) {
            // Usuário está logado, continua o processamento
            chain.doFilter(request, response);
        } else {
            // Redireciona para a tela de login
            System.out.println("AutenticacaoFilter: Redirecionando para login");
            httpResponse.sendRedirect(contextPath + "/login");
        }
    }
    
    @Override
    public void destroy() {
        // Finalização do filtro
    }
}
