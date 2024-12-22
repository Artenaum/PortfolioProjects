extends Node

@onready var blinkTimer = $BlinkTimer
@onready var durationTimer = $DurationTimer

var blinkObject = Node2D

func start_blinking(object, duration):
	blinkObject = object
	durationTimer.wait_time = duration
	durationTimer.start()
	blinkTimer.start()

func _on_blink_timer_timeout() -> void:
	blinkObject.visible = !blinkObject.visible

func _on_duration_timer_timeout() -> void:
	blinkTimer.stop()
	blinkObject.visible = true
