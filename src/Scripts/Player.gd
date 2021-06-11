extends Area2D

export var MAX_SPEED = 200     # pixels per second I believe
export var ACCELERATION = 1000 # Accel for both moving and stopping
export var SLIPPERY = false    # whether the character slides a bit when changing directions

var motion = Vector2.ZERO
var axis = Vector2.ZERO

var platforms = []

var target_platform : RigidBody2D

onready var rope_tscn = preload("res://Rope.tscn")



func _physics_process(delta):
	motion = Vector2.ZERO
#	var x = Vector2(0,0)
	var major_platform : RigidBody2D = get_major_platform()
	if major_platform:
		motion += major_platform.linear_velocity
	else:
		print("we dead")
	
	var axis = get_input_axis()
	motion += axis * MAX_SPEED
	
	
	position += motion * delta

func _input(event):
	if Input.is_action_just_pressed("throw_rope") and target_platform:
		print("Throw rope")
		# See if we miss!
		# get the platform under the mouse
		
		
		# spawn a rope object
		var rope : Rope = rope_tscn.instance()
		# set the start platform and end platform
		rope.source_platform = get_major_platform()
		rope.target_platform = target_platform
		# set the offsets for each platform
		rope.source_offset = position
		# add child
	
func get_major_platform():
	if platforms.size() > 0:
		return platforms[0]
	return null


func _on_body_entered(body):
	if body.is_in_group("platforms"):
		print("body entered")
		platforms.append(body)
	pass # Replace with function body.

func _on_body_exited(body):
	if body.is_in_group("platforms"):
		print("body exited")
		platforms.erase(body)
	pass # Replace with function body.


func _on_MouseFollower_body_entered(body):
	if body.is_in_group("platforms"):
		target_platform = body
		print("target changed")


func _on_MouseFollower_body_exited(body):
	if body.is_in_group("platforms"):
		if body == target_platform:
			target_platform = null
			print("target lost")




































##### Movement ######

func move(delta: float) -> void:
	
	get_input_axis()
	if SLIPPERY: 
		slide_movement(delta)
	else:
		snappier_movement(delta)
	clamp_motion()
	position += motion * delta
#	motion = move_and_slide(motion, Vector2.UP)
	
##### Subroutines #####



func slide_movement(delta: float) -> void:
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)


func snappier_movement(delta: float) -> void:
	apply_friction(ACCELERATION * delta)
	apply_movement(axis * ACCELERATION * delta * 2)


func apply_friction(amount: float) -> void:
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO


func apply_movement(acceleration) -> void:
	motion += acceleration

func get_input_axis() -> Vector2:
	var axis = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	return axis


func clamp_motion(): # limit the top speed
	motion = motion.clamped(MAX_SPEED)







