extends Node2D

@export var bullet_scene: PackedScene
@export var buffed_bullet_scene: PackedScene
@export var time_between_shots: float = 0.1

var timer
var can_shoot: bool

func _ready() -> void:
	can_shoot = true

	timer = get_child(0)
	timer.wait_time = time_between_shots
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)


func shoot(_buffed):
	if can_shoot:
		if not _buffed:
			var bullet = bullet_scene.instantiate()
			bullet.global_position = global_position
			var direction = global_rotation - PI / 2
			bullet.global_rotation = direction
			get_tree().current_scene.add_child(bullet)
		else:
			var bullet = buffed_bullet_scene.instantiate()
			bullet.global_position = global_position
			var direction = global_rotation - PI / 2
			bullet.global_rotation = direction
			bullet.scale.x = 1.5
			bullet.scale.y = 1.5
			get_tree().current_scene.add_child(bullet)
		
		can_shoot = false
		timer.start()


func _on_timer_timeout() -> void:
	can_shoot = true
