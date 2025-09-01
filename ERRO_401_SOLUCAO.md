# Resolução do Erro 401 na API Groq

## Problema

Você está recebendo erro 401 (Unauthorized) ao tentar usar a API do Groq.

## Possíveis Causas

1. **Chave da API expirada ou inválida**
2. **Chave da API sem permissões adequadas**
3. **Limite de créditos excedido**

## Soluções

### 1. Gerar Nova Chave da API

1. Acesse: https://console.groq.com/keys
2. Faça login na sua conta
3. Clique em "Create API Key"
4. Copie a nova chave

### 2. Atualizar a Chave no Código

Substitua a chave atual no arquivo `lib/pages/addTask_page.dart`:

```dart
const String apiKey = 'SUA_NOVA_CHAVE_AQUI';
```

### 3. Verificar Créditos

- Acesse seu dashboard no Groq Console
- Verifique se há créditos disponíveis
- Se necessário, adicione mais créditos à sua conta

### 4. Comportamento em Caso de Falha

O app agora mostra uma mensagem simples quando a API não está funcionando:

- Se a API retornar erro 401 ou qualquer outro erro
- Uma mensagem vermelha aparecerá: "Função de IA não disponível no momento. Tente novamente mais tarde."
- O usuário pode continuar adicionando tarefas manualmente

## Teste

Para testar se funciona:

1. Digite algum texto nos campos título/descrição
2. Clique em "Recomendar com IA"
3. Se aparecer mensagem vermelha = API não funcionando
4. Se aparecer recomendação da IA = API funcionando

## Debug

O app agora mostra logs detalhados no console:

- Status code da resposta
- Conteúdo da resposta em caso de erro
- Logs da requisição

Para ver os logs, execute o app no terminal e verifique as mensagens de print().
