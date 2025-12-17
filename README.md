# Apex Hunter - Protótipo Funcional

![Godot Engine](https://img.shields.io/badge/Godot-4.5-blue.svg)
![Status](https://img.shields.io/badge/Status-Prototype-yellow.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

Segunda versão do protótipo Apex Hunter - Um Idle RPG com coleta de recursos, criação de itens e combate automático.

## 🎮 Sobre o Jogo

Apex Hunter é um Idle RPG onde você progride através de coleta de recursos, criação de ferramentas e combate automático contra monstros. O jogo implementa um sistema de progressão por ranks, começando no Rank G e avançando conforme completa marcos específicos.

## ✨ Funcionalidades Implementadas

### Interface (HUD)
- ✅ 5 Abas principais: Coleta, Criação, Combate, Loja e Perfil
- ✅ Display de HP, Moedas, Nível, Reputação e Rank
- ✅ Barras de progressão para XP e Maestria

### Sistemas de Jogo
- ✅ **Sistema de Coleta**: Mineração de Cobre com timer de 3 segundos
- ✅ **Sistema de Criação**: Receita da Picareta de Bronze (10x Cobre)
- ✅ **Combate Automático**: 2 tipos de inimigos (Goblin Batedor e Brutamontes)
- ✅ **Sistema de Loot**: Moedas e itens básicos (Estanho, Carne de Rato)
- ✅ **Progressão de Rank**: G → G+ (desbloqueia Loja e Dungeon)
- ✅ **Dungeon**: Caverna dos Goblins com 3 ondas + Boss (Rei Goblin)
- ✅ **Loja**: Compra de Picareta de Cobre (300 moedas)

## 🚀 Como Executar

1. Instale o [Godot Engine 4.5](https://godotengine.org/download) ou superior
2. Clone este repositório
3. Abra o projeto no Godot
4. Pressione F5 ou clique em "Run Project"

## 📁 Estrutura do Projeto

```
apex-hunter-2/
├── scenes/
│   ├── main.tscn              # Cena principal com HUD
│   └── dungeon/
│       └── goblin_cave.tscn   # Dungeon da Caverna dos Goblins
├── scripts/
│   ├── game_manager.gd        # Gerenciador global do jogo
│   ├── combat_manager.gd      # Sistema de combate
│   ├── enemy.gd               # Classe Enemy e tipos predefinidos
│   ├── main.gd                # Controle da UI principal
│   └── goblin_cave.gd         # Lógica da dungeon
├── project.godot              # Configuração do projeto Godot
└── GAME_GUIDE.md              # Guia completo do jogo
```

## 🎯 Ciclo de Gameplay Inicial

1. **Coleta**: Minere 5 Cobre nas Colinas de Cobre
2. **Marco 1**: Desbloqueado (5 Cobre coletados)
3. **Criação**: Crie a Picareta de Bronze (10 Cobre)
4. **Marco 2**: Desbloqueado (primeira ferramenta criada)
5. **Combate**: Derrote um Goblin
6. **Marco 3**: Desbloqueado (primeiro combate vencido)
7. **Progressão**: Rank G+ alcançado
8. **Desbloqueios**: Loja e Dungeon disponíveis

## 📊 Inimigos

| Nome | HP | Ataque | Defesa | Evasão | Loot |
|------|-------|--------|--------|--------|------|
| Goblin Batedor | 30 | 8 | 2 | 15% | 5-12 moedas, itens básicos |
| Goblin Brutamontes | 80 | 12 | 10 | 5% | 10-25 moedas, recursos |
| Rei Goblin (Boss) | 150 | 20 | 15 | 10% | 50-100 moedas, loot especial |

## 🛠️ Tecnologias

- **Engine**: Godot 4.5
- **Linguagem**: GDScript
- **Arquitetura**: Sistema modular com singletons
- **UI**: Placeholders geométricos (cores sólidas)

## 📖 Documentação

Consulte [GAME_GUIDE.md](GAME_GUIDE.md) para:
- Guia completo de gameplay
- Detalhes de todas as mecânicas
- Fórmulas e sistemas
- Arquitetura técnica
- Planos de expansão

## 🔄 Próximas Iterações

- [ ] Adicionar mais áreas de coleta
- [ ] Expandir sistema de crafting
- [ ] Sistema de equipamentos
- [ ] Melhorias visuais (sprites)
- [ ] Mais dungeons e bosses
- [ ] Sistema de quests
- [ ] Conquistas/achievements

## 🤝 Contribuindo

Este é um protótipo em desenvolvimento. Feedback e sugestões são bem-vindos!

## 📝 Licença

Este projeto está sob a licença MIT.

---

**Versão**: 1.0 (Protótipo Funcional)  
**Desenvolvido com**: Godot Engine 4.5  
**Data**: Dezembro 2024