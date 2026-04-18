class_name GameData extends Resource

@export var current_points := 0
@export var current_bucks := 0
@export var is_new_game := true
@export var purchased_node_names: Array[String] = []

@export var bus_volumes: Dictionary[String, float] = {
	"Master": 0.9,
	"SoundFx": 0.7,
	"Music": 0.7,
}

@export var bus_enableds: Dictionary[String, bool] = {
	"Master": true,
	"SoundFx": true,
	"Music": true
}
