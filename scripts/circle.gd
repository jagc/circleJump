extends Area2D

onready var orbitPosition = $pivot/orbitPosition
onready var moveTween = $moveTween

# there are 2 ways to get a sibling node, 
# direct and getting parent first.
# enable one of them only:
#onready var jumper = $"/root/main/jumper"
#onready var jumper = get_parent().get_node("jumper")

enum MODES {STATIC, LIMITED}
var radius = 100
var rotationSpeed = PI
var mode = MODES.STATIC
var moveRange = 100
var moveSpeed = 1.0
var numOrbits = 3
var currentOrbits = 0
var orbitStart = null
var jumper = null
	
func init(_position, jumperIsRotatingClockwise, level = 1):
	# level in this argument means that at level 1,
	# we'll have 0% chance that we're going to see a limited cirle
	var _mode = settings.randWeighted([10, level-1])
	setMode(_mode)
	position = _position
	# There won't be moving circles for the first 10 levels
	var moveChance = clamp(level -10, 0, 9) / 10.0 # odds that we'll be spawning a moving circle
	if randf() < moveChance: #if true, we'll have a moving circle
		# as player goes higher, the values here should be larger,
		# making the game more difficult.
		# We will randomize these variables by using the 'desmos' formula.
		# DESMOS is a graphing tool where in our set, the line starts out flat
		# but then, we'll have a continuous linear progress until we cap out to something close to max value
		# The line represents the level & difficulty.
		# max is an impossible difficulty.
		# x axis is the level
		# y axis is the difficulty
		# https://www.desmos.com/calculator
		# moveRange - has a minimum value, value goes higher as the level goes up
		moveRange = max(25, 100 * rand_range(0.75, 1.25) * moveChance) * pow(-1, randi() % 2)
		# moveRange - amount of time for the tween to execute, based on the level too.
		moveSpeed = max(2.5 - ceil(level/5) * 0.25, 0.75)
	var smallChance = min(0.9, max(0, (level-10) / 20.0)) # chance to spawn a smaller than average circle
	if randf() < smallChance:
		radius = max(50, radius - level * rand_range(0.75, 1.25))
	radius = _radius
	$Sprite.material = $Sprite.material.duplicate()
	$SpriteEffect.material = $Sprite.material
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
	setTween()
	
func setMode(_mode):
	mode = _mode
	var color
	match mode:
		MODES.STATIC:
			$Label.hide()
			color = settings.theme["circle_static"]
		MODES.LIMITED:
			currentOrbits = numOrbits
			$Label.text = str(currentOrbits)
			$Label.show()
			color = settings.theme["circle_limited"]
	$Sprite.material.set_shader_param("color", color)

func _process(delta):
	$pivot.rotation += rotationSpeed * delta
	if mode == MODES.LIMITED and jumper:
		checkOrbits()
	update()
		
func checkOrbits():
	if abs($pivot.rotation - orbitStart) > 2 * PI:
		currentOrbits -= 1
		if settings.enableSound:
			$beep.play()
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
							$pivot.rotation + PI/2, settings.theme["circle_fill"])
func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
    var nb_points = 32
    var points_arc = PoolVector2Array()
    points_arc.push_back(center)
    var colors = PoolColorArray([color])

    for i in range(nb_points + 1):
        var angle_point = angle_from + i * (angle_to - angle_from) / nb_points - PI/2
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
    draw_polygon(points_arc, colors)
	
func setTween(object = null, key = null):
	if moveRange == 0:
		return
	moveRange *= -1
	moveTween.interpolate_property(self, "position:x",
									position.x, position.x + moveRange,
									moveSpeed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	moveTween.start()