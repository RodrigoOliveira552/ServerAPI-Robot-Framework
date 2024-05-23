*** Settings ***
Library    RequestsLibrary
Library     String
Library    Collections

*** Keywords ***
Criar um novo usuário
    ${palavra_aleatoria}  Generate Random String  length=4  chars=[LETTERS]
    Set Test Variable    ${EMAIL_TESTE}  ${palavra_aleatoria}@qa.com.br
    Log  ${EMAIL_TESTE}

Cadastrar o usuário criado na ServeRest
    [Arguments]  ${email}  ${status_code_desejado}
    ${body}  Create Dictionary 
    ...  nome=Fulano da Silva  
    ...  email=${email}
    ...  password=1234
    ...  administrador=true
    Log  ${body}

    Criar Sessão na ServeRest

    ${resposta}  POST On Session  
    ...  alias=ServeRest
    ...  url=/usuarios
    ...  json=${body}
    ...  expected_status=${status_code_desejado}
 
    Log  ${resposta.json()}
    
    IF    ${resposta.status_code} == 201
        Set Test Variable    ${ID_USUARIO}  ${resposta.json()["_id"]}
    END

    Set Test Variable    ${RESPOSTA}  ${resposta.json()}
  
Criar Sessão na ServeRest
    ${headers}  Create Dictionary  accept=application/json  Content-Type=application/json
    Create Session    alias=ServeRest    url=https://serverest.dev  headers=${headers}

 Conferir se o usuário foi criado corretamente
     Log    ${RESPOSTA}
     Dictionary Should Contain Item    ${RESPOSTA}    message    Cadastro realizado com sucesso
     Dictionary Should Contain Key    ${RESPOSTA}    _id

Repetindo o Cadastro do usuário
     Cadastrar o usuário criado na ServeRest  email=${EMAIL_TESTE}  status_code_desejado=400

Verificar se a API não permitiu cadastro repetido
    Dictionary Should Contain Item    ${RESPOSTA}    message    Este email já está sendo usado

Consultar os dados do novo usuário
    ${resposta_consulta}  GET On Session  alias=ServeRest  url=/usuarios/${ID_USUARIO}
    Set Test Variable    ${RESP_CONSULTA}    ${resposta_consulta.json()}

Conferir os dados retornados
    Log  ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA}    nome  Fulano da Silva
    Dictionary Should Contain Item    ${RESPOSTA}    email    ${EMAIL_TESTE}
    Dictionary Should Contain Item    ${RESPOSTA}    password    1234
    Dictionary Should Contain Item    ${RESPOSTA}    administrador  true
    Dictionary Should Contain Item    ${RESPOSTA}   _id   ${ID_USUARIO}