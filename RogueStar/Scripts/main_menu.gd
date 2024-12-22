extends Node

@onready var gameLabel = $Label
@onready var menuButtons = $VBoxContainer
@onready var playGameButton = $VBoxContainer/PlayGameButton
@onready var settingsButton = $VBoxContainer/SettingsButton
@onready var exitButton = $VBoxContainer/ExitButton
@onready var settingsPanel = $SettingsPanel
@onready var resOptionButton = $SettingsPanel/OptionButton
@onready var backButton = $SettingsPanel/BackButton

var resolutions: Dictionary = {
	"3840x2160": Vector2(3840, 2160),
	"2560x1440": Vector2(2560, 1440),
	"1920x1080": Vector2(1920, 1080),
	"1366x768": Vector2(1366, 768),
	"1536x864": Vector2(1536, 864),
	"1280x720": Vector2(1280, 720),
	"1440x900": Vector2(1440, 900),
	"1600x900": Vector2(1600, 900),
	"1024x600": Vector2(1024, 600),
	"800x600": Vector2(800, 600)
}

var musicPlayer

func _ready() -> void:
	get_tree().paused = false
	playGameButton.pressed.connect(self._on_play_game_button_click)
	settingsButton.pressed.connect(self._on_settings_button_click)
	exitButton.pressed.connect(self._on_exit_button_click)
	backButton.pressed.connect(self._on_back_button_click)
	
	add_resolutions()
	
	musicPlayer = AudioStreamPlayer.new()
	musicPlayer.bus = &"Music Bus"
	musicPlayer.connect("finished", _on_music_player_finished)
	add_child(musicPlayer)
	musicPlayer.stream = preload("res://Sounds/Music/menu.wav")
	musicPlayer.play()

func _on_music_player_finished():
	musicPlayer.play()

func add_resolutions():
	for r in resolutions:
		resOptionButton.add_item(r)
	resOptionButton.select(2)

func _on_play_game_button_click():
	var dir = DirAccess.open("user://")
	if FileAccess.file_exists("user://savesystem.save"):
		dir.remove("savesystem.save")
	if FileAccess.file_exists("user://savemap.save"):
		dir.remove("savemap.save")
	if FileAccess.file_exists("user://savemapgenerated.save"):
		dir.remove("savemapgenerated.save")
	if FileAccess.file_exists("user://saveplayerstats.save"):
		dir.remove("saveplayerstats.save")
	if FileAccess.file_exists("user://savefirsttime.save"):
		dir.remove("savefirsttime.save")
	get_tree().change_scene_to_file("res://Stages/map_mode.tscn")

func _on_settings_button_click():
	gameLabel.hide()
	menuButtons.hide()
	settingsPanel.show()

func _on_exit_button_click():
	get_tree().quit()

func _on_back_button_click():
	settingsPanel.hide()
	gameLabel.show()
	menuButtons.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_option_button_item_selected(index: int) -> void:
	var resSize = resolutions.get(resOptionButton.get_item_text(index))
	get_tree().root.content_scale_size = resSize
	
