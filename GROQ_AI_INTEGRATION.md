# Integração com Groq AI

## Funcionalidade Implementada

A página AddTask agora possui integração real com a API do Groq AI para melhorar automaticamente as tarefas inseridas pelo usuário.

## Como Funciona

1. **Digite uma tarefa**: O usuário pode inserir um título e/ou descrição básica da tarefa
2. **Clique no botão IA**: O botão "Recomendar com IA" enviará o conteúdo atual dos campos para a API do Groq
3. **Aguarde o processamento**: A IA processará a informação e retornará uma versão melhorada
4. **Use a sugestão**: O usuário pode aceitar a recomendação clicando em "Aceitar Recomendação"

## Detalhes Técnicos

### API Utilizada

- **Serviço**: Groq AI
- **Modelo**: llama3-8b-8192
- **Endpoint**: https://api.groq.com/openai/v1/chat/completions

### Fluxo da Requisição

1. O texto dos campos título e descrição é enviado para a IA
2. A IA retorna um JSON com título e descrição melhorados
3. O resultado é exibido na interface para aprovação do usuário

### Tratamento de Erros

- Verificação de conectividade
- Fallback em caso de falha na API
- Mensagens de erro para o usuário
- Verificação de contexto válido antes de mostrar notificações

### Segurança

- Chave de API configurada diretamente no código (para desenvolvimento)
- **Nota**: Em produção, mova a chave para variáveis de ambiente

## Formato da Resposta da IA

A IA retorna um JSON no formato:

```json
{
  "title": "título melhorado da tarefa",
  "description": "descrição detalhada e melhorada da tarefa"
}
```

## Exemplo de Uso

**Entrada do usuário:**

- Título: "estudar"
- Descrição: "preciso estudar mais"

**Resposta da IA:**

- Título: "Criar cronograma de estudos estruturado"
- Descrição: "Definir horários específicos para estudo, escolher matérias prioritárias e estabelecer metas semanais de aprendizado com pausas regulares"
