extends Node2D

var circle = preload("res://objects/circle.tscn")
var jumper = preload("res://objects/jumper.tscn")

var player
var jumperIsRotatingClockwise = 1
var score = 0 setget setScore
var level = 0

func _ready():
	randomize()
	$HUD.hide()
	
func newGame():
	# doing it this way, there is a small performance hit
	# because we are generating a reference to a node (to this node)
	# but since the game is small, we don't need to worry about performance
	self.score = 0
#	setScore(0) # this way is calling the setget directly
	
	level = 1	
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
	self.score += 1
	
func setScore(value):
	score = value
	$HUD.updateScore(score)
	if score > 0 and score % settings.circlesPerLevel == 0:
		level += 1
		$HUD.showMessage("Level %s" % str(level))
	
func on_Jumper_died():
	settings.saveData(score)
	get_tree().call_group("circles", "implode")
	$screens.gameOver()
	$HUD.hide()
	if settings.enableMusic:
		$music.stop()