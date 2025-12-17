extends Node
# CombatManager - Handles auto-combat logic

var current_enemy: Enemy = null
var is_combat_active: bool = false
var combat_log: Array = []

signal combat_started
signal combat_ended
signal enemy_defeated
signal combat_log_updated
signal player_attacked
signal enemy_attacked

func start_combat(enemy: Enemy):
	current_enemy = enemy
	is_combat_active = true
	combat_log.clear()
	add_to_log("Combate iniciado contra " + enemy.enemy_name + "!")
	combat_started.emit()

func auto_attack():
	if not is_combat_active or current_enemy == null:
		return
	
	# Player attacks
	var player_damage = calculate_player_damage()
	var evasion_roll = randi_range(0, 100)
	
	if evasion_roll < current_enemy.evasion:
		add_to_log("O ataque falhou! " + current_enemy.enemy_name + " desviou!")
	else:
		var damage_dealt = current_enemy.take_damage(player_damage)
		add_to_log("Você causou " + str(damage_dealt) + " de dano!")
		player_attacked.emit()
	
	# Check if enemy is defeated
	if not current_enemy.is_alive():
		defeat_enemy()
		return
	
	# Enemy attacks
	await get_tree().create_timer(0.5).timeout
	
	# Check if combat is still active after the delay
	if not is_combat_active or current_enemy == null or not current_enemy.is_alive():
		return
	
	var enemy_damage = current_enemy.attack
	GameManager.take_damage(enemy_damage)
	add_to_log(current_enemy.enemy_name + " causou " + str(enemy_damage) + " de dano!")
	enemy_attacked.emit()
	
	# Check if player is defeated
	if GameManager.player_hp <= 0:
		end_combat_defeat()

func calculate_player_damage() -> int:
	var base_damage = 10 + GameManager.player_level * 2
	return base_damage

func defeat_enemy():
	add_to_log(current_enemy.enemy_name + " foi derrotado!")
	var loot = current_enemy.get_loot()
	
	# Give loot to player
	GameManager.add_coins(loot["coins"])
	add_to_log("Você ganhou " + str(loot["coins"]) + " moedas!")
	
	for item_name in loot["items"]:
		var amount = loot["items"][item_name]
		GameManager.add_resource(item_name, amount)
		add_to_log("Você ganhou " + str(amount) + "x " + item_name + "!")
	
	# Give XP
	var xp_gained = 20 + (current_enemy.max_hp / 2)
	GameManager.add_xp(xp_gained)
	add_to_log("Você ganhou " + str(xp_gained) + " XP!")
	
	enemy_defeated.emit()
	end_combat_victory()

func end_combat_victory():
	is_combat_active = false
	add_to_log("Vitória!")
	combat_ended.emit()

func end_combat_defeat():
	is_combat_active = false
	add_to_log("Você foi derrotado...")
	GameManager.player_hp = GameManager.player_max_hp  # Reset HP for now
	combat_ended.emit()

func add_to_log(message: String):
	combat_log.append(message)
	combat_log_updated.emit()

func get_combat_log() -> String:
	return "\n".join(combat_log)
