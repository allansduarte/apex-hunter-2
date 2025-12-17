# Apex Hunter - Protótipo Funcional
## Guia do Jogo

### Como Executar
1. Abra o projeto no Godot Engine 4.5 (ou superior)
2. Clique em "Run Project" (F5) ou selecione a cena `scenes/main.tscn`
3. O jogo iniciará na tela principal com todas as abas disponíveis

### Estrutura do Jogo

#### Sistema de Progressão
- **Rank Inicial**: G
- **Rank Desbloqueável**: G+ (ao completar 3 marcos)
- **Marcos para Progressão**:
  1. Coletar 5 de Cobre
  2. Criar a Picareta de Bronze
  3. Vencer o primeiro combate

#### Abas Principais

##### 1. Coleta (Colinas de Cobre)
- **Ação**: Minerar Cobre
- **Tempo**: 3 segundos por mineração
- **Recurso Obtido**: 1x Cobre por mineração
- **Progresso**: Barra de progresso visual durante a mineração
- **Maestria**: +5 por mineração

##### 2. Criação (Ferraria)
- **Receita Disponível**: Picareta de Bronze
  - **Requisitos**: 10x Cobre
  - **Benefício**: Ferramenta aprimorada
  - **Maestria**: +20 por criação
  - **Status**: Botão fica marcado como "Criado ✓" após criação

##### 3. Combate (Campos dos Goblins)
- **Sistema**: Auto-combate
- **Inimigos Disponíveis**:
  1. **Goblin Batedor**
     - HP: 30
     - Ataque: 8
     - Defesa: 2
     - Evasão: 15%
     - Loot: 5-12 moedas, Carne de Rato (30%), Estanho (20%)
  
  2. **Goblin Brutamontes**
     - HP: 80
     - Ataque: 12
     - Defesa: 10
     - Evasão: 5%
     - Loot: 10-25 moedas, Cobre (40%), Estanho (30%)

- **Mecânica de Combate**:
  - Ataques automáticos a cada 1.5 segundos
  - Log de combate mostra todas as ações
  - XP concedido ao derrotar inimigos
  - HP do jogador regenera após cada combate

- **Dungeons** (Desbloqueada no Rank G+):
  - **Caverna dos Goblins**
    - 3 ondas de inimigos + 1 Boss
    - Sequência: Goblin Batedor → Goblin Brutamontes → Goblin Batedor → Rei Goblin
    - **Rei Goblin** (Boss):
      - HP: 150
      - Ataque: 20
      - Defesa: 15
      - Evasão: 10%
      - Loot Especial: 50-100 moedas, Cobre (100%), Estanho (80%), Bronze (30%)
    - Recompensas Extras da Dungeon: +100 moedas, +2 Bronze, +100 XP

##### 4. Loja
- **Desbloqueio**: Rank G+
- **Item Disponível**: 
  - **Picareta de Cobre**
    - Preço: 300 Moedas
    - Benefício: Ferramenta básica para mineração
    - Status: Botão fica marcado como "Comprado ✓" após compra

##### 5. Perfil
- **Estatísticas do Jogador**:
  - Nível atual
  - Rank atual (G ou G+)
  - Reputação
  - Moedas
- **Inventário**:
  - Cobre
  - Estanho
  - Bronze
  - Carne de Rato

### Sistema de Interface (HUD)

#### Barra Superior
- **Esquerda**: HP (com barra de progresso)
- **Centro**: Nível, Rank, Reputação, Moedas
- **Direita**: 
  - Barra de XP (progresso para próximo nível)
  - Barra de Maestria (progresso de habilidades)

### Fórmulas do Jogo

#### Sistema de XP
- **XP por Inimigo**: 20 + (HP_máximo_inimigo / 2)
- **XP para Próximo Nível**: Base_XP * 1.5 (multiplicador por nível)
- **Base XP**: 100 XP

#### Sistema de Combate
- **Dano Base do Jogador**: 10 + (Nível * 2)
- **Dano Efetivo**: max(1, Dano_Base - Defesa_Inimigo)
- **Chance de Evasão**: Baseada no atributo Evasão do inimigo

#### Ganho de HP por Nível
- +10 HP máximo por level up
- HP restaurado para o máximo ao subir de nível

### Fluxo de Gameplay Inicial ("O Despertar")

1. **Início**: Jogador começa no Rank G
2. **Coleta**: Minere 5 Cobre (15 segundos total)
3. **Marco 1**: Desbloqueado ao coletar 5 Cobre
4. **Criação**: Use 10 Cobre para criar Picareta de Bronze
5. **Marco 2**: Desbloqueado ao criar primeira ferramenta
6. **Combate**: Derrote um Goblin Batedor ou Brutamontes
7. **Marco 3**: Desbloqueado ao vencer primeiro combate
8. **Progressão**: Rank sobe para G+
9. **Desbloqueios**: Loja e Dungeon ficam disponíveis
10. **Exploração**: Acesso à Caverna dos Goblins e compra de itens

### Arquitetura Técnica

#### Scripts Principais
- `game_manager.gd`: Gerencia estado global do jogo (singleton)
- `combat_manager.gd`: Controla lógica de combate automático
- `enemy.gd`: Define classe Enemy e inimigos predefinidos
- `main.gd`: Controla a UI principal e interações
- `goblin_cave.gd`: Gerencia a dungeon da Caverna dos Goblins

#### Cenas
- `main.tscn`: Cena principal com HUD e todas as abas
- `goblin_cave.tscn`: Cena da dungeon com combate sequencial

#### Sistema de Sinais (Signals)
- `stats_updated`: Atualiza UI quando estatísticas mudam
- `inventory_updated`: Atualiza UI quando inventário muda
- `rank_updated`: Notifica mudança de rank
- `milestone_completed`: Notifica conclusão de marco
- `combat_started`: Início de combate
- `combat_ended`: Fim de combate
- `enemy_defeated`: Inimigo derrotado

### Próximos Passos para Expansão

1. **Áreas Adicionais**: Novas regiões de coleta e combate
2. **Mais Receitas**: Expandir sistema de crafting
3. **Sistema de Equipamentos**: Equipar ferramentas e armas
4. **Melhorias Visuais**: Substituir placeholders por sprites reais
5. **Sistema de Conquistas**: Adicionar achievements
6. **Mais Dungeons**: Criar novos desafios
7. **Sistema de Quests**: Missões e objetivos
8. **Multiplayer/Social**: Recursos sociais e competição

### Notas de Desenvolvimento

- Todos os elementos visuais são placeholders (cores sólidas e formas geométricas)
- O sistema é modular para fácil expansão
- Todas as mecânicas principais do GDD estão implementadas em forma básica
- O código está comentado e organizado para facilitar manutenção
- Sistema de notificações básico (console) pode ser expandido para UI toasts

### Feedback e Iteração

Para reportar bugs ou sugerir melhorias, favor incluir:
- Descrição do problema/sugestão
- Passos para reproduzir (se bug)
- Rank e nível atual do jogador
- Recursos no inventário

---

**Versão**: 1.0 (Protótipo Funcional)
**Engine**: Godot 4.5
**Data**: Dezembro 2024
