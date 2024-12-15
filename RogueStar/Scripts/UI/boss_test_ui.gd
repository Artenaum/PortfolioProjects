extends Control

@onready var bar = $HealthBarBoss/ProgressBar
@onready var nameLabel = $BossName

@onready var boss = $"../../Boss5"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(boss.name)
	hide()
	if boss != null:
		show()
		nameLabel.text = boss.boss_name
		var boss_max_health = boss.maxHealth
		bar.max_value = boss_max_health
		boss.connect('health_changed', _on_boss_health_changed)
		update_health(boss_max_health)


func _on_boss_health_changed(boss_health):
	update_health(boss_health)

func update_health(new_value):
	bar.value = new_value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
