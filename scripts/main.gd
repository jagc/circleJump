extends Node2D

var circle = preload("res://objects/circle.tscn")
var jumper = preload("res://objects/jumper.tscn")

var player
var jumperIsRotatingClockwise = 1
var score = 0

func _ready():
	randomize()
	$HUD.hide()
	
func newGame():
	score = 0
	$HUD.updateScore(score)
	$Camera2D.position = $startPosition.position
	player = jumper.instance()
	player.position = $startPosition.position
	add_child(player)
	player.connect("captured", self, "_on_Jumper_captured")
	player.connect("died", self, "on_Jumper_died")
	spawnCircle($startPosition.position)
	$HUD.show()
	$HUD.showMessage("Go!")
	if settings.enableMusic:
		$music.play()
	
func spawnCircle(_position = null):
	var c = circle.instance()
	if !_position:
		var x = rand_range(-150, 150)
		var y = rand_range(-350, -250)
		_position = player.target.position + Vector2(x, y)
	add_child(c)
	c.init(_position, jumperIsRotatingClockwise)
		
func _on_Jumper_captured(object, isRotatingClockwise):
	$Camera2D.position = object.position
	object.capture(player)
	jumperIsRotatingClockwise = isRotatingClockwise
	call_deferred("spawnCircle")
	score += 1
	$HUD.updateScore(score)
	
func on_Jumper_died():
	get_tree().call_group("circles", "implode")
	$screens.gameOver()
	$HUD.hide()
	if settings.enableMusic:
		$music.stop()