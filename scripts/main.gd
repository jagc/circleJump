extends Node2D

var circle = preload("res://objects/circle.tscn")
var jumper = preload("res://objects/jumper.tscn")

var player

func _ready():
	randomize()
	newGame()
	
func newGame():
	$Camera2D.position = $startPosition.position
	player = jumper.instance()
	player.position = $startPosition.position
	add_child(player)
	player.connect("captured", self, "_on_Jumper_captured")
	spawnCircle($startPosition.position)
	
func spawnCircle(_position = null):
	var c = circle.instance()
	if !_position:
		var x = rand_range(-150, 150)
		var y = rand_range(-500, -400)
		_position = player.target.position + Vector2(x, y)
	add_child(c)
	c.init(_position)
		
func _on_Jumper_captured(object):
	$Camera2D.position = object.position
	call_deferred("spawnCircle")