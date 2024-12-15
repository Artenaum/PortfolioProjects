extends Area2D
class_name EnemyPlasmaBullet

@export var speed: float = 10.0
@export var damage: int = 1

var playerInArea: Player = null

func _process(delta: float) -> void:
	if playerInArea != null:
		playerInArea.take_damage(damage)


func _physics_process(delta: float) -> void:
	position += -transform.x * speed * delta
	if position.x < -20.0:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.get_parent().take_damage(damage)
		queue_free()
