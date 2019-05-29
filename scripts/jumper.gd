extends Area2D

signal captured

var velocity = Vector2(100, 0) # start value for testing
var jumpSpeed = 1000
var target = null # if we're on a circle

func _unhandled_input(event):
	if target and event is InputEventScreenTouch and event.pressed:
		jump()

func jump():
	target = null
	velocity = transform.x * jumpSpeed

# 'area' is the circle.gd object
func _on_jumper_area_entered(area):
	target = area
	target.get_node("pivot").rotation = (position - target.position).angle()
	velocity = Vector2.ZERO
	emit_signal("captured", area)

func _physics_process(delta):
	if target:
		transform = target.orbitPosition.global_transform
	else:
		position += velocity * delta

func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	call_deferred("_reloadMainScene")
	
func _reloadMainScene():
	return get_tree().reload_current_scene()
