extends Area2D

onready var orbitPosition = $pivot/orbitPosition
var radius = 100
var rotationSpeed = PI

func _ready():
	init()
	
func init(_radius = radius):
	radius = _radius
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = radius
	var imgSize = $Sprite.texture.get_size().x / 2
	$Sprite.scale = Vector2(1, 1) * radius / imgSize
	orbitPosition.position.x = radius + 25
	
func _process(delta):
	$pivot.rotation += rotationSpeed * delta