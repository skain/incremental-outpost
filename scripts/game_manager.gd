class_name GameManagerAutoload extends Node

const save_data_path = "user://game_data.tres"
@onready var game_data:GameData

var _skill_nodes_by_name: Dictionary[String, SkillTreeNode] = {}
#gdscript doesn't support nested typed collections, unfortunately
var _skill_nodes_by_affected_stat: Dictionary = {}
var _base_points_to_bucks_rate: float = 0.1
var _skill_modifiers := SkillModifiersManager.new()


func _ready() -> void:
	if ResourceLoader.exists(save_data_path):
		game_data = load(save_data_path)
	else:
		game_data = GameData.new()


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
	if not _skill_nodes_by_affected_stat.has(node.skill_node_resource.affected_stat):
		_skill_nodes_by_affected_stat[node.skill_node_resource.affected_stat] = []
	
	var array: Array = _skill_nodes_by_affected_stat[node.skill_node_resource.affected_stat]
	
	if not node in array:
		array.append(node)

	
func get_skill_node_by_name(node_name: String) -> SkillTreeNode:
	return _skill_nodes_by_name[node_name]

	
func process_node_purchase(node: SkillTreeNode) -> void:
	game_data.purchased_node_names.append(node.name)
	game_data.current_bucks -= node.get_cost()
	_skill_modifiers.request_refresh(node.get_affected_stat())
	
	
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


# Modifiers
func get_cannon_cooldown_modifier() -> float:
	return _skill_modifiers.cannon_cooldown.get_cooldown(get_purchased_nodes())


func get_hull_plating_modifier() -> int:
	return 0
