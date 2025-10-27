# 📅 Diário de Desenvolvimento - 27 de Outubro de 2025

## 🎯 **Objetivo Principal**

Aprimorar a experiência do usuário na visualização e interação com as tarefas, detalhar o sistema de níveis, documentar tecnologias utilizadas e garantir clareza para o TCC.

---

## 📋 **Resumo Executivo**

### ✅ **O que foi alcançado hoje:**

- ✅ Ajuste do **botão Diário** para exibir apenas as tarefas completadas, seguindo o design do Figma
- ✅ Inclusão do **ícone de tubo** para indicar tarefas derrotadas/concluídas
- ✅ Implementação da função de **remover o blur** ao segurar fora dos botões na Home, revelando o guerreiro lutando contra o Slime
- ✅ Limitação de **100 caracteres** para descrição dos cards de tarefa, evitando cortes indesejados
- ✅ Aumento da **fonte** das descrições para melhor visualização
- ✅ Criação e detalhamento do **sistema de níveis**: cada nível possui quantidade específica de tarefas e requisitos, com lore e progressão
- ✅ Documentação das **tecnologias utilizadas** e decisões técnicas

### 📊 **Métricas de Sucesso:**

- Visualização clara das tarefas completadas no Diário
- Feedback visual aprimorado com ícone de tubo
- Experiência imersiva ao revelar batalha do guerreiro
- Legibilidade das descrições dos cards
- Sistema de níveis detalhado e pronto para uso acadêmico
- Registro das tecnologias e arquitetura

---

## 🚀 **Fases do Desenvolvimento**

### 🗂️ Fase 1: Ajuste do Botão Diário

- Botão exibe apenas tarefas completadas, filtrando pelo atributo `isCompleted` do modelo `Task` (Hive)
- Ícone de tubo adicionado conforme design do Figma, usando assets customizados
- Cards mostram apenas tarefas "derrotadas", reforçando a gamificação

### 🖼️ Fase 2: Interação na Home

- Implementação do evento de segurar fora dos botões usando `GestureDetector` para remover o blur
- Ao remover o blur, o usuário visualiza o guerreiro (sprite customizado) lutando contra o Slime
- Experiência gamificada reforçada, aproximando do design do Figma

### 📝 Fase 3: Cards de Tarefa

- Descrição limitada a 100 caracteres via função utilitária (`_truncateText`)
- Fonte aumentada para melhor leitura, usando `TextStyle` customizado
- Cards ajustados para evitar cortes visuais e garantir responsividade

### 🏆 Fase 4: Sistema de Níveis

O sistema de níveis foi detalhado para criar uma progressão clara e motivadora. Cada nível possui nome, lore (história), quantidade de tarefas para avançar e feedback visual.

#### Estrutura dos Níveis:

| Nível | Nome              | Lore                                                     | Tarefas para avançar |
| ----- | ----------------- | -------------------------------------------------------- | -------------------- |
| 1     | Wanderer          | Viajante que inicia a jornada.                           | 5                    |
| 2     | Squire            | Aprendiz que começa a aprender o caminho do cavaleiro.   | 10                   |
| 3     | Justice Seeker    | Começa a lutar contra maus hábitos e tarefas inacabadas. | 15                   |
| 4     | Task Slayer       | Corta a procrastinação com precisão.                     | 20                   |
| 5     | Knight of Order   | Mantém disciplina diária e defende a consistência.       | 25                   |
| 6     | Champion of Focus | Domina o tempo e derrota distrações.                     | 30                   |

Cada tarefa concluída incrementa o progresso do usuário. Ao atingir o número necessário, o usuário sobe de nível, recebendo feedback visual e textual.

#### Tecnologias Utilizadas:

- **Flutter**: Framework principal para desenvolvimento multiplataforma (Android, iOS, macOS, Windows, Linux, Web)
- **Hive**: Banco de dados local para persistência das tarefas e progresso do usuário
- **flutter_local_notifications**: Notificações push locais para engajamento
- **Custom Assets**: Ícones, sprites e imagens criados no Figma e exportados para o projeto
- **window_manager**: Gerenciamento de janelas para desktop
- **Arquitetura Modular**: Separação em controllers, models, services e widgets para facilitar manutenção

#### Decisões Técnicas:

- Utilização de `Hive` para garantir performance e persistência offline
- Cards de tarefa usam truncamento inteligente para evitar cortes abruptos
- Sistema de níveis implementado como lista de mapas, facilitando expansão futura
- Interações visuais e gamificadas inspiradas diretamente no Figma

---

## 📚 **Próximos Passos**

- Refinar animações de batalha (sprites e transições)
- Testar responsividade dos cards em diferentes dispositivos
- Integrar feedback do usuário para ajustes finais
- Documentar o sistema de níveis com exemplos visuais para o TCC

---

## 📝 **Observações Gerais**

- Todas as alterações seguiram o design do Figma
- Foco em UX, clareza visual e gamificação
- Sistema de níveis pronto para documentação acadêmica
- Tecnologias e decisões técnicas registradas para facilitar apresentação no TCC

## 📚 **Próximos Passos**

- Refinar animações de batalha
- Testar responsividade dos cards
- Integrar feedback do usuário para ajustes finais

---

## 📝 **Observações Gerais**

- Todas as alterações seguiram o design do Figma
- Foco em UX e clareza visual
- Sistema de níveis pronto para documentação acadêmica
