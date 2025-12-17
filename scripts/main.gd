extends Control

# References to UI elements
@onready var hp_label = $VBoxContainer/TopBar/MarginContainer/HBoxContainer/StatsLeft/HPLabel
@onready var hp_bar = $VBoxContainer/TopBar/MarginContainer/HBoxContainer/StatsLeft/HPBar
@onready var info_label = $VBoxContainer/TopBar/MarginContainer/HBoxContainer/StatsCenter/InfoLabel
@onready var coins_label = $VBoxContainer/TopBar/MarginContainer/HBoxContainer/StatsCenter/CoinsLabel
@onready var xp_label = $VBoxContainer/TopBar/MarginContainer/HBoxContainer/StatsRight/XPLabel
@onready var xp_bar = $VBoxContainer/TopBar/MarginContainer/HBoxContainer/StatsRight/XPBar
@onready var mastery_label = $VBoxContainer/TopBar/MarginContainer/HBoxContainer/StatsRight/MasteryLabel
@onready var mastery_bar = $VBoxContainer/TopBar/MarginContainer/HBoxContainer/StatsRight/MasteryBar

# Collection tab
@onready var resource_info = $"VBoxContainer/TabContainer/Coleta/CollectionPanel/ResourceInfo"
@onready var mine_button = $"VBoxContainer/TabContainer/Coleta/CollectionPanel/MineButton"
@onready var mining_progress = $"VBoxContainer/TabContainer/Coleta/CollectionPanel/MiningProgress"
@onready var status_label = $"VBoxContainer/TabContainer/Coleta/CollectionPanel/StatusLabel"

# Crafting tab
@onready var craft_bronze_pickaxe_button = $"VBoxContainer/TabContainer/Criação/CraftingPanel/RecipesList/BronzePickaxe/HBoxContainer/CraftButton"
@onready var bronze_pickaxe_requirements = $"VBoxContainer/TabContainer/Criação/CraftingPanel/RecipesList/BronzePickaxe/HBoxContainer/InfoContainer/Requirements"

# Combat tab
@onready var enemy_name_label = $"VBoxContainer/TabContainer/Combate/CombatPanel/EnemyInfo/VBoxContainer/EnemyName"
@onready var enemy_hp_label = $"VBoxContainer/TabContainer/Combate/CombatPanel/EnemyInfo/VBoxContainer/EnemyHP"
@onready var enemy_hp_bar = $"VBoxContainer/TabContainer/Combate/CombatPanel/EnemyInfo/VBoxContainer/EnemyHPBar"
@onready var fight_scout_button = $"VBoxContainer/TabContainer/Combate/CombatPanel/ButtonsContainer/FightScoutButton"
@onready var fight_brute_button = $"VBoxContainer/TabContainer/Combate/CombatPanel/ButtonsContainer/FightBruteButton"
@onready var combat_log_label = $"VBoxContainer/TabContainer/Combate/CombatPanel/CombatLog/ScrollContainer/LogLabel"
@onready var dungeon_locked_label = $"VBoxContainer/TabContainer/Combate/CombatPanel/DungeonSection/DungeonLockedLabel"
@onready var dungeon_button = $"VBoxContainer/TabContainer/Combate/CombatPanel/DungeonSection/DungeonButton"

# Shop tab
@onready var shop_locked_label = $"VBoxContainer/TabContainer/Loja/ShopPanel/LockedLabel"
@onready var shop_items_list = $"VBoxContainer/TabContainer/Loja/ShopPanel/ItemsList"
@onready var buy_copper_pickaxe_button = $"VBoxContainer/TabContainer/Loja/ShopPanel/ItemsList/CopperPickaxeItem/HBoxContainer/BuyButton"

# Profile tab
@onready var profile_level = $"VBoxContainer/TabContainer/Perfil/ProfilePanel/StatsDisplay/LevelValue"
@onready var profile_rank = $"VBoxContainer/TabContainer/Perfil/ProfilePanel/StatsDisplay/RankValue"
@onready var profile_reputation = $"VBoxContainer/TabContainer/Perfil/ProfilePanel/StatsDisplay/ReputationValue"
@onready var profile_coins = $"VBoxContainer/TabContainer/Perfil/ProfilePanel/StatsDisplay/CoinsValue"
@onready var inventory_copper = $"VBoxContainer/TabContainer/Perfil/ProfilePanel/InventoryDisplay/CopperLabel"
@onready var inventory_tin = $"VBoxContainer/TabContainer/Perfil/ProfilePanel/InventoryDisplay/TinLabel"
@onready var inventory_bronze = $"VBoxContainer/TabContainer/Perfil/ProfilePanel/InventoryDisplay/BronzeLabel"
@onready var inventory_rat_meat = $"VBoxContainer/TabContainer/Perfil/ProfilePanel/InventoryDisplay/RatMeatLabel"

# State
var is_mining: bool = false
var mining_timer: float = 0.0
var mining_duration: float = 3.0
var combat_timer: Timer = null
var current_combat_enemy: Enemy = null

func _ready():
	# Initialize singletons as autoloads
	if not has_node("/root/GameManager"):
		var game_manager = load("res://scripts/game_manager.gd").new()
		game_manager.name = "GameManager"
		get_tree().root.add_child(game_manager)
	
	if not has_node("/root/CombatManager"):
		var combat_manager = load("res://scripts/combat_manager.gd").new()
		combat_manager.name = "CombatManager"
		get_tree().root.add_child(combat_manager)
	
	# Connect signals
	GameManager.stats_updated.connect(_on_stats_updated)
	GameManager.inventory_updated.connect(_on_inventory_updated)
	GameManager.rank_updated.connect(_on_rank_updated)
	GameManager.milestone_completed.connect(_on_milestone_completed)
	
	CombatManager.combat_started.connect(_on_combat_started)
	CombatManager.combat_ended.connect(_on_combat_ended)
	CombatManager.enemy_defeated.connect(_on_enemy_defeated)
	CombatManager.combat_log_updated.connect(_on_combat_log_updated)
	CombatManager.player_attacked.connect(_on_player_attacked)
	CombatManager.enemy_attacked.connect(_on_enemy_attacked)
	
	# Connect UI buttons
	mine_button.pressed.connect(_on_mine_button_pressed)
	craft_bronze_pickaxe_button.pressed.connect(_on_craft_bronze_pickaxe_pressed)
	fight_scout_button.pressed.connect(_on_fight_scout_pressed)
	fight_brute_button.pressed.connect(_on_fight_brute_pressed)
	buy_copper_pickaxe_button.pressed.connect(_on_buy_copper_pickaxe_pressed)
	dungeon_button.pressed.connect(_on_dungeon_button_pressed)
	
	# Initialize UI
	update_all_ui()

func _process(delta):
	if is_mining:
		mining_timer += delta
		mining_progress.value = mining_timer
		
		if mining_timer >= mining_duration:
			complete_mining()

func update_all_ui():
	update_stats_ui()
	update_collection_ui()
	update_crafting_ui()
	update_combat_ui()
	update_shop_ui()
	update_profile_ui()

func update_stats_ui():
	hp_label.text = "HP: %d/%d" % [GameManager.player_hp, GameManager.player_max_hp]
	hp_bar.max_value = GameManager.player_max_hp
	hp_bar.value = GameManager.player_hp
	
	info_label.text = "Nível %d | Rank %s | Reputação: %d" % [GameManager.player_level, GameManager.player_rank, GameManager.player_reputation]
	coins_label.text = "Moedas: %d" % GameManager.player_coins
	
	xp_label.text = "XP: %d/%d" % [GameManager.player_xp, GameManager.player_xp_to_next_level]
	xp_bar.max_value = GameManager.player_xp_to_next_level
	xp_bar.value = GameManager.player_xp
	
	mastery_label.text = "Maestria: %d/%d" % [GameManager.player_mastery, GameManager.player_mastery_max]
	mastery_bar.max_value = GameManager.player_mastery_max
	mastery_bar.value = GameManager.player_mastery

func update_collection_ui():
	resource_info.text = "Cobre coletado: %d" % GameManager.inventory["copper"]

func update_crafting_ui():
	var copper_amount = GameManager.inventory["copper"]
	bronze_pickaxe_requirements.text = "Requer: 10x Cobre (Você tem: %d)" % copper_amount
	craft_bronze_pickaxe_button.disabled = copper_amount < 10 or GameManager.has_tool("bronze_pickaxe")
	
	if GameManager.has_tool("bronze_pickaxe"):
		craft_bronze_pickaxe_button.text = "Criado ✓"

func update_combat_ui():
	if CombatManager.current_enemy != null and CombatManager.is_combat_active:
		var enemy = CombatManager.current_enemy
		enemy_name_label.text = enemy.enemy_name
		enemy_hp_label.text = "HP: %d/%d" % [enemy.current_hp, enemy.max_hp]
		enemy_hp_bar.max_value = enemy.max_hp
		enemy_hp_bar.value = enemy.current_hp
		
		fight_scout_button.disabled = true
		fight_brute_button.disabled = true
	else:
		enemy_name_label.text = "Nenhum inimigo"
		enemy_hp_label.text = "HP: 0/0"
		enemy_hp_bar.value = 0
		
		fight_scout_button.disabled = false
		fight_brute_button.disabled = false
	
	# Update dungeon section
	if GameManager.dungeon_unlocked:
		dungeon_locked_label.visible = false
		dungeon_button.visible = true
		dungeon_button.disabled = false
	else:
		dungeon_locked_label.visible = true
		dungeon_button.visible = false

func update_shop_ui():
	if GameManager.shop_unlocked:
		shop_locked_label.visible = false
		shop_items_list.visible = true
		buy_copper_pickaxe_button.disabled = GameManager.player_coins < 300 or GameManager.has_tool("copper_pickaxe")
		
		if GameManager.has_tool("copper_pickaxe"):
			buy_copper_pickaxe_button.text = "Comprado ✓"
	else:
		shop_locked_label.visible = true
		shop_items_list.visible = false

func update_profile_ui():
	profile_level.text = str(GameManager.player_level)
	profile_rank.text = GameManager.player_rank
	profile_reputation.text = str(GameManager.player_reputation)
	profile_coins.text = str(GameManager.player_coins)
	
	inventory_copper.text = "Cobre: %d" % GameManager.inventory["copper"]
	inventory_tin.text = "Estanho: %d" % GameManager.inventory["tin"]
	inventory_bronze.text = "Bronze: %d" % GameManager.inventory["bronze"]
	inventory_rat_meat.text = "Carne de Rato: %d" % GameManager.inventory["rat_meat"]

# Collection handlers
func _on_mine_button_pressed():
	if not is_mining:
		start_mining()

func start_mining():
	is_mining = true
	mining_timer = 0.0
	mining_progress.value = 0
	mine_button.disabled = true
	status_label.text = "Minerando..."

func complete_mining():
	is_mining = false
	mining_timer = 0.0
	mining_progress.value = 0
	mine_button.disabled = false
	status_label.text = "Cobre minerado!"
	
	GameManager.add_resource("copper", 1)
	GameManager.add_mastery(5)
	
	# Check for milestone
	if GameManager.inventory["copper"] >= 5 and GameManager.milestones_completed == 0:
		GameManager.complete_milestone()
		show_notification("Marco alcançado: Coletou 5 cobre!")
	
	await get_tree().create_timer(1.0).timeout
	status_label.text = "Pronto para minerar"

# Crafting handlers
func _on_craft_bronze_pickaxe_pressed():
	if GameManager.has_resource("copper", 10):
		GameManager.remove_resource("copper", 10)
		GameManager.own_tool("bronze_pickaxe")
		GameManager.add_mastery(20)
		show_notification("Picareta de Bronze criada!")
		
		if GameManager.milestones_completed == 1:
			GameManager.complete_milestone()
			show_notification("Marco alcançado: Criou sua primeira ferramenta!")
		
		update_crafting_ui()

# Combat handlers
func _on_fight_scout_pressed():
	var enemy = Enemy.create_goblin_scout()
	start_combat(enemy)

func _on_fight_brute_pressed():
	var enemy = Enemy.create_goblin_brute()
	start_combat(enemy)

func start_combat(enemy: Enemy):
	current_combat_enemy = enemy
	CombatManager.start_combat(enemy)
	update_combat_ui()
	
	# Start auto-combat loop
	combat_timer = Timer.new()
	combat_timer.wait_time = 1.5
	combat_timer.timeout.connect(_on_combat_timer_timeout)
	add_child(combat_timer)
	combat_timer.start()

func _on_combat_timer_timeout():
	if CombatManager.is_combat_active:
		CombatManager.auto_attack()
		update_combat_ui()
		update_stats_ui()
	else:
		if combat_timer:
			combat_timer.stop()
			combat_timer.queue_free()
			combat_timer = null

# Dungeon handlers
func _on_dungeon_button_pressed():
	get_tree().change_scene_to_file("res://scenes/dungeon/goblin_cave.tscn")

# Shop handlers
func _on_buy_copper_pickaxe_pressed():
	if GameManager.remove_coins(300):
		GameManager.own_tool("copper_pickaxe")
		show_notification("Picareta de Cobre comprada!")
		update_shop_ui()

# Signal handlers
func _on_stats_updated():
	update_stats_ui()

func _on_inventory_updated():
	update_collection_ui()
	update_crafting_ui()
	update_profile_ui()

func _on_rank_updated():
	show_notification("Rank aumentado para " + GameManager.player_rank + "!")
	show_notification("Loja e Dungeon desbloqueados!")
	update_all_ui()

func _on_milestone_completed():
	show_notification("Marco completado! (%d/3)" % GameManager.milestones_completed)

func _on_combat_started():
	update_combat_ui()

func _on_combat_ended():
	update_combat_ui()
	update_stats_ui()
	
	# Check for combat milestone
	if GameManager.milestones_completed == 2:
		GameManager.complete_milestone()
		show_notification("Marco alcançado: Venceu seu primeiro combate!")

func _on_enemy_defeated():
	update_combat_ui()

func _on_combat_log_updated():
	combat_log_label.text = CombatManager.get_combat_log()

func _on_player_attacked():
	pass  # Could add visual feedback

func _on_enemy_attacked():
	pass  # Could add visual feedback

func show_notification(text: String):
	print("NOTIFICAÇÃO: " + text)
	# In a full game, this would show a toast or notification UI
