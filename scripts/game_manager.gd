extends Node
# GameManager - Singleton to manage global game state

# Player Stats
var player_hp: int = 100
var player_max_hp: int = 100
var player_coins: int = 0
var player_level: int = 1
var player_xp: int = 0
var player_xp_to_next_level: int = 100
var player_reputation: int = 0
var player_rank: String = "G"
var player_mastery: int = 0
var player_mastery_max: int = 100

# Inventory - Resources
var inventory: Dictionary = {
	"copper": 0,
	"tin": 0,
	"bronze": 0,
	"rat_meat": 0,
}

# Tools and Equipment
var owned_tools: Dictionary = {
	"copper_pickaxe": false,
	"bronze_pickaxe": false,
}

# Progression Flags
var shop_unlocked: bool = false
var dungeon_unlocked: bool = false
var milestones_completed: int = 0

# Signals
signal stats_updated
signal inventory_updated
signal rank_updated
signal milestone_completed

func _ready():
	# Initialize game state
	pass

func add_resource(resource_name: String, amount: int):
	if inventory.has(resource_name):
		inventory[resource_name] += amount
		inventory_updated.emit()

func remove_resource(resource_name: String, amount: int) -> bool:
	if inventory.has(resource_name) and inventory[resource_name] >= amount:
		inventory[resource_name] -= amount
		inventory_updated.emit()
		return true
	return false

func has_resource(resource_name: String, amount: int) -> bool:
	return inventory.has(resource_name) and inventory[resource_name] >= amount

func add_coins(amount: int):
	player_coins += amount
	stats_updated.emit()

func remove_coins(amount: int) -> bool:
	if player_coins >= amount:
		player_coins -= amount
		stats_updated.emit()
		return true
	return false

func add_xp(amount: int):
	player_xp += amount
	while player_xp >= player_xp_to_next_level:
		level_up()
	stats_updated.emit()

func level_up():
	player_level += 1
	player_xp -= player_xp_to_next_level
	player_xp_to_next_level = int(player_xp_to_next_level * 1.5)
	player_max_hp += 10
	player_hp = player_max_hp
	check_rank_progression()

func add_mastery(amount: int):
	player_mastery += amount
	if player_mastery >= player_mastery_max:
		player_mastery = 0
		player_mastery_max = int(player_mastery_max * 1.2)
	stats_updated.emit()

func complete_milestone():
	milestones_completed += 1
	milestone_completed.emit()
	check_rank_progression()

func check_rank_progression():
	if player_rank == "G" and milestones_completed >= 3:
		player_rank = "G+"
		shop_unlocked = true
		dungeon_unlocked = true
		rank_updated.emit()

func own_tool(tool_name: String):
	if owned_tools.has(tool_name):
		owned_tools[tool_name] = true

func has_tool(tool_name: String) -> bool:
	return owned_tools.has(tool_name) and owned_tools[tool_name]

func take_damage(amount: int):
	player_hp -= amount
	if player_hp < 0:
		player_hp = 0
	stats_updated.emit()

func heal(amount: int):
	player_hp += amount
	if player_hp > player_max_hp:
		player_hp = player_max_hp
	stats_updated.emit()
