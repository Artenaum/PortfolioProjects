extends Area2D

@export var speed: float = 400.0
@export var damage: int = 2
@export var steeringForce: float = 1000.0

var velocity = Vector2()
var acceleration = Vector2()
var target = null

var playerInArea: Player = null

func _process(delta: float) -> void:
	if playerInArea != null:
		playerInArea.take_damage(damage)

func steer():
	var steering = Vector2()
	if target:
		var ideal_velocity = (target.position - position).normalized() * speed
		steering = (ideal_velocity - velocity).normalized() * steeringForce
	return steering

func _ready() -> void:
	target = get_parent().get_node("Player")
	global_rotation = 0

func _physics_process(delta: float) -> void:
	velocity = transform.x * speed
	acceleration -= steer()
	velocity += acceleration * delta
	velocity = velocity.limit_length(speed)
	rotation = velocity.angle()
	position -= velocity * delta
	if position.x < -20.0:
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.get_parent().take_damage(damage)
		queue_free()
