extends Area2D

signal captured
signal died

onready var trail = $trail/points

var velocity = Vector2(100, 0) # start value for testing
var jumpSpeed = 1000
var target = null # if we're on a circle
var trailLength = 25
var is_rotatingClockwise = 1
var isJumping = false

func _ready():
	$Sprite.material.set_shader_param("color", settings.theme["player_body"])
	var trailColor = settings.theme["player_trail"]
	trail.gradient.set_color(1, trailColor)
	trailColor.a = 0
	trail.gradient.set_color(0, trailColor)

func _unhandled_input(event):
	if target and event is InputEventScreenTouch and event.pressed:
		jump()

func jump():
	isJumping = true
	target.implode()
	target = null
	velocity = transform.x * jumpSpeed
	if settings.enableSound:
		$jump.play()

# 'area' is the circle.gd object
func _on_jumper_area_entered(area):
	target = area
	isJumping = false

	var _rotation = (position - target.position).angle()
	is_rotatingClockwise = 1 if _rotation > 1.4 else -1

	target.get_node("pivot").rotation = _rotation
	velocity = Vector2.ZERO

	emit_signal("captured", area, is_rotatingClockwise)
	if settings.enableSound:
		$capture.play()

func _physics_process(delta):
	if trail.points.size() > trailLength:
		trail.remove_point(0)

	if isJumping == false:
		if is_rotatingClockwise == 1:
			trail.add_point(position + Vector2(0,7).rotated(rotation))
		else:
			trail.add_point(position - Vector2(0,7).rotated(rotation))
	else:
		trail.add_point(position)
#	trail.add_point(position)
	
	if target:
		transform = target.orbitPosition.global_transform
	else:
		position += velocity * delta

func die():
	target = null
	queue_free()

func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	if !target:
		emit_signal("died")
		die()
