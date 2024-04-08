# Descrição do Projeto
Esta é uma API desenvolvida em Flask para autenticação de usuários e obtenção de medições de chuva de dispositivos específicos. A API utiliza autenticação via token JWT e se comunica com dispositivos externos usando Telnet para obter as medições de intensidade de chuva.

# Decisões de Design e Implementação
Flask e JWT: Decidiu-se utilizar o framework Flask devido à sua simplicidade e flexibilidade para a criação de APIs web em Python. Para autenticação, optou-se por usar tokens JWT (JSON Web Tokens) devido à sua capacidade de autenticar e autorizar usuários de forma segura e eficiente.

Comunicação com Dispositivos Externos: A comunicação com os dispositivos externos é realizada usando Telnet. Esta decisão foi tomada com base na necessidade de se comunicar com dispositivos que suportam esse protocolo para obter medições de chuva.

Filtragem de Dispositivos e Medições: Ao obter a lista de dispositivos, a API filtra apenas aqueles que são do fabricante "PredictWeather" e possuem o comando "get_rainfall_intensity". Isso garante que apenas os dispositivos relevantes sejam utilizados para a obtenção das medições.

# Como Usar
Instalação: Clone o repositório e instale as dependências usando pip install -r requirements.txt.

Configuração: Defina a chave secreta para geração dos tokens JWT no arquivo app.py (app.config['SECRET_KEY'] = 'sua_chave_secreta').

Execução: Execute a aplicação Flask com python app.py. A aplicação será executada localmente em http://localhost:5000 por padrão.

Autenticação: Envie uma solicitação POST para /login com um corpo contendo o nome de usuário e senha para obter um token JWT.

Obtenção de Medições de Chuva: Use o token JWT obtido para fazer solicitações GET para /medicoes_chuva e obter as medições de chuva dos dispositivos filtrados.

Sugestões de Melhorias e Avanços Futuros
Melhor Gerenciamento de Erros: Implementar um melhor tratamento de erros e mensagens de retorno mais descritivas para diferentes cenários de falha.

Implementação de Testes: Criar testes automatizados para garantir o funcionamento correto da API em diferentes cenários e facilitar a manutenção e evolução do código.

Suporte a Mais Comandos e Dispositivos: Expandir a API para oferecer suporte a mais comandos e dispositivos, permitindo uma maior variedade de medições e integrações.

Segurança Aprimorada: Implementar medidas adicionais de segurança, como criptografia de dados e proteção contra ataques de negação de serviço (DDoS), para garantir a integridade e confidencialidade das informações.

# Conclusão
Esta API oferece uma maneira simples e eficiente de autenticar usuários e obter medições de chuva de dispositivos específicos. Com as melhorias sugeridas e o suporte contínuo, pode-se tornar uma ferramenta poderosa para monitoramento e análise de dados meteorológicos.
