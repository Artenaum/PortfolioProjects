extends Area2D

const BONUS_TYPE: String = "Attack"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func _on_area_entered(area: Area2D) -> void:
#	if area.get_parent() is Player:
#		emit_signal("bonus_collected", bonus_type)
