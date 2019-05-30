extends Area2D

signal captured

onready var trail = $trail/points

var velocity = Vector2(100, 0) # start value for testing
var jumpSpeed = 1000
var target = null # if we're on a circle
var trailLength = 25

func _unhandled_input(event):
	if target and event is InputEventScreenTouch and event.pressed:
		jump()

func jump():
	target.implode()
	target = null
	velocity = transform.x * jumpSpeed

# 'area' is the circle.gd object
func _on_jumper_area_entered(area):
	target = area

	var _rotation = (position - target.position).angle()
	var is_rotatingClockwise = 1 if _rotation > 1.4 else -1

	target.get_node("pivot").rotation = _rotation
	velocity = Vector2.ZERO

	emit_signal("captured", area, is_rotatingClockwise)

func _physics_process(delta):
	if trail.points.size() > trailLength:
		trail.remove_point(0)
	trail.add_point(position)
	
	if target:
		transform = target.orbitPosition.global_transform
	else:
		position += velocity * delta

func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	call_deferred("_reloadMainScene")
	
func _reloadMainScene():
	return get_tree().reload_current_scene()
