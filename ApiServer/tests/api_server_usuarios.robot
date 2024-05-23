*** Settings ***
Resource    ../resources/api_server_usuarios.resource

*** Variables ***


*** Test Cases ***
#Cenário de testes do endpoint Usuário
Cenário 01: Cadastrar um novo usuário na ServeRest
    Criar um novo usuário
    Cadastrar o usuário criado na ServeRest  email=${EMAIL_TESTE}  status_code_desejado=201
    Conferir se o usuário foi criado corretamente

#Verificando se a API não permitiu o cadastro Repetindo
Cenário 02: Cadastrar um usuário já existente
    Criar um novo usuário
    Cadastrar o usuário criado na ServeRest  email=${EMAIL_TESTE}  status_code_desejado=201
    Repetindo o Cadastro do usuário
    Verificar se a API não permitiu cadastro repetido
    
Cenário 03: Consultar os dados de um novo usuário
        Criar um novo usuário
        Cadastrar o usuário criado na ServeRest  email=${EMAIL_TESTE}  status_code_desejado=201
        Consultar os dados do novo usuário
        Conferir os dados retornados