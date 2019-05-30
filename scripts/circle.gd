extends Area2D

onready var orbitPosition = $pivot/orbitPosition

# there are 2 ways to get a sibling node, 
# direct and getting parent first.
# enable one of them only:
#onready var jumper = $"/root/main/jumper"
#onready var jumper = get_parent().get_node("jumper")

enum MODES {STATIC, LIMITED}
var radius = 100
var rotationSpeed = PI
var mode = MODES.STATIC
var numOrbits = 3
var currentOrbits = 0
var orbitStart = null
var jumper = null
	
func init(_position, jumperIsRotatingClockwise, _radius = radius, _mode = MODES.LIMITED):
	setMode(_mode)
	position = _position
	radius = _radius
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = radius
	var imgSize = $Sprite.texture.get_size().x / 2
	$Sprite.scale = Vector2(1, 1) * radius / imgSize
	orbitPosition.position.x = radius + 25
	# randomly provides 1 or -1
	# i want to change this later so rotation direction will go
	# basing on it's position of the circle
	# if it lands left, it's rotating clockwise, and vice versa.
#	rotationSpeed *= pow(-1, randi() % 2)

	# using this instead to determine rotation, though.
	rotationSpeed *= jumperIsRotatingClockwise
	
func setMode(_mode):
	mode = _mode
	match mode:
		MODES.STATIC:
			$Label.hide()
		MODES.LIMITED:
			currentOrbits = numOrbits
			$Label.text = str(currentOrbits)
			$Label.show()

func _process(delta):
	$pivot.rotation += rotationSpeed * delta
	if mode == MODES.LIMITED and jumper:
		checkOrbits()
		
func checkOrbits():
	if abs($pivot.rotation - orbitStart) > 2 * PI:
		currentOrbits -= 1
		$Label.text = str(currentOrbits)
		if currentOrbits <= 0:
			jumper.die()
			jumper = null
			implode()
		orbitStart = $pivot.rotation
	
func implode():
	$AnimationPlayer.play('implode')
	yield($AnimationPlayer, "animation_finished")
	queue_free()
	
func capture(target):
	jumper = target
	$AnimationPlayer.play("capture")
	$pivot.rotation = (jumper.position - position).angle()
	orbitStart = $pivot.rotation