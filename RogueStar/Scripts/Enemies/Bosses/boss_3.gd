extends Boss

@onready var fireTimer := $FireTimer
@onready var attack1Timer := $Attack1Timer
@onready var attack1Timer2 := $Attack1Timer2
@onready var attack2Timer := $Attack2Timer
@onready var attack2Timer2 := $Attack2Timer2
@onready var attack3Timer := $Attack3Timer

@onready var player := get_parent().get_node("Player")

@export var fireRate := 3.0
@export var attack1FireRate := 0.3
@export var attack1FireRate2 := 0.5
@export var attack2FireRate := 0.01
@export var attack2FireRate2 := 0.3
@export var attack3FireRate := 0.3

var boss_name: String = "Annigilator"

var directionToPlayer: float
var centerAngle: float
var random = RandomNumberGenerator.new()
var randomAttack: int = 0
var attackFinished: bool = true
var iterator: int = 0
var iterator2: int = 0
var upperRocket: bool = true
var upperLaser: bool = true
var secondPhase: bool = false

func _ready() -> void:
	super()
	random.randomize()
	centerAngle = -50.0
	randomAttack = random.randi() % 3


func _process(delta: float) -> void:
	if health <= maxHealth / 2:
		secondPhase = true
		fireRate = 1.0
		attack1FireRate2 = 0.4
		attack2FireRate2 = 0.2
	if fireTimer.is_stopped() && reached_position && player != null:
		#random.randomize()
		#print(randomAttack)
		match randomAttack:
			0:
				if iterator2 <= 1:
					if attack1Timer2.is_stopped():
						if iterator <= 2:
							if attack1Timer.is_stopped():
								directionToPlayer = rad_to_deg((position - player.position).angle())
								attack0(secondPhase)
								iterator += 1
								attack1Timer.start(attack1FireRate)
						else:
							iterator = 0
							iterator2 += 1
							attack1Timer2.start(attack1FireRate2)
				else:
					iterator2 = 0
					randomAttack = random.randi() % 3
					fireTimer.start(fireRate)
			1: 
				if iterator2 <= 9:
					if attack2Timer2.is_stopped():
						if iterator <= 10:
							if attack2Timer.is_stopped():
								attack1(upperLaser)
								#upperLaser = !upperLaser
								iterator += 1
								attack2Timer.start(attack2FireRate)
						else:
							upperLaser = !upperLaser
							iterator = 0
							iterator2 += 1
							attack2Timer2.start(attack2FireRate2)
				else:
					upperRocket = true
					iterator2 = 0
					randomAttack = random.randi() % 3
					fireTimer.start(fireRate)
			2: 
				if iterator <= 1:
					if attack3Timer.is_stopped():
						directionToPlayer = rad_to_deg((position - player.position).angle())
						attack2()
						iterator += 1
						attack3Timer.start(attack3FireRate)
				else:
					iterator = 0
					randomAttack = random.randi() % 3
					fireTimer.start(fireRate)
			_: print("Random attack error")


func attack0(_secondPhase: bool):
	if not _secondPhase:
		fire_attack(0, directionToPlayer - 5)
		fire_attack(0, directionToPlayer)
		fire_attack(0, directionToPlayer + 5)
	else:
		fire_attack(0, directionToPlayer - 10)
		fire_attack(0, directionToPlayer - 5)
		fire_attack(0, directionToPlayer)
		fire_attack(0, directionToPlayer + 5)
		fire_attack(0, directionToPlayer + 10)

func attack1(upperLaser: bool):
	if upperLaser:
		fire_attack(1, 0)
	else:
		fire_attack(2, 0)

func attack2():
	fire_attack(3, directionToPlayer)
