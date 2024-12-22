extends Boss

@onready var fireTimer := $FireTimer
@onready var attack1Timer := $Attack1Timer
@onready var attack2Timer := $Attack2Timer
@onready var attack3Timer := $Attack3Timer

@export var fireRate := 3.0
@export var attack1FireRate := 0.3
@export var attack2FireRate := 0.02
@export var attack3FireRate := 0.01

var centerAngle: float
var antiCenterAngle: float
var random = RandomNumberGenerator.new()
var randomAttack: int = 0
var attackFinished: bool = true
var iterator: int = 0
var upperRocket: bool = true
var secondPhase: bool = true

var boss_name: String = "Destructor"

func _ready() -> void:
	super()
	random.randomize()
	centerAngle = 90.0
	antiCenterAngle = -100.0
	randomAttack = random.randi() % 3


func _process(delta: float) -> void:
	if health <= maxHealth / 2:
		secondPhase = true
		fireRate = 1.0
		attack1FireRate = 0.2
		attack2FireRate = 0.01
	if fireTimer.is_stopped() && reached_position:
		match randomAttack:
			0:
				if iterator <= 7:
					if attack1Timer.is_stopped():
						attack0(secondPhase)
						iterator += 1
						attack1Timer.start(attack1FireRate)
				else:
					iterator = 0
					randomAttack = random.randi() % 3
					fireTimer.start(fireRate)
			1:
				if iterator <= 129:
					if attack2Timer.is_stopped():
						attack1()
						centerAngle += 8
						antiCenterAngle -= 8
						iterator += 1
						attack2Timer.start(attack2FireRate)
				else:
					iterator = 0
					centerAngle = 90.0
					antiCenterAngle = -100.0
					randomAttack = random.randi() % 3
					fireTimer.start(fireRate)
			2:
				if iterator <= 99:
					if attack3Timer.is_stopped():
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
		fire_attack(0, 0)
		fire_attack(0, -5)
		fire_attack(1, 0)
		fire_attack(1, 5)
	else:
		fire_attack(0, 0)
		fire_attack(0, -10)
		fire_attack(1, 0)
		fire_attack(1, 10)

func attack1():
	fire_attack(2, centerAngle)
	fire_attack(2, antiCenterAngle)

func attack2():
	fire_attack(3, 0)

