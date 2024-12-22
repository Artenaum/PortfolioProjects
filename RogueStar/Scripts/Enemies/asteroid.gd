extends Enemy

@onready var endPoints = $"../Spawner/EndPoints"

@export var bonuses: Array[PackedScene]

var end_point
var rotationSpeed

func _ready() -> void:
	super()
	rotationSpeed = randf_range(-10.0, 10.0)
	end_point = endPoints.get_child(randi_range(0, endPoints.get_child_count() - 1))

func _process(delta: float) -> void:
	position = position.move_toward(end_point.position, speed * delta)
	rotation += rotationSpeed * delta
	if position.x < -20.0:
		queue_free()
	if playerInArea != null:
		playerInArea.take_damage(2)
		queue_free()

func _physics_process(delta: float) -> void:
	pass

func take_damage(amount: int):
	$Sprite2D.material.set_shader_parameter("redden", true)
	await get_tree().create_timer(0.15).timeout
	$Sprite2D.material.set_shader_parameter("redden", false)
	
	health -= amount
	if health <= 0:
		var bonus = bonuses[randi_range(0, bonuses.size() - 1)].instantiate()
		bonus.global_position = global_position
		get_tree().current_scene.add_child(bonus)
		queue_free()
