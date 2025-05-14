package rsm.estacionamento.util;

import java.io.FileWriter;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Classe utilitária para registrar logs do sistema
 */
public class LogUtil {
    
    private static final String LOG_FILE = System.getProperty("catalina.base") + "/logs/estacionamento-app.log";
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    
    /**
     * Registra uma mensagem informativa
     * @param source Classe ou componente de origem
     * @param message Mensagem a ser registrada
     */
    public static void info(String source, String message) {
        log("INFO", source, message);
    }
    
    /**
     * Registra uma mensagem de erro
     * @param source Classe ou componente de origem
     * @param message Mensagem de erro
     */
    public static void error(String source, String message) {
        log("ERROR", source, message);
    }
    
    /**
     * Registra uma mensagem de erro com exceção
     * @param source Classe ou componente de origem
     * @param message Mensagem de erro
     * @param e Exceção que ocorreu
     */
    public static void error(String source, String message, Exception e) {
        log("ERROR", source, message + " - " + e.getMessage());
        
        try (PrintWriter writer = new PrintWriter(new FileWriter(LOG_FILE, true))) {
            writer.println(formatLogEntry("ERROR", source, "Stack trace:"));
            e.printStackTrace(writer);
        } catch (Exception ex) {
            System.err.println("Erro ao registrar exceção no arquivo de log: " + ex.getMessage());
        }
    }
    
    /**
     * Registra uma entrada no log
     */
    private static void log(String level, String source, String message) {
        try (PrintWriter writer = new PrintWriter(new FileWriter(LOG_FILE, true))) {
            writer.println(formatLogEntry(level, source, message));
        } catch (Exception e) {
            System.err.println("Erro ao registrar mensagem no arquivo de log: " + e.getMessage());
        }
        
        // Também exibe no console
        System.out.println(formatLogEntry(level, source, message));
    }
    
    /**
     * Formata uma entrada de log
     */
    private static String formatLogEntry(String level, String source, String message) {
        return String.format("[%s] [%s] [%s] %s", 
                            LocalDateTime.now().format(FORMATTER),
                            level,
                            source,
                            message);
    }
}
