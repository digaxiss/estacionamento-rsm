package com.estacionamento.listener;

import com.estacionamento.util.DatabaseConfig;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class ApplicationListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // O pool já será inicializado quando a classe DatabaseConfig for carregada
        System.out.println("Aplicação iniciada: Pool de conexões HikariCP inicializado.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Fecha o pool de conexões quando a aplicação for encerrada
        DatabaseConfig.closeDataSource();
        System.out.println("Aplicação encerrada: Pool de conexões HikariCP fechado.");
    }
}
