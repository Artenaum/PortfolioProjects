extends Area2D

@export var speed: float = 10.0
@export var damage: int = 1

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta 

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.take_damage(damage)
		queue_free()
