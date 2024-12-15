extends Area2D
class_name Enemy

signal dead
signal flewPast
signal health_changed

@onready var firingPositions := $FiringPositions

@export var bullet_scene: PackedScene

@export var isCommon: bool = true
@export var speed: float = 100.0
@export var maxHealth: int
@export var health: int = 0

@export var redMaterial: ShaderMaterial

var playerInArea: Player = null
var reached_position: bool = false
var audioFiles = []

func _ready() -> void:
	$Sprite2D.material = redMaterial.duplicate()
	health = maxHealth

func _process(delta: float) -> void:
	if position.x < -20.0:
		flewPast.emit()
		queue_free()
	if playerInArea != null:
		playerInArea.take_damage(1)


func _physics_process(delta: float) -> void:
	shoot_check()
	move_forward(delta)


func shoot_check():
	if position.x < get_viewport_rect().size.x - 200.0:
		reached_position = true
	elif position.x <= 600.0:
		reached_position = false


func move_forward(delta):
	if isCommon:
		position.x -= speed * delta
		if position.x <= -200.0:
			#position.x = get_viewport_rect().size.x + 200.0
			dead.emit()
			queue_free()


func fire():
	for child in firingPositions.get_children():
		var bullet := bullet_scene.instantiate()
		bullet.global_position = child.global_position
		var direction = -child.global_rotation - PI / 2
		bullet.global_rotation = direction
		get_tree().current_scene.add_child(bullet)


func take_damage(amount: int):
	$Sprite2D.material.set_shader_parameter("redden", true)
	await get_tree().create_timer(0.15).timeout
	$Sprite2D.material.set_shader_parameter("redden", false)
	if health > 0:
		health -= amount
		emit_signal("health_changed", health)
	if health <= 0:
		print("enemy dead")
		dead.emit()
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		playerInArea = area.get_parent()


func _on_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		playerInArea = null
