extends Boss

@onready var fireTimer := $FireTimer
@onready var attack1Timer := $Attack1Timer
@onready var attack2Timer := $Attack2Timer
@onready var attack2Timer2 := $Attack2Timer2
@onready var attack3Timer := $Attack3Timer

@export var fireRate := 3.0
@export var attack1FireRate := 0.5
@export var attack2FireRate := 0.01
@export var attack2FireRate2 := 0.3
@export var attack3FireRate := 0.5

var boss_name: String = "Dominator"

var centerAngle: float
var centerAngle2: float
var random = RandomNumberGenerator.new()
var randomAttack: int = 0
var attackFinished: bool = true
var iterator: int = 0
var iterator2: int = 0
var upperRocket: bool = true
var secondPhase: bool = false

func _ready() -> void:
	super()
	random.randomize()
	centerAngle = -50.0
	centerAngle2 = 0
	randomAttack = random.randi() % 3


func _process(delta: float) -> void:
	if health <= maxHealth / 2:
		secondPhase = true
		fireRate = 1.0
		attack1FireRate = 0.4
		attack2FireRate2 = 0.2
		attack3FireRate = 0.4
	if fireTimer.is_stopped() && reached_position:
		#random.randomize()
		#print(randomAttack)
		match randomAttack:
			0:
				if iterator <= 9:
					if attack1Timer.is_stopped():
						attack0(secondPhase)
						centerAngle += 10
						iterator += 1
						attack1Timer.start(attack1FireRate)
				else:
					centerAngle = -50.0
					iterator = 0
					randomAttack = random.randi() % 3
					fireTimer.start(fireRate)
			#1: 
			#	if iterator <= 7:
			#		if attack2Timer.is_stopped():
			#			attack1(upperRocket)
			#			upperRocket = !upperRocket
			#			iterator += 1
			#			attack2Timer.start(attack2FireRate)
			#	else:
			#		upperRocket = true
			#		iterator = 0
			#		randomAttack = random.randi() % 3
			#		fireTimer.start(fireRate)
			1: 
				if iterator2 <= 2:
					if attack2Timer2.is_stopped():
						if iterator <= 10:
							if attack2Timer.is_stopped():
								attack1()
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
			2:
				attack2(secondPhase)
				randomAttack = random.randi() % 3
				fireTimer.start(fireRate)
			_: print("Random attack error")


func attack0(_secondPhase: bool):
	if not _secondPhase:
		fire_attack(0, centerAngle - 5)
		fire_attack(0, centerAngle)
		fire_attack(0, centerAngle + 5)
		fire_attack(1, -centerAngle - 5)
		fire_attack(1, -centerAngle)
		fire_attack(1, -centerAngle + 5)
	else:
		fire_attack(0, centerAngle - 10)
		fire_attack(0, centerAngle - 5)
		fire_attack(0, centerAngle)
		fire_attack(0, centerAngle + 5)
		fire_attack(0, centerAngle + 10)
		fire_attack(1, -centerAngle - 10)
		fire_attack(1, -centerAngle - 5)
		fire_attack(1, -centerAngle)
		fire_attack(1, -centerAngle + 5)
		fire_attack(1, -centerAngle + 10)

func attack1():
	fire_attack(2, 0)

func attack2(_secondPhase: bool):
	if not _secondPhase:
		fire_attack(3, centerAngle2 - 5)
		fire_attack(3, centerAngle2)
		fire_attack(3, centerAngle2 + 5)
		fire_attack(4, centerAngle2 - 5)
		fire_attack(4, centerAngle2)
		fire_attack(4, centerAngle2 + 5)
	else:
		fire_attack(3, centerAngle2 - 10)
		fire_attack(3, centerAngle2)
		fire_attack(3, centerAngle2 + 10)
		fire_attack(4, centerAngle2 - 10)
		fire_attack(4, centerAngle2)
		fire_attack(4, centerAngle2 + 10)
