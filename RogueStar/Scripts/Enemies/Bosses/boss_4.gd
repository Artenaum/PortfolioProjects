extends Boss

@onready var fireTimer := $FireTimer
@onready var attack1Timer := $Attack1Timer
@onready var attack2Timer := $Attack2Timer
@onready var attack2Timer2 := $Attack2Timer2

@onready var player := get_node("/root/Battle Mode/Player")

@export var fireRate := 3.0
@export var attack1FireRate := 0.02
@export var attack2FireRate := 0.01
@export var attack2FireRate2 := 0.3

var boss_name: String = "Collector"

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
	centerAngle = -90.0
	randomAttack = random.randi() % 3


func _process(delta: float) -> void:
	if health <= maxHealth / 2:
		secondPhase = true
		fireRate = 1.0
		attack1FireRate = 0.01
		attack2FireRate2 = 0.2
	if fireTimer.is_stopped() && reached_position:
		match randomAttack:
			0:
				if iterator <= 129:
					if attack1Timer.is_stopped():
						attack0()
						centerAngle -= 8
						iterator += 1
						attack1Timer.start(attack1FireRate)
				else:
					iterator = 0
					centerAngle = 90.0
					randomAttack = random.randi() % 3
					fireTimer.start(fireRate)
			1:
				attack1(secondPhase)
				randomAttack = random.randi() % 3
				fireTimer.start(fireRate)
			2:
				if iterator2 <= 2:
					if attack2Timer2.is_stopped():
						if iterator <= 10:
							if attack2Timer.is_stopped():
								attack2()
								iterator += 1
								attack2Timer.start(attack2FireRate)
						else:
							iterator = 0
							iterator2 += 1
							attack2Timer2.start(attack2FireRate2)
				else:
					iterator2 = 0
					randomAttack = random.randi() % 3
					fireTimer.start(fireRate)
			_: print("Random attack error")


func attack0():
	fire_attack(0, centerAngle)

func attack1(_secondPhase: bool):
	if not _secondPhase:
		fire_attack(1, 0)
		fire_attack(2, 0)
		fire_attack(1, -3)
		fire_attack(2, -3)
		fire_attack(1, 3)
		fire_attack(2, 3)
	else:
		fire_attack(1, 0)
		fire_attack(2, 0)
		fire_attack(1, -10)
		fire_attack(2, -10)
		fire_attack(1, 10)
		fire_attack(2, 10)

func attack2():
	fire_attack(3, 0)
	fire_attack(4, 0)
