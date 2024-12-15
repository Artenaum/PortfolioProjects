extends Enemy
class_name SinusoidDoubleShooterEnemy

@onready var fireTimer := $FireTimer

@export var verticalSpeed: float = 100.0
@export var fireRate: float = 3.0

@export_range(1, 1000) var frequency: float = 3
@export_range(1, 1000) var amplitude = 500

var verticalPos: float = 0.0
var verticalDirection: int = 1
var time: float

func _physics_process(delta: float) -> void:
	shoot_check()
	move_forward(delta)
	
	time += delta
	verticalPos = cos(time * frequency) * amplitude
	position.y += verticalPos * delta


func _process(delta: float) -> void:
	if fireTimer.is_stopped() && reached_position:
		fire()
		fireTimer.start(fireRate)
