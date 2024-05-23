*** Settings ***
Resource    ../resources/api_server_usuarios.resource

*** Variables ***


*** Test Cases ***
Cenário 01: Cadastrar um novo usuário na Serve
    Criar um novo usuário
    Cadastrar o usuário criado
    Conferir se o usuário foi criado corretamente