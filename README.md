# Sistema de Gerenciamento de Estacionamento RSM

## Visão Geral

O Sistema de Gerenciamento de Estacionamento RSM é uma aplicação completa para controle de entrada e saída de veículos, cálculo de tarifas, emissão de comprovantes e gestão de usuários. Desenvolvido para otimizar a operação de estacionamentos comerciais com diferentes tipos de veículos e formas de pagamento.

## Tecnologias Utilizadas

### Backend
- **Java**: Linguagem de programação principal, escolhida pela sua robustez e portabilidade.
- **Jakarta EE**: Framework para desenvolvimento de aplicações corporativas.
- **JPA/Hibernate**: Framework ORM para persistência de dados, simplificando o acesso ao banco.
- **MySQL**: Sistema de gerenciamento de banco de dados relacional.
- **JSTL**: Tags para simplificar o desenvolvimento de páginas JSP.
- **HikariCP**: Pool de conexões de alto desempenho para o banco de dados.

### Frontend
- **HTML/CSS/JavaScript**: Tecnologias web padrão para interface do usuário.
- **JSP (JavaServer Pages)**: Para geração dinâmica de páginas HTML.
- **Font Awesome**: Biblioteca de ícones para melhorar a experiência visual.

### Ferramentas de Build e Gerenciamento
- **Maven**: Gerenciador de dependências e build do projeto.
- **Tomcat**: Servidor de aplicação para hospedagem do sistema.

## Estrutura do Banco de Dados

O sistema utiliza três tabelas principais:

1. **usuarios**: Armazena informações dos funcionários com diferentes níveis de acesso.
2. **veiculos_estacionados**: Registra entradas e saídas de veículos, valores pagos e formas de pagamento.
3. **configuracoes**: Mantém parâmetros configuráveis do sistema como valores por hora e número de vagas.

## Requisitos para Execução

- Java 11 ou superior
- MySQL 5.7 ou superior
- Apache Tomcat 10 ou superior
- Maven 3.6 ou superior (para compilação)
- Navegador web moderno (Chrome, Firefox, Edge)
- Mínimo de 4GB de RAM recomendado

## Guia de Instalação e Uso

### 1. Configuração do Banco de Dados

1. Instale o MySQL em seu sistema se ainda não estiver instalado
2. Execute o script `estacionamento_db.sql` localizado em `src/main/resources/sql/`
   ```
   mysql -u root -p < src/main/resources/sql/estacionamento_db.sql
   ```
3. Verifique se o banco de dados foi criado corretamente com as tabelas necessárias

### 2. Configuração da Aplicação

1. Verifique se as configurações no arquivo `persistence.xml` estão corretas:
   - URL do banco de dados
   - Nome de usuário (padrão: "root")
   - Senha (padrão: em branco)

2. Caso necessário, ajuste o arquivo `database.properties` com as credenciais corretas

### 3. Compilação e Implantação

#### Usando Maven
```
mvn clean package
```
O arquivo WAR será gerado na pasta `target/` e poderá ser implantado em um servidor Tomcat.

#### Usando uma IDE
Se estiver usando NetBeans, Eclipse ou IntelliJ IDEA, você pode implantar diretamente a partir da IDE:
- NetBeans: Clique com o botão direito no projeto > Executar
- Eclipse: Clique com o botão direito no projeto > Run As > Run on Server
- IntelliJ IDEA: Configurar uma execução do Tomcat e adicionar o artefato

### 4. Acessando o Sistema

1. Após a implantação, acesse a aplicação em: `http://localhost:8080/estacionamento-rsm/`
2. Você será redirecionado para a página de login
3. Use uma das credenciais padrão:
   - Administrador: mari@pupup.com / idontknow
   - Operador: gal@senai.com / password

### 5. Funcionalidades Principais

#### Registro de Entrada de Veículos
1. Clique em "Entrada" no menu principal
2. Preencha a placa do veículo
3. Selecione o tipo de veículo (carro, suv, pickup)
4. Adicione observações se necessário
5. Clique em "Registrar Entrada"

#### Registro de Saída e Pagamento
1. Clique em "Saída" no menu principal
2. Digite a placa do veículo e clique em "Buscar"
3. O sistema calculará automaticamente o valor com base no tempo de permanência
4. Selecione a forma de pagamento (dinheiro, cartão de débito, pix)
5. Clique em "Registrar Saída"

#### Dashboard
O dashboard apresenta informações gerais sobre o estacionamento:
- Número de vagas disponíveis e ocupadas
- Faturamento diário, semanal e mensal
- Veículos atualmente estacionados
- Últimas movimentações realizadas

#### Relatórios
1. Clique em "Relatórios" no menu principal
2. Selecione a data desejada
3. Visualize as movimentações e o faturamento do período

#### Administração do Sistema (apenas para administradores)
1. Clique em "Administração" no menu principal
2. Gerencie usuários: adicione, edite ou remova operadores e administradores
3. Configure valores de tarifas e número total de vagas

## Manutenção

- **Backup**: Realize backups periódicos do banco de dados usando phpMyAdmin ou o comando:
  ```
  mysqldump -u root -p estacionamento_db > backup_estacionamento.sql
  ```
- **Logs**: Os logs da aplicação são gerados no diretório de logs do Tomcat, verificar em caso de problemas
- **Atualização**: Para atualizar o sistema, substitua o arquivo WAR no servidor Tomcat

## Desenvolvimento Futuro

Funcionalidades planejadas para versões futuras:
- Integração com impressora térmica para comprovantes
- Aplicativo móvel para clientes
- Sistema de reserva de vagas
- Relatórios avançados com gráficos
- Integração com sistemas de pagamento eletrônico

## Equipe do Projeto
### Maria Clara - digaxiss
### Rafael Santana - Rafael-Santana08
### Rafael Souto (ME) - RafaelxSouto
---

© 2025 RSM Estacionamento - Todos os direitos reservados
