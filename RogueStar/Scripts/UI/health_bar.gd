extends Panel

@onready var numberLabel = $ProgressBar/Label
@onready var bar = $ProgressBar
@onready var player = $"../../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_max_health = player.maxHealth
	var player_current_health = player.health
	bar.max_value = player_max_health
	player.connect('health_changed', _on_player_health_changed)
	update_health(player_current_health)

func _on_player_health_changed(player_health):
	update_health(player_health)

func update_health(new_value):
	numberLabel.text = str(new_value) + " / 10"
	bar.value = new_value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
