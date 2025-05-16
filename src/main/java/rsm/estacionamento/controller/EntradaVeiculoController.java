package rsm.estacionamento.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import rsm.estacionamento.model.Veiculo;
import rsm.estacionamento.util.ConexaoDB;
import rsm.estacionamento.util.ValidacaoUtil;

/**
 * Servlet responsável pelo controle de entrada de veículos no estacionamento
 * Registra a entrada de novos veículos e valida o formato das placas
 */
@WebServlet("/entrada")
public class EntradaVeiculoController extends HttpServlet {
    
    /**
     * Exibe a página de entrada de veículos, mostrando o número de vagas disponíveis
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Log para debug
            System.out.println("EntradaVeiculoController: Iniciando processamento do GET");
            
            // Verifica o número de vagas disponíveis
            int vagasDisponiveis = verificarVagasDisponiveis();
            request.setAttribute("vagasDisponiveis", vagasDisponiveis);
            
            // Obtém a configuração do total de vagas do sistema
            int totalVagas = obterTotalVagas();
            request.setAttribute("totalVagas", totalVagas);
            
            System.out.println("EntradaVeiculoController: Vagas disponíveis: " + vagasDisponiveis + " de " + totalVagas);
            
            // Encaminha para a página de entrada de veículos
            try {
                request.getRequestDispatcher("/WEB-INF/view/entrada.jsp").forward(request, response);
            } catch (Exception e) {
                System.err.println("Erro ao carregar entrada.jsp: " + e.getMessage());
                e.printStackTrace();
                
                // Resposta simples em caso de erro com JSP
                response.setContentType("text/html");
                response.getWriter().println("<html><body>");
                response.getWriter().println("<h1>Erro ao carregar página de entrada</h1>");
                response.getWriter().println("<p>Detalhes: " + e.getMessage() + "</p>");
                response.getWriter().println("<p><a href='" + request.getContextPath() + "/login'>Voltar para login</a></p>");
                response.getWriter().println("</body></html>");
            }
            
        } catch (SQLException e) {
            // Log do erro
            System.err.println("Erro ao verificar vagas disponíveis: " + e.getMessage());
            e.printStackTrace();
            
            // Exibe mensagem de erro
            request.setAttribute("mensagemErro", "Erro ao verificar vagas disponíveis.");
            
            // Resposta de erro simples
            response.setContentType("text/html");
            response.getWriter().println("<html><body>");
            response.getWriter().println("<h1>Erro no sistema</h1>");
            response.getWriter().println("<p>Ocorreu um erro ao processar a solicitação: " + e.getMessage() + "</p>");
            response.getWriter().println("<p><a href='" + request.getContextPath() + "/login'>Voltar para login</a></p>");
            response.getWriter().println("</body></html>");
        }
    }
    
    /**
     * Processa o registro de entrada de um novo veículo
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Obtém os parâmetros do formulário
        String placa = request.getParameter("placa");
        String tipoVeiculo = request.getParameter("tipoVeiculo");
        String observacoes = request.getParameter("observacoes");
        
        // Valida o formato da placa (padrão Mercosul ou antigo)
        if (!ValidacaoUtil.validarPlaca(placa)) {
            request.setAttribute("mensagemErro", "Formato de placa inválido.");
            doGet(request, response);
            return;
        }
        
        try {
            // Verifica se o veículo já está no estacionamento
            if (veiculoJaEstacionado(placa)) {
                request.setAttribute("mensagemErro", "Este veículo já está no estacionamento.");
                doGet(request, response);
                return;
            }
            
            // Verifica se há vagas disponíveis
            int vagasDisponiveis = verificarVagasDisponiveis();
            if (vagasDisponiveis <= 0) {
                request.setAttribute("mensagemErro", "Não há vagas disponíveis no estacionamento.");
                doGet(request, response);
                return;
            }
            
            // Registra a entrada do veículo no banco de dados
            boolean sucesso = registrarEntrada(placa, tipoVeiculo, observacoes);
            
            if (sucesso) {
                request.setAttribute("mensagemSucesso", "Entrada do veículo registrada com sucesso!");
            } else {
                request.setAttribute("mensagemErro", "Erro ao registrar entrada do veículo.");
            }
            
            doGet(request, response);
            
        } catch (SQLException e) {
            // Log do erro
            System.err.println("Erro ao processar entrada de veículo: " + e.getMessage());
            
            // Exibe mensagem de erro
            request.setAttribute("mensagemErro", "Erro ao registrar entrada do veículo.");
            doGet(request, response);
        }
    }
    
    /**
     * Verifica quantas vagas estão disponíveis no estacionamento
     * @return Número de vagas disponíveis
     * @throws SQLException Em caso de erro no banco de dados
     */
    private int verificarVagasDisponiveis() throws SQLException {
        String sql = "SELECT COUNT(*) AS ocupadas FROM veiculos_estacionados WHERE saida IS NULL";
        int totalVagas = obterTotalVagas();
        
        try (Connection conn = ConexaoDB.obterConexao();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                int vagasOcupadas = rs.getInt("ocupadas");
                return totalVagas - vagasOcupadas;
            }
        }
        
        return totalVagas;
    }
    
    /**
     * Obtém o número total de vagas configurado no sistema
     * @return Total de vagas
     * @throws SQLException Em caso de erro no banco de dados
     */
    private int obterTotalVagas() throws SQLException {
        String sql = "SELECT valor FROM configuracoes WHERE chave = 'total_vagas'";
        
        try (Connection conn = ConexaoDB.obterConexao();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("valor");
            }
        }
        
        // Valor padrão, caso não encontre no banco
        return 30;
    }
    
    /**
     * Verifica se um veículo já está estacionado
     * @param placa Placa do veículo
     * @return true se o veículo já estiver estacionado, false caso contrário
     * @throws SQLException Em caso de erro no banco de dados
     */
    private boolean veiculoJaEstacionado(String placa) throws SQLException {
        String sql = "SELECT COUNT(*) AS total FROM veiculos_estacionados WHERE placa = ? AND saida IS NULL";
        
        try (Connection conn = ConexaoDB.obterConexao();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, placa);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total") > 0;
                }
            }
        }
        
        return false;
    }
    
    /**
     * Registra a entrada de um veículo no banco de dados
     * @param placa Placa do veículo
     * @param tipoVeiculo Tipo do veículo
     * @param observacoes Observações sobre o veículo
     * @return true se o registro foi bem-sucedido, false caso contrário
     * @throws SQLException Em caso de erro no banco de dados
     */
    private boolean registrarEntrada(String placa, String tipoVeiculo, String observacoes) throws SQLException {
        String sql = "INSERT INTO veiculos_estacionados (placa, tipo_veiculo, entrada, observacoes) VALUES (?, ?, NOW(), ?)";
        
        try (Connection conn = ConexaoDB.obterConexao();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, placa);
            stmt.setString(2, tipoVeiculo);
            stmt.setString(3, observacoes);
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
        }
    }
}
