# Estrutura recomendada - Flutter com MVVM

## O que é um padrão de projeto?

Um padrão de projeto (design pattern) é uma solução reutilizável para um problema comum no desenvolvimento de software. Ele ajuda a organizar o código, tornando-o mais limpo, modular, fácil de manter e escalar. Um bom padrão de projeto melhora a separação de responsabilidades, o que facilita a leitura e os testes do sistema.

## MVVM (Model-View-ViewModel)

O MVVM é um padrão de projeto bastante usado em aplicações Flutter. Ele separa o código em três partes principais:

- **Model:** Responsável pelos dados da aplicação, como classes e lógica de negócio.
- **View:** A interface do usuário (widgets). Não contém lógica de negócio.
- **ViewModel:** Faz a ponte entre Model e View. Contém a lógica que manipula os dados e notifica a interface sobre alterações (geralmente usando `ChangeNotifier`, `ValueNotifier` ou outros gerenciadores de estado).

## Por que usar MVVM no Flutter?

O Flutter é um framework declarativo e reativo, e o MVVM se encaixa bem nesse estilo de desenvolvimento. Ele facilita a separação entre lógica de interface e lógica de negócio, promovendo reutilização de código, organização e testabilidade.

## Estrutura de pastas recomendada:

```
lib/
├── models/           <- Modelos de dados
├── views/            <- Telas (UI widgets)
│   └── home_view.dart
├── viewmodels/       <- Lógica de cada tela
│   └── home_viewmodel.dart
├── services/         <- Classes que acessam dados ou APIs
├── utils/            <- Funções auxiliares, constantes, temas
├── main.dart         <- Entrada da aplicação
```

## Como seguir esse padrão?

1. Crie os arquivos separando as responsabilidades:
   - Models: classes de dados.
   - Views: arquivos com os widgets da interface.
   - ViewModels: classes que usam `ChangeNotifier` para controlar o estado.
2. Use `Provider` ou outro gerenciador de estado para conectar as Views aos seus respectivos ViewModels.
3. Mantenha as Views sem lógica de negócio, focadas apenas na apresentação dos dados.
4. Organize cada funcionalidade em seu próprio View e ViewModel.

Com essa abordagem, seu app se mantém organizado e preparado para crescer com qualidade.
