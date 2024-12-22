extends Area2D

signal clicked

var starName: String
var mouse_over = false

func _ready() -> void:
	input_pickable = true

func _on_input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	var mouse_event = event as InputEventMouseButton
	if mouse_event:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				print("clicked!")
				emit_signal("clicked", starName)

func _on_mouse_entered() -> void:
	mouse_over = true

func _on_mouse_exited() -> void:
	mouse_over = false

func _process(delta: float) -> void:
	if mouse_over:
		rotation += 5 * delta
