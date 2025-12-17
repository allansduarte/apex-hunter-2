# Apex Hunter - Arquitetura Técnica

## Visão Geral

O Apex Hunter utiliza uma arquitetura modular baseada em singletons (autoload) para gerenciar o estado global do jogo, com cenas independentes para diferentes áreas.

## Diagrama de Fluxo de Gameplay

```
┌─────────────────────────────────────────────────────────────┐
│                    INÍCIO DO JOGO                           │
│                    (Rank G, Level 1)                        │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                  ABA: COLETA                                │
│  ┌───────────────────────────────────────────────────────┐ │
│  │  Minerar Cobre (3s cada)                             │ │
│  │  → Cobre +1, Maestria +5                             │ │
│  │  → Ao atingir 5: MARCO 1 ✓                           │ │
│  └───────────────────────────────────────────────────────┘ │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                  ABA: CRIAÇÃO                               │
│  ┌───────────────────────────────────────────────────────┐ │
│  │  Picareta de Bronze (requer 10 Cobre)               │ │
│  │  → Ferramenta criada, Maestria +20                   │ │
│  │  → MARCO 2 ✓                                         │ │
│  └───────────────────────────────────────────────────────┘ │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                  ABA: COMBATE                               │
│  ┌───────────────────────────────────────────────────────┐ │
│  │  Goblin Batedor ou Brutamontes                       │ │
│  │  → Auto-combate a cada 1.5s                          │ │
│  │  → Loot: Moedas, XP, Itens                           │ │
│  │  → Ao vencer: MARCO 3 ✓                              │ │
│  └───────────────────────────────────────────────────────┘ │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              PROGRESSÃO: RANK G → G+                        │
│         (Desbloqueio de Loja e Dungeon)                    │
└────────────────────┬────────────────────────────────────────┘
                     │
           ┌─────────┴──────────┐
           ▼                    ▼
┌──────────────────┐   ┌──────────────────────┐
│   ABA: LOJA      │   │   DUNGEON: CAVERNA   │
│                  │   │   DOS GOBLINS        │
│ • Picareta de    │   │                      │
│   Cobre (300g)   │   │ • 3 Ondas + Boss     │
│ • QoL Items      │   │ • Rei Goblin         │
└──────────────────┘   │ • Loot Especial      │
                       └──────────────────────┘
```

## Arquitetura de Código

### Singletons (Autoload)

```
GameManager (game_manager.gd)
├── Player Stats (HP, XP, Level, Rank)
├── Inventory (Resources)
├── Tools (Owned items)
├── Progression (Milestones, Unlocks)
└── Signals (stats_updated, inventory_updated, etc.)

CombatManager (combat_manager.gd)
├── Combat State (active, enemy)
├── Auto-attack Logic
├── Loot Distribution
├── Combat Log
└── Signals (combat_started, enemy_defeated, etc.)
```

### Estrutura de Cenas

```
Main Scene (main.tscn + main.gd)
├── TopBar (HUD)
│   ├── HP Bar
│   ├── Stats Display
│   └── Progress Bars (XP, Mastery)
├── TabContainer
│   ├── Tab: Coleta
│   │   ├── Mine Button
│   │   ├── Progress Bar
│   │   └── Resource Counter
│   ├── Tab: Criação
│   │   └── Recipe List
│   │       └── Bronze Pickaxe
│   ├── Tab: Combate
│   │   ├── Enemy Info Panel
│   │   ├── Fight Buttons
│   │   ├── Dungeon Button
│   │   └── Combat Log
│   ├── Tab: Loja
│   │   └── Items List
│   │       └── Copper Pickaxe
│   └── Tab: Perfil
│       ├── Stats Display
│       └── Inventory Display

Goblin Cave Scene (goblin_cave.tscn + goblin_cave.gd)
├── Enemy Info Panel
├── Combat Log
├── Start/Return Buttons
└── Rewards Panel
```

## Fluxo de Dados

### Sistema de Coleta
```
User Click "Mine Button"
    ↓
Start Mining Timer (3s)
    ↓
Complete Mining
    ↓
GameManager.add_resource("copper", 1)
    ↓
GameManager.inventory_updated.emit()
    ↓
Update UI (Resource Counter)
    ↓
Check Milestones
```

### Sistema de Combate
```
User Click "Fight Enemy"
    ↓
CombatManager.start_combat(enemy)
    ↓
Auto-attack Loop (every 1.5s)
    ├── Player Attack
    │   ├── Calculate Damage
    │   ├── Check Evasion
    │   └── Apply Damage
    ├── Check Enemy HP
    │   └── If dead: Defeat Enemy
    └── Enemy Attack
        ├── Calculate Damage
        └── Apply to Player HP
            ↓
Enemy Defeated
    ↓
Calculate Loot
    ├── GameManager.add_coins()
    ├── GameManager.add_resource()
    └── GameManager.add_xp()
        ↓
CombatManager.combat_ended.emit()
    ↓
Update UI
```

### Sistema de Progressão
```
Complete Milestone
    ↓
GameManager.complete_milestone()
    ↓
Check Milestone Count
    ↓
If milestones >= 3
    ↓
Rank Up: G → G+
    ↓
Unlock Features
    ├── shop_unlocked = true
    └── dungeon_unlocked = true
        ↓
GameManager.rank_updated.emit()
    ↓
Update UI (Show Loja, Show Dungeon)
```

## Classes e Recursos

### Enemy (enemy.gd)
```gdscript
class_name Enemy extends Resource

Properties:
- enemy_name: String
- max_hp, current_hp: int
- attack, defense, evasion: int
- coin_drop_min, coin_drop_max: int
- item_drops: Dictionary

Methods:
- take_damage(amount: int) -> int
- is_alive() -> bool
- get_loot() -> Dictionary

Static Constructors:
- create_goblin_scout() -> Enemy
- create_goblin_brute() -> Enemy
- create_goblin_king() -> Enemy
```

## Sistema de Sinais

### GameManager Signals
- `stats_updated` → Atualiza UI de estatísticas
- `inventory_updated` → Atualiza displays de inventário
- `rank_updated` → Notifica mudança de rank
- `milestone_completed` → Notifica conclusão de marco

### CombatManager Signals
- `combat_started` → Inicia UI de combate
- `combat_ended` → Finaliza combate, limpa estado
- `enemy_defeated` → Processa loot e XP
- `combat_log_updated` → Atualiza texto do log
- `player_attacked` → Feedback visual (futuro)
- `enemy_attacked` → Feedback visual (futuro)

## Padrões de Design Utilizados

1. **Singleton Pattern**: GameManager e CombatManager
2. **Observer Pattern**: Sistema de sinais do Godot
3. **State Pattern**: Gerenciamento de estados de combate e mineração
4. **Factory Pattern**: Criação de inimigos (static constructors)

## Considerações de Performance

- **Timers**: Usados para mineração e combate automático
- **Signals**: Evita polling, usa event-driven architecture
- **Scene Changes**: Dungeon é cena separada para modularidade
- **No Polling**: Todo sistema baseado em eventos e timers

## Extensibilidade

### Para adicionar novos recursos:

1. **Novo Recurso de Coleta**:
   - Adicionar ao `GameManager.inventory`
   - Criar nova área na aba Coleta
   - Conectar botão ao método de coleta

2. **Novo Inimigo**:
   - Criar static constructor em `enemy.gd`
   - Adicionar botão na aba Combate
   - Conectar ao `_on_fight_X_pressed`

3. **Nova Receita**:
   - Adicionar panel na aba Criação
   - Implementar lógica de verificação
   - Conectar botão ao método de craft

4. **Nova Dungeon**:
   - Criar nova cena `.tscn` e script `.gd`
   - Adicionar à aba Combate
   - Usar mesmo CombatManager

## Dependências

- **Godot Engine**: 4.5+
- **Linguagem**: GDScript
- **Recursos Externos**: Nenhum (apenas placeholders internos)

---

Esta arquitetura permite fácil expansão e manutenção, com separação clara de responsabilidades e comunicação via sinais.
