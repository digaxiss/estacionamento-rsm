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

import rsm.estacionamento.util.LogUtil;

/**
 * Filtro para diagnóstico de requisições ao servidor
 */
@WebFilter("/*")
public class DiagnosticFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inicialização do filtro
        LogUtil.info("DiagnosticFilter", "Filtro de diagnóstico inicializado");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Registra informações da requisição
        String uri = httpRequest.getRequestURI();
        String method = httpRequest.getMethod();
        String queryString = httpRequest.getQueryString() != null ? "?" + httpRequest.getQueryString() : "";
        String userAgent = httpRequest.getHeader("User-Agent");
        
        // Informação da sessão
        HttpSession session = httpRequest.getSession(false);
        String sessionInfo = "No session";
        if (session != null) {
            if (session.getAttribute("usuarioLogado") != null) {
                try {
                    Object usuario = session.getAttribute("usuarioLogado");
                    String nivelAcesso = (String) session.getAttribute("nivelAcesso");
                    // Extrair nome do usuário via reflexão
                    java.lang.reflect.Method method1 = usuario.getClass().getMethod("getNome");
                    String nome = (String) method1.invoke(usuario);
                    sessionInfo = "Session: " + session.getId() + ", Usuario: " + nome + ", Nivel: " + nivelAcesso;
                } catch (Exception e) {
                    sessionInfo = "Session: " + session.getId() + " (erro ao obter detalhes)";
                }
            } else {
                sessionInfo = "Session: " + session.getId() + " (sem usuário)";
            }
        }
        
        // Log da requisição
        LogUtil.info("Request", method + " " + uri + queryString + " | " + sessionInfo + " | " + userAgent);
        
        try {
            // Continua o processamento
            chain.doFilter(request, response);
            
            // Log da resposta
            int status = httpResponse.getStatus();
            LogUtil.info("Response", "Status: " + status + " para " + uri);
        } catch (Exception e) {
            LogUtil.error("Request", "Erro processando " + uri, e);
            throw e;
        }
    }
    
    @Override
    public void destroy() {
        // Finalização do filtro
        LogUtil.info("DiagnosticFilter", "Filtro de diagnóstico finalizado");
    }
}
