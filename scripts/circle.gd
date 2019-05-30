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
	update()
		
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

func _draw():
	if jumper:
		var r = ((radius - 50) / numOrbits) * (1 + numOrbits - currentOrbits)
		draw_circle_arc_poly(Vector2.ZERO, r + 10, orbitStart + PI/2,
							$pivot.rotation + PI/2, Color(1, 0, 0))
func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
    var nb_points = 32
    var points_arc = PoolVector2Array()
    points_arc.push_back(center)
    var colors = PoolColorArray([color])

    for i in range(nb_points + 1):
        var angle_point = angle_from + i * (angle_to - angle_from) / nb_points - PI/2
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
    draw_polygon(points_arc, colors)