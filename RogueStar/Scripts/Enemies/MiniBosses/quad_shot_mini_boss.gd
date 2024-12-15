extends MiniBoss

@onready var fireTimer := $FireTimer

@export var fireRate := 3.0

func _process(delta: float) -> void:
	if fireTimer.is_stopped() && reached_position:
		fire_attack(0, 0)
		fire_attack(0, -10)
		fire_attack(1, 0)
		fire_attack(1, 10)
		fireTimer.start(fireRate)
