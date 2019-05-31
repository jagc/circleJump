extends Node

signal startGame

var soundButtons = {true: preload("res://assets/images/buttons/audioOn.png"),
					false: preload("res://assets/images/buttons/audioOff.png")}
var musicButtons = {true: preload("res://assets/images/buttons/musicOn.png"),
					false: preload("res://assets/images/buttons/musicOff.png")}
var currentScreen = null

func _ready():
	registerButtons()
	changeScreen($titleScreen)
	
func registerButtons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	for button in buttons:
		button.connect("pressed", self, "_on_button_pressed", [button])
		
func _on_button_pressed(button):
	if settings.enableSound:
		$click.play()
	match button.name:
		"home":
			changeScreen($titleScreen)
		"play":
			changeScreen(null)
			yield(get_tree().create_timer(0.5), "timeout")
			emit_signal("startGame")
		"settings":
			changeScreen($settingsScreen)
		"sound":
			settings.enableSound = !settings.enableSound
			button.texture_normal = soundButtons[settings.enableSound]
		"music":
			settings.enableMusic = !settings.enableMusic
			button.texture_normal = musicButtons[settings.enableMusic]

func changeScreen(newScreen):
	if currentScreen:
		currentScreen.disappear()
		yield(currentScreen.tween, "tween_completed")
	currentScreen = newScreen
	if newScreen:
		currentScreen.appear()
		yield(currentScreen.tween, "tween_completed")
		
func gameOver():
	changeScreen($gameOverScreen)