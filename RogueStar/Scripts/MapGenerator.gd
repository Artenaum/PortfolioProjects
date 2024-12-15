extends Node2D

signal map_ready

@export var system_scene: PackedScene

var random = RandomNumberGenerator.new()

var possibleEnemies = {
	"Common": [
		#"bouncer_enemy", 
		"double_shooter_enemy", 
		"fast_enemy", 
		"shooter_enemy",
		#"sinusoid_double_shooter_enemy",
		],
	"MiniBosses": [
		"quad_shot_mini",
		"triple_shot_mini",
	],
	"Bosses": [
		"boss_1",
		"boss_2",
		"boss_3",
		"boss_4",
		"boss_5",
	],
}

var map = {
	"system0": {
		"pos": {
				"x": 200.0,
				"y": 600.0,
			},
		"enemies": {
			
		},
	},
	"system1": {
		"pos": {
			"x": 400.0,
			"y": 200.0,
		},
		"enemies": {
			"boss_1": 1,
			"quad_shot_mini": 1,
			"triple_shot_mini": 2,
			"shooter_enemy": 3,
			"double_shooter_enemy": 2,
		},
	},
	"system2": {
		"pos": {
			"x": 600.0,
			"y": 200.0,
		},
		"enemies": {
			"boss_2": 1,
			"quad_shot_mini": 2,
			"fast_enemy": 3,
			"bouncer_enemy": 2,
			"sinusoid_double_shooter_enemy": 1,
		},
	},
	"system3": {
		"pos": {
			"x": 800.0,
			"y": 200.0,
		},
		"enemies": {
			
		},
	},
	"system4": {
		"pos": {
			"x": 1000.0,
			"y": 200.0,
		},
		"enemies": {
			
		},
	},
	"system5": {
		"pos": {
			"x": 1200.0,
			"y": 200.0,
		},
		"enemies": {
			
		},
	},
	"system6": {
		"pos": {
			"x": 1400.0,
			"y": 200.0,
		},
		"enemies": {
			
		},
	},
	"system7": {
		"pos": {
			"x": 1600.0,
			"y": 200.0,
		},
		"enemies": {
			
		},
	},
	"system8": {
		"pos": {
			"x": 400.0,
			"y": 400.0,
		},
		"enemies": {
			
		},
	},
	"system9": {
		"pos": {
			"x": 600.0,
			"y": 400.0,
		},
		"enemies": {
			
		},
	},
	"system10": {
		"pos": {
			"x": 800.0,
			"y": 400.0,
		},
		"enemies": {
			
		},
	},
	"system11": {
		"pos": {
			"x": 1000.0,
			"y": 400.0,
		},
		"enemies": {
			
		},
	},
	"system12": {
		"pos": {
			"x": 1200.0,
			"y": 400.0,
		},
		"enemies": {
			
		},
	},
	"system13": {
		"pos": {
			"x": 1400.0,
			"y": 400.0,
		},
		"enemies": {
			
		},
	},
	"system14": {
		"pos": {
			"x": 1600.0,
			"y": 400.0,
		},
		"enemies": {
			
		},
	},
	"system15": {
		"pos": {
			"x": 400.0,
			"y": 600.0,
		},
		"enemies": {
			
		},
	},
	"system16": {
		"pos": {
			"x": 600.0,
			"y": 600.0,
		},
		"enemies": {
			
		},
	},
	"system17": {
		"pos": {
			"x": 800.0,
			"y": 600.0,
		},
		"enemies": {
			
		},
	},
	"system18": {
		"pos": {
			"x": 1000.0,
			"y": 600.0,
		},
		"enemies": {
			
		},
	},
	"system19": {
		"pos": {
			"x": 1200.0,
			"y": 600.0,
		},
		"enemies": {
			
		},
	},
	"system20": {
		"pos": {
			"x": 1400.0,
			"y": 600.0,
		},
		"enemies": {
			
		},
	},
	"system21": {
		"pos": {
			"x": 1600.0,
			"y": 600.0,
		},
		"enemies": {
			
		},
	},
	"system22": {
		"pos": {
			"x": 400.0,
			"y": 800.0,
		},
		"enemies": {
			
		},
	},
	"system23": {
		"pos": {
			"x": 600.0,
			"y": 800.0,
		},
		"enemies": {
			
		},
	},
	"system24": {
		"pos": {
			"x": 800.0,
			"y": 800.0,
		},
		"enemies": {
			
		},
	},
	"system25": {
		"pos": {
			"x": 1000.0,
			"y": 800.0,
		},
		"enemies": {
			
		},
	},
	"system26": {
		"pos": {
			"x": 1200.0,
			"y": 800.0,
		},
		"enemies": {
			
		},
	},
	"system27": {
		"pos": {
			"x": 1400.0,
			"y": 800.0,
		},
		"enemies": {
			
		},
	},
	"system28": {
		"pos": {
			"x": 1600.0,
			"y": 800.0,
		},
		"enemies": {
			
		},
	},
	"system29": {
		"pos": {
			"x": 1800.0,
			"y": 600.0,
		},
		"enemies": {
			
		},
	},
}

@onready var player := $"../MapPlayer"

var circleCenter = Vector2(0, 0)
var circleRadius = 40.0
var circleColor = Color(1.0, 0.0, 0.0)
var isMapGenerated = false

var musicPlayer

func generate_map():
	for i in range(10):
		for j in range(10):
			var systemName: String = "system" + str((i+1) + (j+1))
			map[systemName]["pos"]["x"] = (i+1) * 100.0
			map[systemName]["pos"]["y"] = (j+1) * 100.0
			map[systemName]["enemies"] = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	load_map_generated()
	if not isMapGenerated:
		for system in map:
			random.randomize()
			var systemInstance := system_scene.instantiate()
			systemInstance.position.x = map.get(system).pos.x + random.randf_range(-90.0, 90.0)
			systemInstance.position.y = map.get(system).pos.y + random.randf_range(-90.0, 90.0)
			map.get(system).pos.x = systemInstance.position.x
			map.get(system).pos.y = systemInstance.position.y
			systemInstance.rotation = random.randf_range(deg_to_rad(0), deg_to_rad(359.0))
			map.get(system)["rotation"] = systemInstance.rotation
			var randomScale = random.randf_range(0.1, 0.2)
			systemInstance.scale.x = randomScale
			systemInstance.scale.y = randomScale
			map.get(system)["scale"] = randomScale
			var randomHue = random.randf_range(0.0, 359.0)
			var colorSaturation = 0.8
			var colorValue = 1.0
			systemInstance.modulate = Color.from_hsv(randomHue, colorSaturation, colorValue)
			map.get(system)["hue"] = randomHue
			#map.get(system)
			#map.get(system)["color"] = systemInstance.modulate
			#systemInstance.modulate = Color(randf_range(0.3, 1.0), randf_range(0.1, 0.5), randf_range(0.3, 1.0))
			systemInstance.starName = system
			systemInstance.connect('clicked', _on_system_click)
		
			if system != "system0" && system != "system29":
				map.get(system).enemies = generate_enemies(0)
			elif system == "system29":
				circleCenter.x = systemInstance.position.x
				circleCenter.y = systemInstance.position.y
				map.get(system).enemies = generate_enemies(1)
				queue_redraw()
			#print(map.get(system))
			get_tree().current_scene.add_child.call_deferred(systemInstance)
		isMapGenerated = true
		save_map_generated(isMapGenerated)
		save_map(map)
		map_ready.emit()
	else:
		load_map()
		print("map loaded")
		await player.player_initialized
		for system in map:
			var systemInstance := system_scene.instantiate()
			systemInstance.position.x = map.get(system).pos.x
			systemInstance.position.y = map.get(system).pos.y
			print("position: " + str(systemInstance.position))
			systemInstance.rotation = map.get(system).rotation
			print("rotation: " + str(systemInstance.rotation))
			systemInstance.scale.x = map.get(system).scale
			systemInstance.scale.y = map.get(system).scale
			print("scale: " + str(systemInstance.scale.x))
			systemInstance.modulate = Color.from_hsv(map.get(system).hue, 0.8, 1.0)
			print("color: " + str(systemInstance.modulate))
			#systemInstance.modulate = str_to_var(map.get(system).color)
			systemInstance.starName = system
			print("starName: " + systemInstance.starName)
			if system == "system29":
				circleCenter.x = systemInstance.position.x
				circleCenter.y = systemInstance.position.y
				queue_redraw()
			if system == player.playerStats.currentSystem:
				print("Player system: " + str(player.playerStats.currentSystem))
				print("currentSystem: " + str(system))
				#map.get(system).enemies = null
				var numOfEnemies = map.get(system).enemies.size()
				for i in range(numOfEnemies):
					map.get(system).enemies.erase(map.get(system).enemies.keys()[0])
			print(map.get(system).enemies)
			systemInstance.connect('clicked', _on_system_click)
			get_tree().current_scene.add_child.call_deferred(systemInstance)
		
	musicPlayer = AudioStreamPlayer.new()
	musicPlayer.bus = &"Music Bus"
	musicPlayer.connect("finished", _on_music_player_finished)
	add_child(musicPlayer)
	musicPlayer.stream = preload("res://Sounds/Music/loading.wav")
	musicPlayer.play()

func _on_music_player_finished():
	musicPlayer.play()

func _draw() -> void:
	draw_arc(circleCenter, circleRadius, 0, 360, 36, circleColor, 5.0)

func generate_enemies(finalBoss: bool) -> Dictionary:
	var enemyList = {} # 
	var bossPresent = false
	var numOfEnemies = random.randi_range(2, 10) # 2, 10
	if not finalBoss:
		for i in numOfEnemies:
				if randf() < 0.1 and not bossPresent:
					var enemyName = possibleEnemies.Bosses[randi() % (possibleEnemies.Bosses.size() - 1)]
					enemyList[enemyName] = 1
					bossPresent = true
				elif randf() < 0.2:
					var enemyName = possibleEnemies.MiniBosses[randi() % possibleEnemies.MiniBosses.size()]
					var enemyNumber = random.randi_range(1, 2) # 1, 2
					enemyList[enemyName] = enemyNumber
				#elif randf() < 0.7:
					#var enemyName = possibleEnemies.Common[randi() % possibleEnemies.Common.size()]
					#var enemyNumber = random.randi_range(1, 3)
					#enemyList[enemyName] = enemyNumber
				else:
					var enemyName = possibleEnemies.Common[randi() % possibleEnemies.Common.size()]
					var enemyNumber = random.randi_range(1, 3) # 1, 3
					enemyList[enemyName] = enemyNumber
	else:
		var enemyName = possibleEnemies.Bosses[possibleEnemies.Bosses.size() - 1]
		enemyList[enemyName] = 1
	return enemyList # 

func save_system(system: Dictionary):
	var saveSystem = FileAccess.open("user://savesystem.save", FileAccess.WRITE)
	var jsonString = JSON.stringify(system)
	saveSystem.store_line(jsonString)

func save_map(_map: Dictionary):
	var saveMap = FileAccess.open("user://savemap.save", FileAccess.WRITE)
	var jsonString = JSON.stringify(_map)
	saveMap.store_line(jsonString)

func save_map_generated(_mapGenerated: bool):
	var saveMap = FileAccess.open("user://savemapgenerated.save", FileAccess.WRITE)
	var jsonString = JSON.stringify(_mapGenerated)
	saveMap.store_line(jsonString)

func save_player_stats(_player_stats: Dictionary):
	var savePlayerStats = FileAccess.open("user://saveplayerstats.save", FileAccess.WRITE)
	var jsonString = JSON.stringify(_player_stats)
	savePlayerStats.store_line(jsonString)

func load_map():
	if not FileAccess.file_exists("user://savemap.save"):
		return
	var saveSystem = FileAccess.open("user://savemap.save", FileAccess.READ)
	while saveSystem.get_position() < saveSystem.get_length():
		var jsonString = saveSystem.get_line()
		var json = JSON.new()
		var parseResult = json.parse(jsonString)
		if not parseResult == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", jsonString, " at line ", json.get_error_line())
			continue # 
		map = json.get_data()

func load_map_generated():
	if not FileAccess.file_exists("user://savemapgenerated.save"):
		isMapGenerated = false
		return
	var saveSystem = FileAccess.open("user://savemapgenerated.save", FileAccess.READ)
	while saveSystem.get_position() < saveSystem.get_length():
		var jsonString = saveSystem.get_line()
		var json = JSON.new()
		var parseResult = json.parse(jsonString)
		if not parseResult == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", jsonString, " at line ", json.get_error_line())
			continue # 
		isMapGenerated = json.get_data()

func _on_system_click(system):
	print("click")
	#var playerPosX: float = map.get($"../MapPlayer".playerStats.get(playerStats.current))
	var playerPosX: float = map.get(player.playerStats.currentSystem).pos.x
	#var playerPosX: float = map.get($"../MapPlayer".currentSystem).pos.x
	var playerPosY: float = map.get(player.playerStats.currentSystem).pos.y
	#var playerPosY: float = map.get($"../MapPlayer".currentSystem).pos.y
	var playerPos = Vector2(playerPosX, playerPosY)
	print("Player pos: " + str(playerPos))
	var systemPosX = map.get(system).pos.x
	var systemPosY = map.get(system).pos.y
	var systemPos = Vector2(systemPosX, systemPosY)
	print("System pos: " + str(systemPos))
	if playerPos.distance_to(systemPos) <= 300.0:
		print("In range")
		print("Enemies: " + str(map.get(system).enemies))
		if map.get(system).enemies.size() != 0:
			print("Enemies present")
			# change player position
			print(system)
			player.playerStats.currentSystem = system#.pos.x
			print(player.playerStats.currentSystem)
			#$"../MapPlayer".playerStats.currentSystemY = map.get(system).pos.y
			save_system(map.get(system).enemies)
			save_map(map)
			save_player_stats(player.playerStats)
			get_tree().change_scene_to_file("res://Stages/battle_mode.tscn")
		else:
			print("No enemies")
			#player.playerStats.currentSystem = system#.pos.x
			#$"../MapPlayer".playerStats.currentSystemY = map.get(system).pos.y
			#player.position.x = map.get(system).pos.x / 2
			#player.position.y = map.get(system).pos.y / 2
	else:
		print("Not in range")

func save():
	var save_dict = {
		"filename": get_scene_file_path(),
		"map": map,
		"playerMapPositionX": $"../MapPlayer".position.x,
		"playerMapPositionY": $"../MapPlayer".position.y,
		"playerCurrentHealth": $"../MapPlayer".health,
		"playerMaxHealth": $"../MapPlayer".maxHealth,
	}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
