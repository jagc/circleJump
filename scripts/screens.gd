extends Node

signal startGame

var currentScreen = null

func _ready():
	registerButtons()
	changeScreen($titleScreen)
	
func registerButtons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	for button in buttons:
		button.connect("pressed", self, "_on_button_pressed", [button.name])
		
func _on_button_pressed(name):
	if settings.enableSound:
		$click.play()
	match name:
		"home":
			changeScreen($titleScreen)
		"play":
			changeScreen(null)
			yield(get_tree().create_timer(0.5), "timeout")
			emit_signal("startGame")
		"settings":
			changeScreen($settingsScreen)

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