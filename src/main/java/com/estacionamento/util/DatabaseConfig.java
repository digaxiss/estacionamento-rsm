package com.estacionamento.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DatabaseConfig {
    private static HikariDataSource dataSource;
    
    static {
        try {
            // Carregar o driver JDBC
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Configurar o HikariCP
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl("jdbc:mysql://localhost:3306/estacionamento");
            config.setUsername("seu_usuario");
            config.setPassword("sua_senha");
            
            // Configurações de performance
            config.setMaximumPoolSize(10); // Número máximo de conexões no pool
            config.setMinimumIdle(5); // Número mínimo de conexões ociosas
            config.setIdleTimeout(30000); // Tempo máximo que uma conexão pode ficar ociosa (30 segundos)
            config.setConnectionTimeout(10000); // Tempo máximo de espera para obter uma conexão (10 segundos)
            config.setMaxLifetime(1800000); // Tempo máximo de vida de uma conexão (30 minutos)
            
            // Configurações adicionais
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
            config.addDataSourceProperty("useServerPrepStmts", "true");
            
            // Criar o datasource
            dataSource = new HikariDataSource(config);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Erro ao carregar o driver MySQL", e);
        }
    }
    
    // Método para obter uma conexão do pool
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
    
    // Método para fechar o datasource (chamado ao encerrar a aplicação)
    public static void closeDataSource() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}
