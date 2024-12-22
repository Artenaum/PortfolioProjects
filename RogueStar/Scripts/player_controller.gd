extends CharacterBody2D
class_name Player

signal died
signal health_changed
signal bonus_second_passed
signal got_bonus

const ACCELERATION = 10000
const MAX_SPEED = 1000
const FRICTION = 10000
const WHITEN_DURATION = 0.15

var bonusSpeedMultiplier = 1.5
var screen_size

var playerStats = {}

@onready var projectile_spawnpoint_1 := $ProjectileSpawnPoint1
@onready var projectile_spawnpoint_2 := $ProjectileSpawnPoint2
@onready var invincibilityTimer := $InvincibilityTimer
@onready var blinker := $Blinker
@onready var bonusTimer := $BonusTimer
@onready var secondsTimer := $SecondsTimer

@export var health: int = 10
@export var maxHealth: int = 10
@export var invincibilityPeriod: float = 0.5

@export var gun_scene: PackedScene
@export var whitenMaterial: ShaderMaterial

enum Bonus {
	NONE,
	SPEED,
	ATTACK,
	HEALTH
}

var current_bonus: int
var bonusTimeLeft: float

func _ready():
	load_player_stats()
	current_bonus = Bonus.NONE
	health = playerStats.health
	screen_size = get_viewport_rect().size
	
	# initialize player guns
	var gun1 = gun_scene.instantiate()
	var gun2 = gun_scene.instantiate()
	gun1.position = projectile_spawnpoint_1.position
	gun2.position = projectile_spawnpoint_2.position
	add_child(gun1)
	add_child(gun2)


func _physics_process(delta: float) -> void:
	move(delta)
	
	if Input.is_action_pressed("shoot_weapon_1"):
		if current_bonus == Bonus.ATTACK:
			shoot(1)
		else:
			shoot(0)


func move(delta: float):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("move_player_right") - Input.get_action_strength("move_player_left")
	input_vector.y = Input.get_action_strength("move_player_down") - Input.get_action_strength("move_player_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if current_bonus == Bonus.SPEED:
			velocity = velocity.move_toward(input_vector * MAX_SPEED * bonusSpeedMultiplier, ACCELERATION * delta)
		else:
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_collide(velocity * delta)
	
	position.x = clamp(position.x, 100, screen_size.x - 100)
	position.y = clamp(position.y, 100, screen_size.y - 100)


func shoot(_buffed: bool):
	for child in get_children():
		if child.has_method("shoot"):
			child.shoot(_buffed)

func load_player_stats():
	if not FileAccess.file_exists("user://saveplayerstats.save"):
		return

	var saveSystem = FileAccess.open("user://saveplayerstats.save", FileAccess.READ)

	while saveSystem.get_position() < saveSystem.get_length():
		var jsonString = saveSystem.get_line()
		var json = JSON.new()
		var parseResult = json.parse(jsonString)

		if not parseResult == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", jsonString, " at line ", json.get_error_line())
			continue

		playerStats = json.get_data()

func take_damage(amount: int):
	if !invincibilityTimer.is_stopped():
		return
	
	invincibilityTimer.start(invincibilityPeriod)
	
	whitenMaterial.set_shader_parameter("whiten", true)
	await get_tree().create_timer(WHITEN_DURATION).timeout
	whitenMaterial.set_shader_parameter("whiten", false)
	
	blinker.start_blinking(self, invincibilityPeriod)
	
	health -= amount
	print("Player health = %s" % health)
	emit_signal("health_changed", health)

	if (health <= 0):
		died.emit()
		queue_free()

func _on_bonus_timer_timeout() -> void:
	current_bonus = Bonus.NONE

func _on_bonus_collected(bonusType) -> void:
	match bonusType:
		"Speed":
			print("Speed")
			current_bonus = Bonus.SPEED
			bonusTimer.start(10.0)
			bonusTimeLeft = 10.0
			secondsTimer.start(1.0)
			got_bonus.emit("res://Graphics/Sprites/Icons/Speed Icon.png")
		"Attack":
			print("Attack")
			current_bonus = Bonus.ATTACK
			bonusTimer.start(10.0)
			bonusTimeLeft = 10.0
			secondsTimer.start(1.0)
			got_bonus.emit("res://Graphics/Sprites/Icons/Attack Icon.png")
		_:
			print("Else")
			current_bonus = Bonus.NONE


func _on_seconds_timer_timeout() -> void:
	bonus_second_passed.emit()
	bonusTimeLeft -= 1.0
	print("Time left: %s" %bonusTimeLeft)

	if not bonusTimeLeft <= 0:
		secondsTimer.start(1.0)
