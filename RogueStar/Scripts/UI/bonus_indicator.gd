extends Control

@onready var bar := $TimerBar
@onready var icon := $TimerBar/BonusIcon
@onready var player = $"../../Player"

func _ready() -> void:
	hide()
	bar.max_value = 10
	bar.value = 10
	player.connect('bonus_second_passed', _on_bonus_second_passed)
	player.connect('got_bonus', _on_got_bonus)


func _on_bonus_second_passed():
	print("second passed")
	bar.value -= 1
	if bar.value <= 0:
		hide()

func _on_got_bonus(iconPath):
	print("got bonus")
	bar.value = 10
	icon.texture = load(iconPath)
	show()

func _process(delta: float) -> void:
	pass
