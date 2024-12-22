extends Enemy
class_name MiniBoss

@export var bullets: Array[PackedScene]
@export_range(1, 1000) var frequency: float = 5
@export_range(1, 1000) var amplitude = 300

@export var verticalSpeed: float = 50.0

var verticalDirection: int = 1
var startingPositionY: float

var verticalPos: float = 0.0
var holdingDistance: float = 300.0
var time: float

func _physics_process(delta: float) -> void:
	if position.x < get_viewport_rect().size.x - holdingDistance:
		reached_position = true
		
	if !reached_position:
		move_forward(delta)
	else:
		time += delta
		verticalPos = cos(time * frequency) * amplitude
		position.y += verticalPos * delta


func fire_attack(attack: int, angle: float):
	var gun = firingPositions.get_child(attack)
	var bullet := bullets[attack].instantiate()
	bullet.global_position = gun.global_position
	var direction = -gun.global_rotation - PI / 2 + deg_to_rad(angle)
	bullet.global_rotation = direction
	get_tree().current_scene.add_child(bullet)
