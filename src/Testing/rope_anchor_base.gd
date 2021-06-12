extends Position2D

# sets the length of the spring based on the distance 
#  to the other anchor

export(NodePath) var anchor_target_path

func init():
	var anchor_target : Position2D = get_node(anchor_target_path)
	print("finding anchor target: ", anchor_target)
	$rope.length = global_position.distance_to(anchor_target.global_position)
	$rope.rest_length = $rope.length
#	$rope.rest_length = global_position.distance_to(anchor_target.global_position)
	print("New Length: ", $rope.length)
	$rope.node_a = get_parent().get_path()
	$rope.node_b = anchor_target.get_parent().get_path()
	

func pull(amount):
	print("Rope being pulled %s -> %s" % [$rope.rest_length, $rope.rest_length-amount])
	$rope.rest_length -= amount
	if $rope.rest_length <= 0: 
		$rope.rest_length = -1

func _physics_process(delta):
	var anchor_target = get_node_or_null(anchor_target_path)
	if anchor_target:
		$Line2D.points[0] = Vector2(0,0)
		$Line2D.points[1] = anchor_target.global_position - global_position
#		rotation = 0
		global_rotation = 0
#		anchor_target.global_rotation = 0
	else:
		queue_free() # the anchor target is dead so we are dead
