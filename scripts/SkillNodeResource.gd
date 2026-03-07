class_name SkillNodeResource extends Resource

enum AffectedStat { CANNON_COOLDOWN, }
enum ModifierType { ADD, MULTIPLY, ENABLE }

@export var skill_name: String
@export var skill_desc: String
@export var skill_cost: int
@export var affected_stat: AffectedStat
@export var modifier_type: ModifierType
@export var modifier_value: float
