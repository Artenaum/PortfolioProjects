extends Node2D

var system1 = {
	"boss_4": 1,
	"quad_shot_mini": 1,
	"double_shooter_enemy": 1,
	"fast_enemy": 1,
}

#var enemiesPerSystem = {}

#Dictionary dict {}

func save_system(system: Dictionary):
	var saveSystem = FileAccess.open("user://savesystem.save", FileAccess.WRITE)
	var jsonString = JSON.stringify(system)
	saveSystem.store_line(jsonString)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#save_system(system1)
	#get_tree().change_scene_to_file("res://Stages/battle_mode.tscn")
