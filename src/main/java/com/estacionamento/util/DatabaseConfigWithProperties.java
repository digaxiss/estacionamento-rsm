package com.estacionamento.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConfigWithProperties {
    private static HikariDataSource dataSource;
    
    static {
        try {
            // Carregar propriedades do arquivo de configuração
            Properties props = new Properties();
            try (InputStream input = DatabaseConfigWithProperties.class
                    .getClassLoader()
                    .getResourceAsStream("database.properties")) {
                
                if (input == null) {
                    throw new RuntimeException("Arquivo database.properties não encontrado");
                }
                
                props.load(input);
            }
            
            // Configurar HikariCP com as propriedades
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(props.getProperty("db.url"));
            config.setUsername(props.getProperty("db.username"));
            config.setPassword(props.getProperty("db.password"));
            config.setDriverClassName(props.getProperty("db.driver"));
            
            // Configurações de pool
            config.setMaximumPoolSize(Integer.parseInt(props.getProperty("pool.maxSize", "10")));
            config.setMinimumIdle(Integer.parseInt(props.getProperty("pool.minIdle", "5")));
            config.setIdleTimeout(Long.parseLong(props.getProperty("pool.idleTimeout", "30000")));
            config.setConnectionTimeout(Long.parseLong(props.getProperty("pool.connectionTimeout", "10000")));
            
            // Propriedades adicionais
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
            
            // Criar o datasource
            dataSource = new HikariDataSource(config);
        } catch (IOException e) {
            throw new RuntimeException("Erro ao carregar arquivo de propriedades do banco de dados", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
    
    public static void closeDataSource() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}
