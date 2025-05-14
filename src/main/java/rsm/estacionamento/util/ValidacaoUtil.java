package rsm.estacionamento.util;

import java.util.regex.Pattern;

/**
 * Classe utilitária para validação de dados
 */
public class ValidacaoUtil {
    
    // Padrão Mercosul: 3 letras, 1 número, 1 letra, 2 números (ex: ABC1D23)
    private static final Pattern PADRAO_MERCOSUL = Pattern.compile("[A-Z]{3}[0-9][A-Z][0-9]{2}");
    
    // Padrão antigo: 3 letras, 4 números (ex: ABC1234)
    private static final Pattern PADRAO_ANTIGO = Pattern.compile("[A-Z]{3}[0-9]{4}");
    
    /**
     * Valida o formato da placa de um veículo (aceita padrão Mercosul ou antigo)
     * @param placa Placa a ser validada
     * @return true se a placa é válida, false caso contrário
     */
    public static boolean validarPlaca(String placa) {
        if (placa == null || placa.trim().isEmpty()) {
            return false;
        }
        
        // Padroniza a placa para maiúsculas e sem espaços
        placa = placa.toUpperCase().trim();
        
        // Verifica se atende a um dos padrões
        return PADRAO_MERCOSUL.matcher(placa).matches() || PADRAO_ANTIGO.matcher(placa).matches();
    }
    
    /**
     * Valida se um email tem formato válido
     * @param email Email a ser validado
     * @return true se o email é válido, false caso contrário
     */
    public static boolean validarEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        
        // Padrão básico para validação de email
        String regex = "^[A-Za-z0-9+_.-]+@(.+)$";
        return Pattern.matches(regex, email);
    }
    
    /**
     * Valida se uma senha tem o comprimento mínimo
     * @param senha Senha a ser validada
     * @param comprimentoMinimo Comprimento mínimo exigido
     * @return true se a senha é válida, false caso contrário
     */
    public static boolean validarSenha(String senha, int comprimentoMinimo) {
        return senha != null && senha.length() >= comprimentoMinimo;
    }
}
