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
import java.util.ArrayList;
import java.util.List;

import rsm.estacionamento.model.Usuario;
import rsm.estacionamento.util.ConexaoDB;

/**
 * Servlet responsável pelas configurações do sistema (apenas para administrador)
 */
@WebServlet(urlPatterns = {"/admin", "/admin/dashboard", "/admin/usuarios", "/admin/configuracoes", 
                          "/admin/usuario/*", "/admin/configuracoes/*"})
public class ConfiguracaoController extends HttpServlet {
    
    /**
     * Processa as requisições GET para as páginas de administração
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Debug para identificar o caminho chamado
        System.out.println("ConfiguracaoController: Path = " + request.getRequestURI());
        
        // Verifica se o usuário é administrador
        if (!verificarPermissao(request, response)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());
        
        System.out.println("Path processado: " + path);
        
        if (path.equals("/admin") || path.equals("/admin/")) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        } else if (path.equals("/admin/dashboard")) {
            try {
                request.getRequestDispatcher("/WEB-INF/view/admin/dashboard.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                System.err.println("Erro ao carregar dashboard.jsp: " + e.getMessage());
                e.printStackTrace();
                response.getWriter().println("Erro ao carregar a página dashboard: " + e.getMessage());
            }
        }
        
        // Restante do código para outros paths...
        if (path.equals("/admin/usuarios")) {
            // Gerenciamento de usuários
            try {
                List<Usuario> usuarios = listarUsuarios();
                request.setAttribute("usuarios", usuarios);
                request.getRequestDispatcher("/WEB-INF/view/admin/usuarios.jsp").forward(request, response);
            } catch (SQLException e) {
                System.err.println("Erro ao listar usuários: " + e.getMessage());
                request.setAttribute("mensagemErro", "Erro ao listar usuários.");
                request.getRequestDispatcher("/WEB-INF/view/admin/dashboard.jsp").forward(request, response);
            }
        } else if (path.equals("/admin/configuracoes")) {
            // Configurações do sistema
            try {
                // Carrega configurações do banco de dados
                double valorPrimeiraHora = obterConfiguracao("valor_primeira_hora", 25.0);
                double valorHoraAdicional = obterConfiguracao("valor_hora_adicional", 9.0);
                int totalVagas = (int) obterConfiguracao("total_vagas", 30);
                
                request.setAttribute("valorPrimeiraHora", valorPrimeiraHora);
                request.setAttribute("valorHoraAdicional", valorHoraAdicional);
                request.setAttribute("totalVagas", totalVagas);
                
                request.getRequestDispatcher("/WEB-INF/view/admin/configuracoes.jsp").forward(request, response);
            } catch (SQLException e) {
                System.err.println("Erro ao obter configurações: " + e.getMessage());
                request.setAttribute("mensagemErro", "Erro ao carregar configurações.");
                request.getRequestDispatcher("/WEB-INF/view/admin/dashboard.jsp").forward(request, response);
            }
        } else if (path.equals("/admin/usuario/cadastrar") || path.equals("/admin/usuario/editar")) {
            // Formulário de cadastro/edição de usuário
            if (path.equals("/admin/usuario/editar") && request.getParameter("id") != null) {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Usuario usuario = buscarUsuario(id);
                    request.setAttribute("usuario", usuario);
                } catch (Exception e) {
                    System.err.println("Erro ao buscar usuário: " + e.getMessage());
                    request.setAttribute("mensagemErro", "Erro ao buscar dados do usuário.");
                }
            }
            request.getRequestDispatcher("/WEB-INF/view/admin/usuario_form.jsp").forward(request, response);
        } else {
            // Caminho inválido
            response.sendRedirect(request.getContextPath() + "/admin");
        }
    }
    
    /**
     * Processa as requisições POST para as configurações do sistema
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Verifica se o usuário é administrador
        if (!verificarPermissao(request, response)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String path = request.getPathInfo();
        
        if (path.equals("/configuracoes/salvar")) {
            // Salva as configurações do sistema
            try {
                double valorPrimeiraHora = Double.parseDouble(request.getParameter("valorPrimeiraHora"));
                double valorHoraAdicional = Double.parseDouble(request.getParameter("valorHoraAdicional"));
                int totalVagas = Integer.parseInt(request.getParameter("totalVagas"));
                
                // Salva configurações no banco de dados
                salvarConfiguracao("valor_primeira_hora", valorPrimeiraHora);
                salvarConfiguracao("valor_hora_adicional", valorHoraAdicional);
                salvarConfiguracao("total_vagas", totalVagas);
                
                request.setAttribute("mensagemSucesso", "Configurações salvas com sucesso!");
            } catch (Exception e) {
                System.err.println("Erro ao salvar configurações: " + e.getMessage());
                request.setAttribute("mensagemErro", "Erro ao salvar configurações.");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/configuracoes");
            
        } else if (path.equals("/usuario/salvar")) {
            // Salva dados de um usuário (novo ou existente)
            String idStr = request.getParameter("id");
            String nome = request.getParameter("nome");
            String email = request.getParameter("email");
            String senha = request.getParameter("senha");
            String nivelAcesso = request.getParameter("nivelAcesso");
            
            try {
                if (idStr == null || idStr.isEmpty()) {
                    // Novo usuário
                    cadastrarUsuario(nome, email, senha, nivelAcesso);
                    request.setAttribute("mensagemSucesso", "Usuário cadastrado com sucesso!");
                } else {
                    // Atualização de usuário existente
                    int id = Integer.parseInt(idStr);
                    atualizarUsuario(id, nome, email, senha, nivelAcesso);
                    request.setAttribute("mensagemSucesso", "Usuário atualizado com sucesso!");
                }
            } catch (Exception e) {
                System.err.println("Erro ao salvar usuário: " + e.getMessage());
                request.setAttribute("mensagemErro", "Erro ao salvar dados do usuário.");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/usuarios");
            
        } else if (path.equals("/usuario/excluir")) {
            // Exclui um usuário
            String idStr = request.getParameter("id");
            
            try {
                if (idStr != null && !idStr.isEmpty()) {
                    int id = Integer.parseInt(idStr);
                    excluirUsuario(id);
                    request.setAttribute("mensagemSucesso", "Usuário excluído com sucesso!");
                }
            } catch (Exception e) {
                System.err.println("Erro ao excluir usuário: " + e.getMessage());
                request.setAttribute("mensagemErro", "Erro ao excluir usuário.");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/usuarios");
        } else {
            // Caminho inválido
            response.sendRedirect(request.getContextPath() + "/admin");
        }
    }
    
    /**
     * Verifica se o usuário logado tem permissão de administrador
     * @return true se é administrador, false caso contrário
     */
    private boolean verificarPermissao(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("usuarioLogado") != null) {
            String nivelAcesso = (String) session.getAttribute("nivelAcesso");
            System.out.println("Verificando permissão - Nível de acesso: " + nivelAcesso);
            
            // Apenas administradores podem acessar a área admin
            return "administrador".equals(nivelAcesso);
        }
        
        return false;
    }
    
    /**
     * Obtém um valor de configuração do banco de dados
     * @param chave Nome da configuração
     * @param valorPadrao Valor padrão caso a configuração não exista
     * @return Valor da configuração
     * @throws SQLException Em caso de erro no banco de dados
     */
    private double obterConfiguracao(String chave, double valorPadrao) throws SQLException {
        String sql = "SELECT valor FROM configuracoes WHERE chave = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, chave);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("valor");
                }
            }
        }
        
        return valorPadrao;
    }
    
    /**
     * Salva um valor de configuração no banco de dados
     * @param chave Nome da configuração
     * @param valor Valor da configuração
     * @throws SQLException Em caso de erro no banco de dados
     */
    private void salvarConfiguracao(String chave, double valor) throws SQLException {
        String sql = "INSERT INTO configuracoes (chave, valor) VALUES (?, ?) " +
                     "ON DUPLICATE KEY UPDATE valor = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, chave);
            stmt.setDouble(2, valor);
            stmt.setDouble(3, valor);
            
            stmt.executeUpdate();
        }
    }
    
    /**
     * Lista todos os usuários cadastrados
     * @return Lista de usuários
     * @throws SQLException Em caso de erro no banco de dados
     */
    private List<Usuario> listarUsuarios() throws SQLException {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT id, nome, email, nivel_acesso FROM usuarios ORDER BY nome";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setId(rs.getInt("id"));
                usuario.setNome(rs.getString("nome"));
                usuario.setEmail(rs.getString("email"));
                usuario.setNivelAcesso(rs.getString("nivel_acesso"));
                
                usuarios.add(usuario);
            }
        }
        
        return usuarios;
    }
    
    /**
     * Busca um usuário pelo ID
     * @param id ID do usuário
     * @return Objeto Usuario
     * @throws SQLException Em caso de erro no banco de dados
     */
    private Usuario buscarUsuario(int id) throws SQLException {
        String sql = "SELECT id, nome, email, nivel_acesso FROM usuarios WHERE id = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Usuario usuario = new Usuario();
                    usuario.setId(rs.getInt("id"));
                    usuario.setNome(rs.getString("nome"));
                    usuario.setEmail(rs.getString("email"));
                    usuario.setNivelAcesso(rs.getString("nivel_acesso"));
                    return usuario;
                }
            }
        }
        
        return null;
    }
    
    /**
     * Cadastra um novo usuário
     * @throws SQLException Em caso de erro no banco de dados
     */
    private void cadastrarUsuario(String nome, String email, String senha, String nivelAcesso) throws SQLException {
        String sql = "INSERT INTO usuarios (nome, email, senha, nivel_acesso) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, nome);
            stmt.setString(2, email);
            stmt.setString(3, senha); // Em produção, usar hash para senha
            stmt.setString(4, nivelAcesso);
            
            stmt.executeUpdate();
        }
    }
    
    /**
     * Atualiza os dados de um usuário existente
     * @throws SQLException Em caso de erro no banco de dados
     */
    private void atualizarUsuario(int id, String nome, String email, String senha, String nivelAcesso) throws SQLException {
        String sql;
        
        if (senha != null && !senha.trim().isEmpty()) {
            // Se a senha foi informada, atualiza também
            sql = "UPDATE usuarios SET nome = ?, email = ?, senha = ?, nivel_acesso = ? WHERE id = ?";
        } else {
            // Se a senha não foi informada, mantém a atual
            sql = "UPDATE usuarios SET nome = ?, email = ?, nivel_acesso = ? WHERE id = ?";
        }
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, nome);
            stmt.setString(2, email);
            
            if (senha != null && !senha.trim().isEmpty()) {
                stmt.setString(3, senha); // Em produção, usar hash para senha
                stmt.setString(4, nivelAcesso);
                stmt.setInt(5, id);
            } else {
                stmt.setString(3, nivelAcesso);
                stmt.setInt(4, id);
            }
            
            stmt.executeUpdate();
        }
    }
    
    /**
     * Exclui um usuário
     * @throws SQLException Em caso de erro no banco de dados
     */
    private void excluirUsuario(int id) throws SQLException {
        String sql = "DELETE FROM usuarios WHERE id = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }
}
