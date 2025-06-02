package rsm.estacionamento.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

import rsm.estacionamento.model.Usuario;
import rsm.estacionamento.util.ConexaoDB;

/**
 * Servlet responsável pelo controle de login dos usuários
 * Trata as requisições de autenticação, validação e logout
 */
@WebServlet("/login/*")
public class LoginController extends HttpServlet {
    
    /**
     * Processa as requisições GET:
     * - /login (exibe página de login)
     * - /login/logout (realiza o logout do usuário)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getPathInfo();
        
        // Debug dos parâmetros de URL
        System.out.println("Path do login: " + path);
        
        // Se o caminho for logout, invalida a sessão e redireciona para login
        if (path != null && path.equals("/logout")) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Exibe a página de login
        // Primeiro garantindo que o arquivo existe
        try {
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
        } catch (Exception e) {
            // Registra o erro para debugging
            System.err.println("Erro ao carregar login.jsp: " + e.getMessage());
            e.printStackTrace();
            
            // Mensagem de erro simples para o usuário
            response.setContentType("text/html");
            response.getWriter().println("<html><body>");
            response.getWriter().println("<h1>Erro ao carregar página de login</h1>");
            response.getWriter().println("<p>Detalhes: " + e.getMessage() + "</p>");
            response.getWriter().println("</body></html>");
        }
    }
    
    /**
     * Processa as requisições POST para autenticação
     * Valida email e senha no banco de dados
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        
        // Validação básica dos campos
        if (email == null || senha == null || email.trim().isEmpty() || senha.trim().isEmpty()) {
            request.setAttribute("mensagemErro", "Email e senha são obrigatórios.");
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Tenta autenticar o usuário
            Usuario usuario = autenticar(email, senha);
            
            if (usuario != null) {
                // Se autenticado, cria uma sessão e redireciona para a página inicial
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogado", usuario);
                session.setAttribute("nivelAcesso", usuario.getNivelAcesso());
                
                // Log para debug
                System.out.println("Usuário autenticado: " + usuario.getNome() + ", Nível: " + usuario.getNivelAcesso());
                
                // Redireciona para o dashboard após login
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                // Se não autenticado, exibe mensagem de erro
                request.setAttribute("mensagemErro", "Email ou senha inválidos.");
                request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            // Log do erro
            System.err.println("Erro ao autenticar usuário: " + e.getMessage());
            e.printStackTrace();
            
            // Exibe mensagem de erro genérica
            request.setAttribute("mensagemErro", "Erro ao processar login. Tente novamente.");
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
        }
    }
    
    /**
     * Método que verifica se o email e senha correspondem a um usuário válido no banco de dados
     * @param email Email informado
     * @param senha Senha informada
     * @return Objeto Usuario se autenticado com sucesso, null caso contrário
     * @throws SQLException Em caso de erro no banco de dados
     */
    private Usuario autenticar(String email, String senhaDigitada) throws SQLException {
    String sql = "SELECT * FROM usuarios WHERE email = ?";
    
    try (Connection conn = ConexaoDB.obterConexao();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, email);

        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                String senhaBanco = rs.getString("senha");
                boolean autenticado = false;
                boolean precisaAtualizarHash = false;

                if (senhaBanco != null && senhaBanco.startsWith("$2a$")) {
                    // Senha já está criptografada
                    autenticado = BCrypt.checkpw(senhaDigitada, senhaBanco);
                } else {
                    // Senha em texto plano
                    autenticado = senhaDigitada.equals(senhaBanco);
                    if (autenticado) {
                        precisaAtualizarHash = true;
                    }
                }

                if (autenticado) {
                    // Atualiza a senha para hash se necessário
                    if (precisaAtualizarHash) {
                        String novoHash = BCrypt.hashpw(senhaDigitada, BCrypt.gensalt());
                        String updateSql = "UPDATE usuarios SET senha = ? WHERE id = ?";
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                            updateStmt.setString(1, novoHash);
                            updateStmt.setLong(2, rs.getLong("id"));
                            updateStmt.executeUpdate();
                        }
                    }

                    // Retorna usuário autenticado
                    Usuario usuario = new Usuario();
                    usuario.setId((int) rs.getLong("id"));
                    usuario.setNome(rs.getString("nome"));
                    usuario.setEmail(rs.getString("email"));
                    usuario.setSenha(senhaBanco); // pode retornar o hash
                    usuario.setNivelAcesso(rs.getString("nivel_acesso"));
                    return usuario;
                }
            }
        }
    }

    return null;
}
}
