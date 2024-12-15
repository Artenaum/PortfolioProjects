extends Enemy
class_name ShooterEnemy

@onready var fireTimer := $FireTimer

@export var fireRate := 1.0

func _ready():
	super()
	

func _process(delta: float) -> void:
	if fireTimer.is_stopped() && reached_position:
		fire()
		fireTimer.start(fireRate)
