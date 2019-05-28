extends Area2D

var velocity = Vector2(100, 0) # start value for testing
var jumpSpeed = 1000
var target = null # if we're on a circle

func _unhandled_input(event):
	if target and event is InputEventScreenTouch and event.pressed:
		jump()

func jump():
	target = null
	velocity = transform.x * jumpSpeed

func _on_jumper_area_entered(area):
	target = area
	velocity = Vector2()

func _physics_process(delta):
	if target:
#		for i in len(target):
#			print(target[i])
#			print(target)
#			print(target.position)
#		transform = target.orbit_position.global_transform
		transform = target.position.transform
#		transform = target.position.global_transform
	else:
		position += velocity * delta