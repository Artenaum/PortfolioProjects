extends Node2D

signal player_initialized

#@onready var map: Dictionary = $"../MapGenerator".map
#@onready var mapGenerator := $"../MapGenerator"

#var currentSystem: String = "system0"
var playerStats = {
	#"currentSystemX": 0,
	#"currentSystemY": 0,
	#"currentSystem": "system0",
	#"maxHealth": 10,
	#"health": 10,
}
var _map: Dictionary
#var currentSystem = "system0"
var maxHealth: int
var health: int
var firstTime = true

#var currentSystem = "system0"
#@export var maxHealth: int
#var health: int

func load_player_stats():
	if not FileAccess.file_exists("user://saveplayerstats.save"):
		#playerStats.currentSystemX = _map.get(_map.keys()[0]).pos.x
		#playerStats.currentSystemY = _map.get(_map.keys()[0]).pos.y
		return
	var saveSystem = FileAccess.open("user://saveplayerstats.save", FileAccess.READ)
	while saveSystem.get_position() < saveSystem.get_length():
		var jsonString = saveSystem.get_line()
		var json = JSON.new()
		var parseResult = json.parse(jsonString)
		if not parseResult == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", jsonString, " at line ", json.get_error_line())
			continue # 
		playerStats = json.get_data()

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
		_map = json.get_data()

func save_first_time(_mapGenerated: bool):
	var saveMap = FileAccess.open("user://savefirsttime.save", FileAccess.WRITE)
	var jsonString = JSON.stringify(_mapGenerated)
	saveMap.store_line(jsonString)

func load_first_time():
	if not FileAccess.file_exists("user://savefirsttime.save"):
		firstTime = true
		return
	var saveSystem = FileAccess.open("user://savefirsttime.save", FileAccess.READ)
	while saveSystem.get_position() < saveSystem.get_length():
		var jsonString = saveSystem.get_line()
		var json = JSON.new()
		var parseResult = json.parse(jsonString)
		if not parseResult == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", jsonString, " at line ", json.get_error_line())
			continue # 
		firstTime = json.get_data()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("player")
	load_first_time()
	print("first time: " + str(firstTime))
	#mapGenerator.connect('map_ready', _on_map_ready)
	if not firstTime:
		load_player_stats()
		print("currentSystem: " + str(playerStats.currentSystem))
		print("max health: " + str(playerStats.maxHealth))
		print("health: " + str(playerStats.health))
		load_map()
		#load_player_stats()
		maxHealth = playerStats.maxHealth
		health = playerStats.health
		#position.x = playerStats.currentSystemX
		#position.y = playerStats.currentSystemY
		#print(position)
		position.x = _map.get(playerStats.currentSystem).pos.x / 2
		position.y = _map.get(playerStats.currentSystem).pos.y / 2
		print(position)
		#position.x = _map.get(playerStats.keys()[0]).pos.x / 2
		#position.y = _map.playerStats.keys()[0].pos.y / 2
		#print(position)
		#position.x = map.get(currentSystem).pos.x / 2
		#position.y = map.get(currentSystem).pos.y / 2
		#print(position)
		player_initialized.emit()
	else:
		load_map()
		playerStats["currentSystem"] = "system0"
		playerStats["maxHealth"] = 10
		playerStats["health"] = 10
		maxHealth = playerStats.maxHealth
		health = playerStats.health
		position.x = _map.get(playerStats.currentSystem).pos.x / 2
		position.y = _map.get(playerStats.currentSystem).pos.y / 2
		print(position)
		firstTime = false
		save_first_time(firstTime)
		

func _on_map_ready():
	pass
	#load_player_stats()
	#maxHealth = playerStats.maxHealth
	#health = playerStats.health
	#position.x = playerStats.get("currentSystem").pos.x / 2
	#position.y = playerStats.get("currentSystem").pos.y / 2
	#print(position)
	#position.x = map.get(currentSystem).pos.x / 2
	#position.y = map.get(currentSystem).pos.y / 2
	#print(position)

func _draw() -> void:
	draw_arc(global_position, 40.0, 0, 360, 36, Color(1.0, 1.0, 1.0), 5.0)
	draw_arc(global_position, 300.0, 0, 360, 36, Color(1.0, 1.0, 1.0), 5.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
