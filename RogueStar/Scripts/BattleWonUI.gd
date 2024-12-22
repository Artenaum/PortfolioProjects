extends Control

@onready var pausePanel := $PausePanel
@onready var winPanel := $WinPanel
@onready var gamePausedLabel := $PausePanel/Label
@onready var winButton := $WinPanel/Button
@onready var gameOverPanel := $GameOverPanel
@onready var gameOverButton := $GameOverPanel/Button
@onready var runWonPanel := $RunWonPanel
@onready var runWonButton := $RunWonPanel/Button

var pauseActive: bool = false 
var gameWon: bool = false
var runWon: bool = false
var gameOver: bool = false

@onready var player := $"../Player"

var playerStats = {}

func _ready() -> void:
	winButton.pressed.connect(self._on_win_button_click)
	gameOverButton.pressed.connect(self._on_game_over_button_click)
	runWonButton.pressed.connect(self._on_run_won_button_click)
	player.connect("died", _on_game_over)
	pass

func _input(event) -> void:
	if event.is_action_pressed("pause_game") and not gameWon and not gameOver:
		print("unpaused")
		pauseActive = !pauseActive
		if pauseActive:
			pausePanel.show()
			gamePausedLabel.show()
		else:
			gamePausedLabel.hide()
			pausePanel.hide()
		get_tree().paused = not get_tree().paused

func save_player_stats(_player_stats: Dictionary):
	var savePlayerStats = FileAccess.open("user://saveplayerstats.save", FileAccess.WRITE)
	var jsonString = JSON.stringify(_player_stats)
	savePlayerStats.store_line(jsonString)

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
			continue # 
		playerStats = json.get_data()

func _on_spawner_battle_won() -> void:
	gameWon = true
	get_tree().paused = true
	pausePanel.show()
	gamePausedLabel.hide()
	winPanel.show()

func _on_win_button_click() -> void:
	load_player_stats()
	playerStats.health = player.health
	save_player_stats(playerStats)
	get_tree().change_scene_to_file("res://Stages/map_mode.tscn")

func _on_game_over() -> void:
	gameOver = true
	get_tree().paused = true
	pausePanel.show()
	gamePausedLabel.hide()
	gameOverPanel.show()

func _on_game_over_button_click() -> void:
	get_tree().change_scene_to_file("res://Stages/main_menu.tscn")

func _on_spawner_run_won() -> void:
	runWon = true
	get_tree().paused = true
	pausePanel.show()
	gamePausedLabel.hide()
	runWonPanel.show()

func _on_run_won_button_click() -> void:
	get_tree().change_scene_to_file("res://Stages/main_menu.tscn")
