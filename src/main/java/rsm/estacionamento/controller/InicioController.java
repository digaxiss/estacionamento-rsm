package rsm.estacionamento.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet que serve como ponto de entrada do sistema
 * Redireciona para a página de login
 */
@WebServlet("")
public class InicioController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redireciona para a página de login
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
