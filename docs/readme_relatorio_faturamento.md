# Relatórios de Faturamento - Sistema de Estacionamento RSM

## Sobre as Alterações Implementadas

Foi implementada a funcionalidade de geração de relatórios de faturamento no sistema de estacionamento, permitindo visualizar os valores recebidos em diferentes períodos (diário, semanal e mensal). Esta funcionalidade fornece informações essenciais para o controle financeiro do estacionamento.

## Funcionalidades Implementadas

### 1. Relatório Diário
- Permite selecionar uma data específica para visualização
- Exibe todas as movimentações com pagamento nessa data
- Mostra o valor total faturado nesse dia
- Formato: "(diário) dia 01/04/2025 - valor total recebido no dia R$ xxxx,00"

### 2. Relatório Semanal
- Permite selecionar uma data final, e o sistema automaticamente calcula 7 dias para trás
- A data selecionada pelo usuário é a data fim do período
- O sistema calcula a data inicial como sendo 6 dias antes (totalizando 7 dias)
- Exibe o faturamento total do período semanal
- Formato: "(semanal) periodo entre 01 e 07/04/2025 valor total recebido neste periodo: R$ xxx.xxx,00"

### 3. Relatório Mensal
- Permite selecionar um mês e ano específicos
- O sistema calcula automaticamente o primeiro e último dia do mês
- Exibe o faturamento total do mês selecionado
- Formato: "(mensal) periodo entre 01 e 30/04/2025 – valor total recebido neste periodo: R$ xxxx.xxx,00"

## Como Funciona

### Integração com o Menu Principal
Foi adicionado um botão "Relatórios" no menu principal do sistema, dando acesso à nova funcionalidade de geração de relatórios de faturamento conforme especificado nos requisitos.

### Backend (RelatorioController)

O controlador `RelatorioController.java` processa as solicitações de relatório e:

1. Recebe o tipo de filtro (diário, semanal ou mensal) e a data selecionada
2. Calcula as datas de início e fim conforme o tipo de relatório
3. Busca no banco de dados as movimentações com saída registrada no período
4. Calcula o valor total das movimentações
5. Formata os resultados para exibição na página JSP

### Interface de Usuário (relatorio.jsp)

A página de relatórios apresenta:

1. Opções de filtro (diário, semanal, mensal)
2. Campos de seleção de data apropriados para cada tipo
3. Exibição do período selecionado e valor total
4. Listagem de todas as movimentações do período com detalhes
5. Botão para impressão do relatório

## Detalhamento Técnico

### Formatadores de Data
Para garantir a consistência na apresentação e processamento das datas, foram definidos os seguintes formatadores:
- `DATE_FORMATTER`: Para processamento interno (yyyy-MM-dd)
- `MONTH_FORMATTER`: Para processamento de mês/ano (yyyy-MM)
- `DISPLAY_DATE_FORMATTER`: Para exibição de datas no formato brasileiro (dd/MM/yyyy)
- `DISPLAY_MONTH_FORMATTER`: Para exibição de mês/ano (MMMM/yyyy)

### Cálculo de Datas
- **Relatório Diário:** A data início é igual à data fim (mesmo dia)
- **Relatório Semanal:** Data fim é a data selecionada, data início é 6 dias antes
- **Relatório Mensal:** Data início é o primeiro dia do mês, data fim é o último dia do mês

### Filtro de Movimentações
- São consideradas apenas as saídas registradas no período (veículos que pagaram)
- A consulta SQL filtra as movimentações pela data de saída, não pela data de entrada
- Os valores são calculados somando-se o campo "valor_pago" das movimentações

### Apresentação
- Datas são exibidas no formato brasileiro (dd/MM/yyyy)
- Valores são formatados com vírgula como separador decimal
- Os dados são ordenados para mostrar as movimentações mais recentes primeiro

## Instruções de Uso

1. Acesse a opção "Relatórios" no menu do sistema
2. Selecione o tipo de relatório desejado (diário, semanal ou mensal)
3. Escolha a data conforme o tipo:
   - Diário: Selecione qualquer data 
   - Semanal: Selecione a data final do período (o sistema calcula os 7 dias)
   - Mensal: Selecione o mês e ano desejados
4. Clique em "Filtrar" para gerar o relatório
5. Visualize os resultados e use o botão "Imprimir Relatório" se necessário

## Observações Importantes

- Os relatórios consideram apenas veículos que já saíram do estacionamento (com pagamento registrado)
- A data utilizada para o cálculo do faturamento é a data de saída do veículo
- Se nenhuma data for selecionada, o sistema usa a data atual como padrão

## Código Implementado

### Formatadores de Data
```java
private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
private static final DateTimeFormatter MONTH_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM");
private static final DateTimeFormatter DISPLAY_DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");
private static final DateTimeFormatter DISPLAY_MONTH_FORMATTER = DateTimeFormatter.ofPattern("MMMM/yyyy");
```

### Implementação dos Filtros de Período no RelatorioController.java

```java
// Processar os parâmetros conforme o tipo de filtro
switch (tipoFiltro) {
    case "diario":
        String dataDiaria = request.getParameter("dataDiaria");
        LocalDate dataDiariaObj = dataDiaria != null && !dataDiaria.isEmpty() 
                                ? LocalDate.parse(dataDiaria) 
                                : LocalDate.now();
        
        dataInicio = dataDiariaObj;
        dataFim = dataDiariaObj;
        
        periodoFormatado = "(diário) dia " + dataInicio.format(DISPLAY_DATE_FORMATTER) + 
                          " - valor total recebido no dia R$ ";
        request.setAttribute("dataDiaria", dataDiariaObj.format(DATE_FORMATTER));
        break;
        
    case "semanal":
        String dataSemanal = request.getParameter("dataSemanal");
        LocalDate dataSemanalObj = dataSemanal != null && !dataSemanal.isEmpty() 
                                 ? LocalDate.parse(dataSemanal) 
                                 : LocalDate.now();
        
        // A data fim é a data selecionada, a data início é 6 dias antes (total 7 dias)
        dataFim = dataSemanalObj;
        dataInicio = dataFim.minusDays(6);
        
        periodoFormatado = "(semanal) periodo entre " + dataInicio.format(DISPLAY_DATE_FORMATTER) + 
                          " e " + dataFim.format(DISPLAY_DATE_FORMATTER) + 
                          " valor total recebido neste periodo: R$ ";
        request.setAttribute("dataSemanal", dataSemanalObj.format(DATE_FORMATTER));
        break;
        
    case "mensal":
        String dataMensal = request.getParameter("dataMensal");
        YearMonth mesAno;
        
        if (dataMensal != null && !dataMensal.isEmpty()) {
            mesAno = YearMonth.parse(dataMensal);
        } else {
            mesAno = YearMonth.now();
        }
        
        // Primeiro e último dia do mês selecionado
        dataInicio = mesAno.atDay(1);
        dataFim = mesAno.atEndOfMonth();
        
        periodoFormatado = "(mensal) periodo entre " + dataInicio.format(DISPLAY_DATE_FORMATTER) + 
                          " e " + dataFim.format(DISPLAY_DATE_FORMATTER) + 
                          " – valor total recebido neste periodo: R$ ";
        request.setAttribute("dataMensal", mesAno.format(MONTH_FORMATTER));
        break;
}
```

### Função para Cálculo do Valor Total
```java
/**
 * Calcula o valor total das movimentações
 */
private double calcularTotalValor(List<Movimentacao> movimentacoes) {
    double totalValor = 0.0;
    for (Movimentacao m : movimentacoes) {
        if (m.getValorPago() != null) {
            totalValor += m.getValorPago().doubleValue();
        }
    }
    return totalValor;
}
```

### Consulta SQL para Buscar Movimentações do Período

```java
// SQL para buscar movimentações com saídas registradas no período (para calcular faturamento)
String sql = "SELECT id, placa, tipo_veiculo, entrada, saida, valor_pago, forma_pagamento, observacoes " +
             "FROM veiculos_estacionados " +
             "WHERE saida IS NOT NULL AND saida BETWEEN ? AND ? " +
             "ORDER BY saida DESC";
```

### Filtros de Data na Interface do Usuário (relatorio.jsp)

```jsp
<!-- Formulário de Filtros -->
<div class="form-group mb-3">
    <label>Tipo de Relatório:</label>
    <div class="form-check">
        <input type="radio" class="form-check-input" id="tipoDiario" name="tipoFiltro" value="diario" ${tipoFiltro == 'diario' ? 'checked' : ''}>
        <label class="form-check-label" for="tipoDiario">Diário</label>
    </div>
    <div class="form-check">
        <input type="radio" class="form-check-input" id="tipoSemanal" name="tipoFiltro" value="semanal" ${tipoFiltro == 'semanal' ? 'checked' : ''}>
        <label class="form-check-label" for="tipoSemanal">Semanal</label>
    </div>
    <div class="form-check">
        <input type="radio" class="form-check-input" id="tipoMensal" name="tipoFiltro" value="mensal" ${tipoFiltro == 'mensal' ? 'checked' : ''}>
        <label class="form-check-label" for="tipoMensal">Mensal</label>
    </div>
</div>

<div class="form-group mb-3" id="divDiario" style="${tipoFiltro == 'diario' ? '' : 'display: none;'}">
    <label for="dataDiaria">Data:</label>
    <input type="date" class="form-control" id="dataDiaria" name="dataDiaria" value="${dataDiaria}">
</div>

<div class="form-group mb-3" id="divSemanal" style="${tipoFiltro == 'semanal' ? '' : 'display: none;'}">
    <label for="dataSemanal">Data Final:</label>
    <input type="date" class="form-control" id="dataSemanal" name="dataSemanal" value="${dataSemanal}">
</div>

<div class="form-group mb-3" id="divMensal" style="${tipoFiltro == 'mensal' ? '' : 'display: none;'}">
    <label for="dataMensal">Mês e Ano:</label>
    <input type="month" class="form-control" id="dataMensal" name="dataMensal" value="${dataMensal}">
</div>
```

### JavaScript para Alternar entre Tipos de Relatório

```javascript
// Script para mostrar/esconder os campos de data conforme o tipo de relatório
$(document).ready(function() {
    $('input[name="tipoFiltro"]').change(function() {
        const tipoSelecionado = $('input[name="tipoFiltro"]:checked').val();
        
        $('#divDiario, #divSemanal, #divMensal').hide();
        
        if (tipoSelecionado === 'diario') {
            $('#divDiario').show();
        } else if (tipoSelecionado === 'semanal') {
            $('#divSemanal').show();
        } else if (tipoSelecionado === 'mensal') {
            $('#divMensal').show();
        }
    });
});
```

---
© 2025 Sistema de Estacionamento RSM