class_name GameManagerAutoload extends Node

const SAVE_DATA_PATH = "user://game_data.tres"
@onready var game_data:GameData

# INDENT_ID is just a random value that is used to refer to the character in the story
const INDENT_ID := "1a4c9433-55c1-4774-bd45-b5275c63ad76"

var _skill_nodes_by_name: Dictionary[String, SkillTreeNode] = {}
#gdscript doesn't support nested typed collections, unfortunately
var _skill_nodes_by_affected_stat: Dictionary = {}
var _base_points_to_bucks_rate: float = 0.1
var _skill_modifiers := SkillModifiersManager.new()
var _current_enemy_wave_level := 0


func _ready() -> void:
	load_game()


func load_game() -> void:
	if ResourceLoader.exists(SAVE_DATA_PATH):
		game_data = ResourceLoader.load(SAVE_DATA_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	else:
		game_data = GameData.new()


func save_game() -> void:
	ResourceSaver.save(game_data, SAVE_DATA_PATH)
	
	
func set_points(new_points: int) -> void:
	game_data.current_points = new_points

	
func get_points_to_bucks_rate() -> float:
	#logic to handle upgrades to conversion rate will go here
	return _base_points_to_bucks_rate

	
func convert_points_to_bucks() -> int:
	var new_bucks:int = floor(game_data.current_points * get_points_to_bucks_rate())
	set_points(0)
	game_data.current_bucks += new_bucks
	return new_bucks

	
func register_skill_node(node: SkillTreeNode) -> void:
	_skill_nodes_by_name[node.name] = node
	if not _skill_nodes_by_affected_stat.has(node.affected_stat):
		_skill_nodes_by_affected_stat[node.affected_stat] = []
	
	var array: Array = _skill_nodes_by_affected_stat[node.affected_stat]
	
	if not node in array:
		array.append(node)

	
func get_skill_node_by_name(node_name: String) -> SkillTreeNode:
	return _skill_nodes_by_name[node_name]

	
func process_node_purchase(node: SkillTreeNode) -> void:
	game_data.purchased_node_names.append(node.name)
	game_data.current_bucks -= node.modifier_value
	_skill_modifiers.request_refresh(node.affected_stat)
	
	
func is_node_purchased(node: SkillTreeNode) -> bool:
	return game_data.purchased_node_names.has(node.name)
	

func get_purchased_nodes() -> Array[SkillTreeNode]:
	var purchased_nodes :Array[SkillTreeNode] = []
	for purchased in game_data.purchased_node_names:
		assert(_skill_nodes_by_name.has(purchased))
		purchased_nodes.append(_skill_nodes_by_name[purchased])
	
	return purchased_nodes


func is_affordable_bucks(bucks: int) -> bool:
	return bucks <= game_data.current_bucks


func reset_save_game() -> void:
	_delete_save_game()
	load_game()


func _delete_save_game() -> void:
	if ResourceLoader.exists(SAVE_DATA_PATH):
		DirAccess.remove_absolute(SAVE_DATA_PATH)


func get_current_enemy_wave_level() -> int:
	return _current_enemy_wave_level
	

func _set_current_enemy_wave_level(new_level: int) -> void:
	_current_enemy_wave_level = new_level


func increment_current_enemy_wave_level() -> int:
	_set_current_enemy_wave_level(_current_enemy_wave_level + 1)
	return get_current_enemy_wave_level()


func get_modifier_value(stat: SkillTreeNode.AffectedStat) -> float:
	return _skill_modifiers.get_modifier_value(stat, get_purchased_nodes())
