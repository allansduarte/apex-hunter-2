# Apex Hunter - Quick Reference Card

## 🎮 Para Jogadores

### Progressão Inicial (5 minutos)
1. **Minerar** → Colinas de Cobre (3s cada)
2. **Coletar 5 Cobre** → Marco 1 ✓
3. **Criar Picareta** → 10 Cobre na aba Criação → Marco 2 ✓
4. **Combater** → Goblin Batedor na aba Combate → Marco 3 ✓
5. **Rank G+** → Loja e Dungeon desbloqueados!

### Atalhos Úteis
- **F5**: Executar jogo no Godot
- **F6**: Executar cena atual
- **Ctrl+S**: Salvar no Godot Editor

## 👨‍💻 Para Desenvolvedores

### Estrutura de Arquivos Chave
```
scripts/
├── game_manager.gd      # Estado global, inventário, stats
├── combat_manager.gd    # Lógica de combate
├── enemy.gd            # Classe Enemy + factories
├── main.gd             # Controller da UI principal
└── goblin_cave.gd      # Controller da dungeon

scenes/
├── main.tscn           # UI principal com tabs
└── dungeon/
    └── goblin_cave.tscn # Dungeon scene
```

### Singletons (Acesso Global)
```gdscript
GameManager.player_hp              # HP do jogador
GameManager.player_coins           # Moedas
GameManager.inventory["copper"]   # Recursos
GameManager.add_xp(100)           # Adicionar XP
GameManager.add_resource("copper", 5)

CombatManager.start_combat(enemy)  # Iniciar combate
CombatManager.is_combat_active    # Estado do combate
```

### Criar Novo Inimigo
```gdscript
# Em enemy.gd, adicionar:
static func create_my_enemy() -> Enemy:
    var enemy = Enemy.new("Nome", HP, ATK, DEF, EVA)
    enemy.coin_drop_min = 10
    enemy.coin_drop_max = 20
    enemy.item_drops = {
        "item_name": 0.5  # 50% chance
    }
    return enemy
```

### Adicionar Nova Aba
1. Criar tab no `main.tscn`
2. Adicionar `@onready var` em `main.gd`
3. Conectar sinais no `_ready()`
4. Implementar `update_X_ui()` method

### Sinais Importantes
```gdscript
# GameManager
GameManager.stats_updated.connect(callback)
GameManager.inventory_updated.connect(callback)
GameManager.rank_updated.connect(callback)

# CombatManager
CombatManager.combat_started.connect(callback)
CombatManager.enemy_defeated.connect(callback)
CombatManager.combat_ended.connect(callback)
```

## 📊 Fórmulas Rápidas

### Dano
```gdscript
player_damage = 10 + (level * 2)
actual_damage = max(1, player_damage - enemy.defense)
```

### XP
```gdscript
xp_gained = 20 + (enemy.max_hp / 2)
xp_next_level = base_xp * (1.5 ^ level)
```

### Loot
```gdscript
coins = randi_range(enemy.coin_drop_min, enemy.coin_drop_max)
# Items: randf() < drop_chance
```

## 🔧 Tarefas Comuns

### Adicionar Novo Recurso
```gdscript
# 1. Em game_manager.gd, inventory:
var inventory: Dictionary = {
    "copper": 0,
    "new_resource": 0  # <- Adicionar aqui
}

# 2. No profile tab (main.tscn):
# Adicionar Label para mostrar recurso

# 3. Em main.gd, update_profile_ui():
new_resource_label.text = "Nome: %d" % GameManager.inventory["new_resource"]
```

### Adicionar Nova Receita
```gdscript
# 1. Em main.tscn, tab Criação:
# Duplicar panel BronzePickaxe, renomear nodes

# 2. Em main.gd:
# Adicionar @onready var para botão
# Conectar button.pressed ao método
# Implementar _on_craft_X_pressed():
if GameManager.has_resource("material", 10):
    GameManager.remove_resource("material", 10)
    GameManager.own_tool("new_tool")
    # etc...
```

### Balancear Inimigo
```
Fraco:   HP < 50,  ATK < 10, DEF < 5,  EVA < 20%
Médio:   HP 50-100, ATK 10-15, DEF 5-10, EVA 10-15%
Forte:   HP > 100, ATK > 15, DEF > 10, EVA < 10%
Boss:    HP > 150, ATK > 20, DEF > 15, EVA variável
```

## 🐛 Debug

### Verificar Estado
```gdscript
# Adicionar em _process() ou _ready():
print("HP: ", GameManager.player_hp)
print("Inventory: ", GameManager.inventory)
print("Combat Active: ", CombatManager.is_combat_active)
```

### Testar Progressão Rápida
```gdscript
# Em _ready() do main.gd, temporariamente:
func _ready():
    # ... código existente ...
    
    # TESTE: Progressão rápida
    GameManager.add_resource("copper", 100)
    GameManager.add_coins(1000)
    GameManager.player_level = 5
    GameManager.player_rank = "G+"
    GameManager.shop_unlocked = true
    GameManager.dungeon_unlocked = true
```

## 📝 Checklist de PR

Antes de submeter mudanças:
- [ ] Código compila sem erros
- [ ] Sinais conectados corretamente
- [ ] UI atualiza quando estado muda
- [ ] Notificações funcionam
- [ ] Documentação atualizada (se necessário)
- [ ] Testado manualmente
- [ ] Não quebra funcionalidades existentes

## 🎨 Padrões de Código

### Nomenclatura
- **Variáveis**: snake_case (`player_hp`, `mining_timer`)
- **Funções**: snake_case (`update_stats_ui`, `start_combat`)
- **Constantes**: UPPER_CASE (`MAX_LEVEL`, `BASE_DAMAGE`)
- **Classes**: PascalCase (`Enemy`, `GameManager`)
- **Sinais**: snake_case (`stats_updated`, `combat_ended`)

### Comentários
```gdscript
# Breve descrição da seção
var variable_name: Type

# Função com propósito claro
func do_something():
    # Comentário de implementação se necessário
    pass
```

## 🚀 Performance

### Boas Práticas
- ✅ Usar sinais ao invés de polling
- ✅ Usar `@onready` para nodes
- ✅ Timers para ações periódicas
- ✅ `queue_free()` para cleanup

### Evitar
- ❌ `get_node()` em `_process()`
- ❌ Polling constante de estados
- ❌ Criar objetos em loops
- ❌ Strings concatenation em loops

## 📚 Recursos Externos

- [Godot Docs 4.5](https://docs.godotengine.org/en/stable/)
- [GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [Godot Best Practices](https://docs.godotengine.org/en/stable/tutorials/best_practices/)

---

**Última Atualização**: Dezembro 2024  
**Versão do Jogo**: 1.0
