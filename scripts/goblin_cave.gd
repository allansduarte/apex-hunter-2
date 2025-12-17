extends Control

@onready var dungeon_status = $VBoxContainer/MarginContainer/ContentContainer/DungeonStatus
@onready var enemy_name_label = $VBoxContainer/MarginContainer/ContentContainer/EnemyInfoPanel/VBoxContainer/EnemyName
@onready var enemy_hp_label = $VBoxContainer/MarginContainer/ContentContainer/EnemyInfoPanel/VBoxContainer/EnemyHP
@onready var enemy_hp_bar = $VBoxContainer/MarginContainer/ContentContainer/EnemyInfoPanel/VBoxContainer/EnemyHPBar
@onready var start_button = $VBoxContainer/MarginContainer/ContentContainer/ButtonsContainer/StartButton
@onready var return_button = $VBoxContainer/MarginContainer/ContentContainer/ButtonsContainer/ReturnButton
@onready var combat_log_label = $VBoxContainer/MarginContainer/ContentContainer/CombatLog/ScrollContainer/LogLabel
@onready var rewards_panel = $VBoxContainer/MarginContainer/ContentContainer/RewardsPanel
@onready var rewards_label = $VBoxContainer/MarginContainer/ContentContainer/RewardsPanel/VBoxContainer/RewardsLabel

var enemies_defeated: int = 0
var dungeon_active: bool = false
var combat_timer: Timer = null
var current_enemy: Enemy = null

var enemy_queue: Array = []

func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
	return_button.pressed.connect(_on_return_button_pressed)
	
	CombatManager.combat_ended.connect(_on_combat_ended)
	CombatManager.enemy_defeated.connect(_on_enemy_defeated)
	CombatManager.combat_log_updated.connect(_on_combat_log_updated)
	
	rewards_panel.visible = false

func _on_start_button_pressed():
	if not dungeon_active:
		start_dungeon()

func start_dungeon():
	dungeon_active = true
	enemies_defeated = 0
	start_button.disabled = true
	
	# Setup enemy queue
	enemy_queue = [
		Enemy.create_goblin_scout(),
		Enemy.create_goblin_brute(),
		Enemy.create_goblin_scout(),
		Enemy.create_goblin_king()  # Boss
	]
	
	add_to_log("🏰 Dungeon iniciada!")
	add_to_log("Prepare-se para a primeira onda!")
	
	await get_tree().create_timer(2.0).timeout
	spawn_next_enemy()

func spawn_next_enemy():
	if enemy_queue.size() > 0:
		current_enemy = enemy_queue.pop_front()
		
		var wave_number = 4 - enemy_queue.size()
		if wave_number <= 3:
			add_to_log("\n--- Onda %d/3 ---" % wave_number)
		else:
			add_to_log("\n--- ⚔️ CHEFE FINAL ⚔️ ---")
		
		CombatManager.start_combat(current_enemy)
		update_dungeon_ui()
		
		# Start combat loop
		combat_timer = Timer.new()
		combat_timer.wait_time = 1.5
		combat_timer.timeout.connect(_on_combat_timer_timeout)
		add_child(combat_timer)
		combat_timer.start()
	else:
		complete_dungeon()

func _on_combat_timer_timeout():
	if CombatManager.is_combat_active:
		CombatManager.auto_attack()
		update_dungeon_ui()

func _on_enemy_defeated():
	enemies_defeated += 1
	update_dungeon_ui()

func _on_combat_ended():
	if combat_timer:
		combat_timer.stop()
		combat_timer.queue_free()
		combat_timer = null
	
	if dungeon_active:
		await get_tree().create_timer(1.5).timeout
		
		if enemy_queue.size() > 0:
			spawn_next_enemy()
		else:
			complete_dungeon()

func complete_dungeon():
	dungeon_active = false
	add_to_log("\n🎉 Dungeon completada com sucesso!")
	add_to_log("Todas as ondas foram derrotadas!")
	
	# Extra rewards
	GameManager.add_coins(100)
	GameManager.add_resource("bronze", 2)
	GameManager.add_xp(100)
	
	show_rewards()
	start_button.disabled = false

func show_rewards():
	rewards_panel.visible = true
	rewards_label.text = "Recompensas obtidas:\n+100 Moedas\n+2 Bronze\n+100 XP"

func update_dungeon_ui():
	dungeon_status.text = "Inimigos derrotados: %d/4" % enemies_defeated
	
	if CombatManager.current_enemy != null and CombatManager.is_combat_active:
		var enemy = CombatManager.current_enemy
		enemy_name_label.text = enemy.enemy_name
		enemy_hp_label.text = "HP: %d/%d" % [enemy.current_hp, enemy.max_hp]
		enemy_hp_bar.max_value = enemy.max_hp
		enemy_hp_bar.value = enemy.current_hp
	else:
		enemy_name_label.text = "Aguardando..."
		enemy_hp_label.text = "HP: 0/0"
		enemy_hp_bar.value = 0

func _on_combat_log_updated():
	combat_log_label.text = CombatManager.get_combat_log()

func add_to_log(message: String):
	CombatManager.add_to_log(message)

func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
