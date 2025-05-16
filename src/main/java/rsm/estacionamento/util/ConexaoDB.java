package rsm.estacionamento.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Classe utilitária para gerenciar a conexão com o banco de dados
 */
public class ConexaoDB {
    
    // Parâmetros de conexão com o banco de dados
    private static final String URL = "jdbc:mysql://localhost:3306/estacionamento_db";
    private static final String USUARIO = "root";
    private static final String SENHA = "";
    
    /**
     * Inicializa o driver JDBC
     */
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Erro ao carregar driver MySQL: " + e.getMessage());
            throw new RuntimeException("Erro ao inicializar o driver MySQL", e);
        }
    }
    
    /**
     * Obtém uma conexão com o banco de dados
     * @return Objeto Connection para operações no banco
     * @throws SQLException Em caso de erro na conexão
     */
    public static Connection obterConexao() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, SENHA);
    }
    
    /**
     * Fecha uma conexão com o banco de dados
     * @param conn Conexão a ser fechada
     */
    public static void fecharConexao(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Erro ao fechar conexão: " + e.getMessage());
            }
        }
    }
}
