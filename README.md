---
# Projeto TODO List em Flutter
## Objetivo:
Criar uma aplicação simples de lista de tarefas (TODO List) usando Flutter. O foco é aprender a gerenciar estado com `setState` e criar interfaces dinâmicas.
## Funcionalidades principais:
1. **Adicionar tarefas**: O usuário pode digitar o nome de uma tarefa e adicioná-la à lista.
2. **Marcar tarefa como concluída**: O usuário pode marcar uma tarefa como concluída ao clicar em um botão de checkbox.
3. **Remover tarefas**: O usuário pode remover tarefas da lista.
4. **Exibir tarefas concluídas e não concluídas separadamente**: A lista deve mostrar as tarefas que já foram concluídas em uma seção e as não concluídas em outra.
## Requisitos técnicos:
1. **Gerenciamento de estado com setState**: Toda a manipulação da lista de tarefas deve ser feita utilizando o método `setState` para atualizar a interface.
2. **Persistência temporária na memória**: Não é necessário salvar os dados em um banco de dados. O foco é apenas no gerenciamento de estado enquanto a aplicação está aberta.
3. **Design simples e funcional**: Não é preciso focar em design avançado, mas a interface deve ser clara e fácil de usar.
## Estrutura recomendada:
- **Tela Principal**:
  - Um campo de texto (TextField) para digitar novas tarefas.
  - Um botão de adição para incluir a tarefa à lista.
  - Uma lista separada para tarefas **não concluídas** e outra para **concluídas**.
- **Item de Tarefa**:
  - Um texto que exibe o nome da tarefa.
  - Um ícone de checkbox que permite ao usuário marcar ou desmarcar a tarefa como concluída.
  - Um ícone de lixeira que permite remover a tarefa da lista.
## Passos de desenvolvimento:
1. **Criar a estrutura básica do projeto Flutter**.
2. **Definir a classe de modelo de tarefa**:
   - A classe deve conter o nome da tarefa e um booleano para indicar se ela está concluída ou não.
3. **Desenhar a UI principal**:
   - Campo de texto, botões, e listas.
4. **Implementar o gerenciamento de estado com `setState`**:
   - Atualizar a lista quando o usuário adicionar, remover ou concluir uma tarefa.
## Desafios bônus:
1. **Validação do campo de texto**: Não permitir adicionar tarefas vazias.
2. **Animações**: Implementar animações simples ao adicionar ou remover tarefas.
3. **Reordenação da lista**: Permitir que o usuário reordene as tarefas.
---
