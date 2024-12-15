extends Area2D
signal bonus_collected

func _on_area_entered(area: Area2D) -> void:
	print("Area")
	if area.is_in_group("Bonus"):
		print("Bonus")
		emit_signal("bonus_collected", area.BONUS_TYPE)
		area.queue_free()
