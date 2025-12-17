extends Resource
class_name Enemy

# Enemy Stats
var enemy_name: String = "Unknown"
var max_hp: int = 50
var current_hp: int = 50
var attack: int = 5
var defense: int = 0
var evasion: int = 0

# Loot Table
var coin_drop_min: int = 5
var coin_drop_max: int = 15
var item_drops: Dictionary = {}

func _init(name: String = "Unknown", hp: int = 50, atk: int = 5, def: int = 0, eva: int = 0):
	enemy_name = name
	max_hp = hp
	current_hp = hp
	attack = atk
	defense = def
	evasion = eva

func take_damage(amount: int):
	var actual_damage = max(1, amount - defense)
	current_hp -= actual_damage
	if current_hp < 0:
		current_hp = 0
	return actual_damage

func is_alive() -> bool:
	return current_hp > 0

func get_loot() -> Dictionary:
	var loot = {
		"coins": randi_range(coin_drop_min, coin_drop_max),
		"items": {}
	}
	
	for item_name in item_drops:
		var drop_chance = item_drops[item_name]
		if randf() < drop_chance:
			if loot["items"].has(item_name):
				loot["items"][item_name] += 1
			else:
				loot["items"][item_name] = 1
	
	return loot

# Predefined Enemies
static func create_goblin_scout() -> Enemy:
	var goblin = Enemy.new("Goblin Batedor", 30, 8, 2, 15)
	goblin.coin_drop_min = 5
	goblin.coin_drop_max = 12
	goblin.item_drops = {
		"rat_meat": 0.3,
		"tin": 0.2
	}
	return goblin

static func create_goblin_brute() -> Enemy:
	var brute = Enemy.new("Goblin Brutamontes", 80, 12, 10, 5)
	brute.coin_drop_min = 10
	brute.coin_drop_max = 25
	brute.item_drops = {
		"copper": 0.4,
		"tin": 0.3
	}
	return brute

static func create_goblin_king() -> Enemy:
	var king = Enemy.new("Rei Goblin", 150, 20, 15, 10)
	king.coin_drop_min = 50
	king.coin_drop_max = 100
	king.item_drops = {
		"copper": 1.0,
		"tin": 0.8,
		"bronze": 0.3
	}
	return king
