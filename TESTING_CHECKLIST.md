# Apex Hunter - Lista de Verificação de Testes

## Como Usar Este Checklist
Execute cada teste na ordem apresentada. Marque cada item conforme completa.

## ✅ Testes de Inicialização

- [ ] Projeto abre sem erros no Godot 4.5
- [ ] Cena principal (main.tscn) carrega corretamente
- [ ] HUD exibe informações iniciais:
  - [ ] HP: 100/100
  - [ ] Nível 1
  - [ ] Rank G
  - [ ] Reputação: 0
  - [ ] Moedas: 0
  - [ ] XP: 0/100
  - [ ] Maestria: 0/100

## ✅ Testes da Aba "Coleta"

- [ ] Aba "Coleta" é a primeira aba visível
- [ ] Título exibe "Área: Colinas de Cobre"
- [ ] Contador mostra "Cobre coletado: 0"
- [ ] Botão "Minerar Cobre (3s)" está ativo
- [ ] Status mostra "Pronto para minerar"

### Teste de Mineração
- [ ] Clicar em "Minerar Cobre"
- [ ] Botão fica desabilitado durante mineração
- [ ] Status muda para "Minerando..."
- [ ] Barra de progresso anima por 3 segundos
- [ ] Após 3s: Status muda para "Cobre minerado!"
- [ ] Contador incrementa: "Cobre coletado: 1"
- [ ] Barra de Maestria aumenta (+5)
- [ ] Status volta para "Pronto para minerar"
- [ ] Botão fica ativo novamente

### Teste de Marco 1
- [ ] Minerar até ter 5 Cobre
- [ ] Console mostra: "NOTIFICAÇÃO: Marco alcançado: Coletou 5 cobre!"
- [ ] Console mostra: "NOTIFICAÇÃO: Marco completado! (1/3)"

## ✅ Testes da Aba "Criação"

- [ ] Clicar na aba "Criação"
- [ ] Título exibe "Ferraria"
- [ ] Receita "Picareta de Bronze" visível
- [ ] Requisitos mostram: "Requer: 10x Cobre (Você tem: X)"
- [ ] Botão "Criar" desabilitado se Cobre < 10

### Teste de Crafting
- [ ] Minerar até ter 10 Cobre (se ainda não tem)
- [ ] Botão "Criar" fica habilitado
- [ ] Clicar em "Criar"
- [ ] Console mostra: "NOTIFICAÇÃO: Picareta de Bronze criada!"
- [ ] Cobre diminui para 0 (ou menos 10)
- [ ] Barra de Maestria aumenta (+20)
- [ ] Console mostra: "NOTIFICAÇÃO: Marco alcançado: Criou sua primeira ferramenta!"
- [ ] Console mostra: "NOTIFICAÇÃO: Marco completado! (2/3)"
- [ ] Botão muda para "Criado ✓" e fica desabilitado

## ✅ Testes da Aba "Combate"

- [ ] Clicar na aba "Combate"
- [ ] Título exibe "Área de Combate: Campos dos Goblins"
- [ ] Enemy Info mostra "Nenhum inimigo" e "HP: 0/0"
- [ ] Dois botões visíveis:
  - [ ] "Lutar: Goblin Batedor"
  - [ ] "Lutar: Goblin Brutamontes"
- [ ] Seção Dungeons mostra "🔒 Desbloqueie ao alcançar Rank G+"
- [ ] Log de Combate mostra "Log de Combate..."

### Teste de Combate: Goblin Batedor
- [ ] Clicar em "Lutar: Goblin Batedor"
- [ ] Enemy Info atualiza:
  - [ ] Nome: "Goblin Batedor"
  - [ ] HP: 30/30
- [ ] Log mostra: "Combate iniciado contra Goblin Batedor!"
- [ ] Combate automático inicia (ataques a cada 1.5s)
- [ ] Log atualiza com mensagens de ataque
- [ ] HP do jogador pode diminuir
- [ ] HP do inimigo diminui
- [ ] Alguns ataques podem falhar (evasão)
- [ ] Quando inimigo é derrotado:
  - [ ] Log mostra: "Goblin Batedor foi derrotado!"
  - [ ] Log mostra moedas ganhas (5-12)
  - [ ] Log pode mostrar itens ganhos
  - [ ] Log mostra XP ganho
  - [ ] Console mostra: "NOTIFICAÇÃO: Marco completado! (3/3)"
  - [ ] Enemy Info volta para "Nenhum inimigo"
  - [ ] Botões de luta ficam ativos novamente

### Teste de Combate: Goblin Brutamontes
- [ ] Clicar em "Lutar: Goblin Brutamontes"
- [ ] Enemy Info atualiza:
  - [ ] Nome: "Goblin Brutamontes"
  - [ ] HP: 80/80
- [ ] Combate é mais longo (inimigo tem mais HP e defesa)
- [ ] Mesmo fluxo de combate automático
- [ ] Loot diferente (10-25 moedas)

### Teste de Progressão de Rank
- [ ] Após derrotar primeiro inimigo:
- [ ] Console mostra: "NOTIFICAÇÃO: Rank aumentado para G+!"
- [ ] Console mostra: "NOTIFICAÇÃO: Loja e Dungeon desbloqueados!"
- [ ] HUD atualiza para "Rank G+"
- [ ] Seção Dungeons agora mostra botão "Entrar: Caverna dos Goblins"

## ✅ Testes da Aba "Loja"

- [ ] Clicar na aba "Loja"
- [ ] Antes do Rank G+:
  - [ ] Mostra "🔒 Desbloqueie ao alcançar Rank G+"
  - [ ] Lista de itens está oculta
- [ ] Após Rank G+:
  - [ ] Mensagem de bloqueio desaparece
  - [ ] Item "Picareta de Cobre" visível
  - [ ] Preço: "300 Moedas"
  - [ ] Botão "Comprar" desabilitado se Moedas < 300

### Teste de Compra
- [ ] Ganhar moedas suficientes (combate ou dungeon)
- [ ] Botão "Comprar" fica habilitado
- [ ] Clicar em "Comprar"
- [ ] Console mostra: "NOTIFICAÇÃO: Picareta de Cobre comprada!"
- [ ] Moedas diminuem em 300
- [ ] Botão muda para "Comprado ✓" e fica desabilitado

## ✅ Testes da Aba "Perfil"

- [ ] Clicar na aba "Perfil"
- [ ] Estatísticas exibidas corretamente:
  - [ ] Nível corresponde ao HUD
  - [ ] Rank corresponde ao HUD
  - [ ] Reputação corresponde ao HUD
  - [ ] Moedas correspondem ao HUD
- [ ] Inventário mostra recursos coletados:
  - [ ] Cobre: X
  - [ ] Estanho: X
  - [ ] Bronze: X
  - [ ] Carne de Rato: X

## ✅ Testes da Dungeon "Caverna dos Goblins"

### Acesso à Dungeon
- [ ] Na aba Combate, após Rank G+
- [ ] Botão "Entrar: Caverna dos Goblins" visível
- [ ] Clicar no botão
- [ ] Cena muda para goblin_cave.tscn

### Interface da Dungeon
- [ ] Título: "🏰 Caverna dos Goblins"
- [ ] Subtítulo: "Dungeon - 3 inimigos + Chefe"
- [ ] Status: "Inimigos derrotados: 0/4"
- [ ] Enemy Info: "Aguardando..." e "HP: 0/0"
- [ ] Botão "Iniciar Dungeon" ativo
- [ ] Botão "Voltar" ativo
- [ ] Log de boas-vindas visível
- [ ] Panel de recompensas oculto

### Teste de Dungeon Completa
- [ ] Clicar em "Iniciar Dungeon"
- [ ] Botão fica desabilitado
- [ ] Log mostra: "🏰 Dungeon iniciada!"
- [ ] Aguardar 2 segundos

#### Onda 1: Goblin Batedor
- [ ] Log mostra: "--- Onda 1/3 ---"
- [ ] Enemy Info atualiza para Goblin Batedor
- [ ] Combate automático inicia
- [ ] Após derrota:
  - [ ] Status: "Inimigos derrotados: 1/4"
  - [ ] Loot processado

#### Onda 2: Goblin Brutamontes
- [ ] Log mostra: "--- Onda 2/3 ---"
- [ ] Enemy Info atualiza para Goblin Brutamontes
- [ ] Combate automático continua
- [ ] Após derrota:
  - [ ] Status: "Inimigos derrotados: 2/4"
  - [ ] Loot processado

#### Onda 3: Goblin Batedor
- [ ] Log mostra: "--- Onda 3/3 ---"
- [ ] Enemy Info atualiza para Goblin Batedor
- [ ] Combate automático continua
- [ ] Após derrota:
  - [ ] Status: "Inimigos derrotados: 3/4"
  - [ ] Loot processado

#### Boss: Rei Goblin
- [ ] Log mostra: "--- ⚔️ CHEFE FINAL ⚔️ ---"
- [ ] Enemy Info atualiza para Rei Goblin
- [ ] HP: 150/150
- [ ] Combate mais longo e desafiador
- [ ] Após derrota:
  - [ ] Status: "Inimigos derrotados: 4/4"
  - [ ] Log mostra: "🎉 Dungeon completada com sucesso!"
  - [ ] Loot especial do boss processado
  - [ ] Recompensas extras: +100 moedas, +2 Bronze, +100 XP

### Recompensas da Dungeon
- [ ] Panel de recompensas aparece
- [ ] Título: "🎉 Dungeon Completada!"
- [ ] Lista de recompensas visível
- [ ] Botão "Iniciar Dungeon" fica ativo novamente

### Retorno ao Menu Principal
- [ ] Clicar em "Voltar"
- [ ] Cena volta para main.tscn
- [ ] Todos os recursos e progresso mantidos

## ✅ Testes de Sistema de Progressão

### Level Up
- [ ] Ganhar XP suficiente (100 XP inicial)
- [ ] Barra de XP enche
- [ ] Level aumenta (mostra no HUD)
- [ ] HP máximo aumenta (+10)
- [ ] HP atual restaurado para máximo
- [ ] XP necessário para próximo nível aumenta (x1.5)

### Sistema de Maestria
- [ ] Realizar ações (minerar, craftar)
- [ ] Barra de Maestria aumenta
- [ ] Quando barra enche:
  - [ ] Maestria reseta para 0
  - [ ] Máximo aumenta (x1.2)

## ✅ Testes de Persistência de Estado

### Entre Cenas
- [ ] Estado do jogador mantido ao ir para Dungeon
- [ ] Estado mantido ao voltar da Dungeon
- [ ] Recursos não são perdidos
- [ ] Progresso de rank mantido

### Durante Gameplay
- [ ] HP persiste entre combates (mas regenera se derrotado)
- [ ] Moedas acumulam corretamente
- [ ] XP acumula corretamente
- [ ] Inventário sempre atualizado
- [ ] Ferramentas compradas/criadas mantidas

## ✅ Testes de UI e Feedback

### Barras de Progresso
- [ ] HP bar atualiza em tempo real durante combate
- [ ] XP bar anima ao ganhar XP
- [ ] Maestria bar anima ao ganhar maestria
- [ ] Mining progress bar anima durante mineração
- [ ] Enemy HP bar atualiza durante combate

### Botões e Estados
- [ ] Botões desabilitam quando ação não disponível
- [ ] Botões mostram estado "✓" quando ação completada
- [ ] Botões de combate desabilitam durante combate ativo

### Log e Notificações
- [ ] Combat log atualiza em tempo real
- [ ] Notificações aparecem no console
- [ ] Messages são claras e informativas

## ✅ Testes de Edge Cases

### Recursos Insuficientes
- [ ] Tentar craftar sem recursos → Botão desabilitado
- [ ] Tentar comprar sem moedas → Botão desabilitado

### Combate
- [ ] HP do jogador chega a 0 → Combate termina, HP restaura
- [ ] Evasão funciona (alguns ataques falham)
- [ ] Defesa reduz dano corretamente

### Múltiplas Ações
- [ ] Minerar múltiplas vezes consecutivas
- [ ] Combater múltiplos inimigos em sequência
- [ ] Completar dungeon múltiplas vezes

## 📊 Resumo dos Resultados

Total de testes: ~100+
Testes passados: ___
Testes falhados: ___
Bugs encontrados: ___

## 🐛 Bugs Encontrados

Lista bugs aqui:
1. 
2. 
3. 

## 💡 Melhorias Sugeridas

Liste sugestões aqui:
1. 
2. 
3. 

---

**Data do Teste**: ___________  
**Versão Testada**: 1.0  
**Testador**: ___________
