extends ShooterEnemy

@export var verticalSpeed := 500

var verticalDirection: int = 1
var startingPositionY: float

func _ready() -> void:
	self.set_physics_process(true)
	startingPositionY = position.y


func _physics_process(delta: float) -> void:
	shoot_check()
	move_forward(delta)
	
	position.y += verticalSpeed * delta * verticalDirection
	
	var viewRect := get_viewport_rect()
	if position.y > startingPositionY - 100 or position.y < startingPositionY + 100:
		verticalDirection *= -1
