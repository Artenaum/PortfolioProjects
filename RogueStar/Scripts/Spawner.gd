extends Node2D

signal boss_appeared
signal battle_won
signal run_won
#signal game_paused

var preloadedEnemies := [
	preload("res://Scenes/Enemies/Common/shooter_enemy.tscn")
]

@onready var spawnTimer := $SpawnTimer
@onready var asteroidTimer := $AsteroidTimer
@onready var startPoints := $StartPoints
@onready var endPoints := $EndPoints

var asteroid := preload("res://Scenes/Enemies/asteroid.tscn")

var nextSpawnTime := 3.0
var numEnemiesInBatch: int
var currentBatchNumber: int = -1
var enemies: Dictionary
var enemiesPaths: Dictionary

var commonEnemies: Dictionary
var miniBosses: Dictionary
var bosses: Dictionary

var enemyOrder: Array

var testSubject = "boss_1"
var testMode

var musicPlayer

@export var asterMinTime = 30.0
@export var asterMaxTime = 60.0

func load_system():
	if not FileAccess.file_exists("user://savesystem.save"):
		return

	var saveSystem = FileAccess.open("user://savesystem.save", FileAccess.READ)

	while saveSystem.get_position() < saveSystem.get_length():
		var jsonString = saveSystem.get_line()
		var json = JSON.new()
		var parseResult = json.parse(jsonString)

		if not parseResult == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", jsonString, " at line ", json.get_error_line())
			continue

		enemies = json.get_data()

func generate_start_and_end_points():
	var offset = -300.0

	for start_point in startPoints.get_children():
		start_point.position.x = startPoints.position.x
		start_point.position.y = startPoints.position.y + offset
		offset += 100.0

	offset = -300.0

	for end_point in endPoints.get_children():
		end_point.position.x = endPoints.position.x
		end_point.position.y = endPoints.position.y + offset
		offset += 100.0

func _ready() -> void:
	randomize()
	var viewRect := get_viewport_rect()
	global_position.x = viewRect.end.x + 300.0
	global_position.y = viewRect.end.y / 2
	
	generate_start_and_end_points()
	
	load_system()
	
	for i in enemies:
		var loadString: String = "res://Scenes/Enemies/"

		if "enemy" in i:
			loadString = "".join([loadString, "Common/", i, ".tscn"])
			commonEnemies[i] = enemies.get(i)
			print("commonEnemies[i] = ")
			print(commonEnemies[i])
		elif "mini" in i:
			loadString = "".join([loadString, "MiniBosses/", i, ".tscn"])
			miniBosses[i] = enemies.get(i)
			print("miniBosses[i] = ")
			print(miniBosses[i])
		elif "boss" in i:
			loadString = "".join([loadString, "Bosses/", i, ".tscn"])
			bosses[i] = enemies.get(i)
			print("bosses[i] = ")
			print(bosses[i])
		enemiesPaths[i] = loadString
	
	order_enemies()
	
	for i in enemyOrder:
		print(i)
	
	spawnTimer.start(nextSpawnTime)
	asteroidTimer.start(randf_range(asterMinTime, asterMaxTime))
	
	musicPlayer = AudioStreamPlayer.new()
	musicPlayer.bus = &"Music Bus"
	musicPlayer.connect("finished", _on_music_player_finished)
	add_child(musicPlayer)
	musicPlayer.stream = preload("res://Sounds/Music/Ludum Dare 30 - Track 9.wav")
	musicPlayer.play()

func _on_music_player_finished():
	musicPlayer.play()

func get_from_dictionary(dictionary: Dictionary, id: int):
	var _name: String

	if dictionary.values()[id] == 0:
		dictionary.erase(dictionary.keys()[id])
		return ""
	else:
		_name = dictionary.keys()[id]
		dictionary[dictionary.keys()[id]] = dictionary.values()[id] - 1
		return _name

func order_enemies():
	var remainingEnemiesToOrder = 0
	var remainingMiniBossesToOrder = 0
	var miniBossLocation: int = 0
	var returnedString: String
	
	var enemiesSum: int = 0
	var minisSum: int = 0
	var bossesSum: int = 0
	
	for i in commonEnemies:
		enemiesSum += commonEnemies.get(i)
	for i in miniBosses:
		minisSum += miniBosses.get(i)
	for i in bosses:
		bossesSum += bosses.get(i)
	
	enemyOrder.resize(enemiesSum + minisSum + bossesSum)
	enemyOrder.fill(null)
	
	for enemy in commonEnemies:
		remainingEnemiesToOrder += commonEnemies.get(enemy)
	for miniBoss in miniBosses:
		remainingMiniBossesToOrder += miniBosses.get(miniBoss)
	
	for i in range(enemyOrder.size()):
		returnedString = ""
		match i:
			0:
				if not remainingEnemiesToOrder == 0:
					while returnedString == "":
						print("Returned null")
						returnedString = get_from_dictionary(commonEnemies, randi() % commonEnemies.size())
						
					remainingEnemiesToOrder -= 1
					enemyOrder[i] = returnedString
					print("enemyOrder[i] =")
					print(enemyOrder[i])
				elif not remainingMiniBossesToOrder == 0:
					while returnedString == "":
						print("Returned null")
						returnedString = get_from_dictionary(miniBosses, randi() % miniBosses.size())
					remainingMiniBossesToOrder -= 1
					enemyOrder[i] = returnedString
					print("enemyOrder[i] =")
					print(enemyOrder[i])
				else:
					enemyOrder[i] = get_from_dictionary(bosses, 0)
					print("enemyOrder[i] =")
					print(enemyOrder[i])
					return
			1:
				if not remainingEnemiesToOrder == 0:
					while returnedString == "":
						print("Returned null")
						returnedString = get_from_dictionary(commonEnemies, randi() % commonEnemies.size())
					remainingEnemiesToOrder -= 1
					enemyOrder[i] = returnedString
					print("enemyOrder[i] =")
					print(enemyOrder[i])
				elif not remainingMiniBossesToOrder == 0:
					while returnedString == "":
						print("Returned null")
						returnedString = get_from_dictionary(miniBosses, randi() % miniBosses.size())
					remainingMiniBossesToOrder -= 1
					enemyOrder[i] = returnedString
					print("enemyOrder[i] =")
					print(enemyOrder[i])
				else:
					enemyOrder[i] = get_from_dictionary(bosses, 0)
					print("enemyOrder[i] =")
					print(enemyOrder[i])
					return
			2:
				if not remainingMiniBossesToOrder == 0 and randf() < 0.33:
					while returnedString == "":
						print("Returned null")
						returnedString = get_from_dictionary(miniBosses, randi() % miniBosses.size())
					remainingMiniBossesToOrder -= 1
					miniBossLocation = i
					enemyOrder[i] = returnedString
					print("enemyOrder[i] =")
					print(enemyOrder[i])
				elif not remainingEnemiesToOrder == 0:
					while returnedString == "":
						print("Returned null")
						returnedString = get_from_dictionary(commonEnemies, randi() % commonEnemies.size())
					remainingEnemiesToOrder -= 1
					enemyOrder[i] = returnedString
					print("enemyOrder[i] =")
					print(enemyOrder[i])
				elif not remainingMiniBossesToOrder == 0:
					while returnedString == "":
						print("Returned null")
						returnedString = get_from_dictionary(miniBosses, randi() % miniBosses.size())
					remainingMiniBossesToOrder -= 1
					miniBossLocation = i
					enemyOrder[i] = returnedString
					print("enemyOrder[i] =")
					print(enemyOrder[i])
				else:
					enemyOrder[i] = get_from_dictionary(bosses, 0)
					print("enemyOrder[i] =")
					print(enemyOrder[i])
					return
			3:
				if not remainingMiniBossesToOrder == 0 and randf() < 0.66:
					while returnedString == "":
						print("Returned null")
						returnedString = get_from_dictionary(miniBosses, randi() % miniBosses.size())
					remainingMiniBossesToOrder -= 1
					miniBossLocation = i
					enemyOrder[i] = returnedString
					print("enemyOrder[i] =")
					print(enemyOrder[i])
				elif not remainingEnemiesToOrder == 0:
					while returnedString == "":
						print("Returned null")
						returnedString = get_from_dictionary(commonEnemies, randi() % commonEnemies.size())
					remainingEnemiesToOrder -= 1
					enemyOrder[i] = returnedString
					print("enemyOrder[i] =")
					print(enemyOrder[i])
				elif not  remainingMiniBossesToOrder == 0:
					while returnedString == "":
						print("Returned null")
						returnedString = get_from_dictionary(miniBosses, randi() % miniBosses.size())
					remainingMiniBossesToOrder -= 1
					miniBossLocation = i
					enemyOrder[i] = returnedString
					print("enemyOrder[i] =")
					print(enemyOrder[i])
				else:
					enemyOrder[i] = get_from_dictionary(bosses, 0)
					print("enemyOrder[i] =")
					print(enemyOrder[i])
					return
			_:
				if not remainingMiniBossesToOrder == 0:
					while returnedString == "":
						print("Returned null")
						returnedString = get_from_dictionary(miniBosses, randi() % miniBosses.size())
					remainingMiniBossesToOrder -= 1
					miniBossLocation = i
					enemyOrder[i] = returnedString
					print("enemyOrder[i] =")
					print(enemyOrder[i])
				elif not remainingEnemiesToOrder == 0:
					while returnedString == "":
						print("Returned null")
						returnedString = get_from_dictionary(commonEnemies, randi() % commonEnemies.size())
					remainingEnemiesToOrder -= 1
					enemyOrder[i] = returnedString
					print("enemyOrder[i] =")
					print(enemyOrder[i])
				else:
					enemyOrder[i] = get_from_dictionary(bosses, 0)
					print("enemyOrder[i] =")
					print(enemyOrder[i])
					return

func _on_enemy_death():
	numEnemiesInBatch -= 1
	print("Enemies in batch: " + str(numEnemiesInBatch))

	if numEnemiesInBatch <= 0:
		if currentBatchNumber == enemyOrder.size() - 1:
			if enemyOrder[currentBatchNumber] == "boss_5":
				print("Game won!")
				game_won(1)
			else:
				print("Battle won!")
				game_won(0)
		else:
			spawnTimer.start(nextSpawnTime)

func _on_enemy_flew_past():
	numEnemiesInBatch -= 1
	print("Enemies in batch: " + str(numEnemiesInBatch))
	if numEnemiesInBatch <= 0:
		if currentBatchNumber == enemyOrder.size() - 1:
			print("Battle won!")
			game_won(1)
		else:
			spawnTimer.start(nextSpawnTime)

func game_won(finalBoss: bool):
	if not finalBoss:
		var wonTimer = Timer.new()
		add_child(wonTimer)
		wonTimer.one_shot = true
		wonTimer.timeout.connect(self._on_won_timer_timeout)
		wonTimer.start(3)
	else:
		var runWonTimer = Timer.new()
		add_child(runWonTimer)
		runWonTimer.one_shot = true
		runWonTimer.timeout.connect(self._on_run_won_timer_timeout)
		runWonTimer.start(3)

func _on_won_timer_timeout():
	battle_won.emit()

func _on_run_won_timer_timeout():
	run_won.emit()

func _on_spawn_timer_timeout() -> void:
	currentBatchNumber += 1
	print("Current batch number: " + str(currentBatchNumber))
	print("Enemy order size: " + str(enemyOrder.size()))

	print(enemiesPaths[enemyOrder[currentBatchNumber]])

	if "enemy" in enemyOrder[currentBatchNumber]:
		print("Spawning enemy...")
		var enemy = load(enemiesPaths[enemyOrder[currentBatchNumber]])
		numEnemiesInBatch = 5
		var newPosition = Vector2(0, 0)
		newPosition.x = 0
		newPosition.y = 400.0

		for i in numEnemiesInBatch:
			var enemyInstance = enemy.instantiate()
			enemyInstance.connect('dead', _on_enemy_death)
			enemyInstance.connect('flewPast', _on_enemy_flew_past)
			enemyInstance.global_position = global_position + newPosition
			enemyInstance.global_rotation = deg_to_rad(-90)
			enemyInstance.scale.x = 0.3
			enemyInstance.scale.y = 0.3
			get_tree().current_scene.add_child(enemyInstance)
			print("Spawned enemy")
			newPosition.y -= 200.0
		
	if "mini" in enemyOrder[currentBatchNumber]:
		print("Spawning mini...")
		var enemy = load(enemiesPaths[enemyOrder[currentBatchNumber]])
		numEnemiesInBatch = 2
		var newPosition = Vector2(0, 0)
		newPosition.x = 0
		newPosition.y = -300.0

		for i in numEnemiesInBatch:
			var enemyInstance = enemy.instantiate()
			enemyInstance.connect('dead', _on_enemy_death)
			enemyInstance.connect('flewPast', _on_enemy_flew_past)
			enemyInstance.global_position = global_position + newPosition
			enemyInstance.global_rotation = deg_to_rad(-90)
			enemyInstance.scale.x = 0.5
			enemyInstance.scale.y = 0.5
			get_tree().current_scene.add_child(enemyInstance)
			print("Spawned mini")
			newPosition.y += 600.0
		
	if "boss" in enemyOrder[currentBatchNumber]:
		print("Spawning boss...")
		var enemy = load(enemiesPaths[enemyOrder[currentBatchNumber]])
		numEnemiesInBatch = 1
		var enemyInstance = enemy.instantiate()
		enemyInstance.connect('dead', _on_enemy_death)
		enemyInstance.connect('flewPast', _on_enemy_flew_past)
		enemyInstance.global_position = global_position
		enemyInstance.global_rotation = deg_to_rad(-90)
		enemyInstance.scale.x = 1
		enemyInstance.scale.y = 1
		get_tree().current_scene.add_child(enemyInstance)
		emit_signal("boss_appeared", enemyInstance)
		print("Spawned boss")


func _on_asteroid_timer_timeout() -> void:
	var asteroidInstance = asteroid.instantiate()
	var start_point = startPoints.get_child(randi_range(0, startPoints.get_child_count() - 1))
	asteroidInstance.global_position = start_point.global_position
	asteroidInstance.global_rotation = deg_to_rad(randf_range(0.0, 359.0))
	asteroidInstance.scale.x = 0.5
	asteroidInstance.scale.y = 0.5
	get_tree().current_scene.add_child(asteroidInstance)
	asteroidTimer.start(randf_range(asterMinTime, asterMaxTime))
