"""

Intended Usage:

Drag and drop this script onto a Camera2D that is a child of the root.

To get the camera shake. Call the add_trauma(amount) from elsewhere.
	amount == a number between 0 and 1


"""



extends Camera2D

export var x_limit = 0
export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
export (NodePath) var target  # Assign the node this camera will follow.
export(float, 0, 1, 0.02) var max_trauma = 1  # max trauma
export(bool) var only_x = false setget _set_only_x
export(bool) var only_y = false setget _set_only_y

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].


onready var noise = OpenSimplexNoise.new()
var noise_y = 0

func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

func add_trauma(amount):
	trauma = min(trauma + amount, max_trauma)


func _process(delta):
	if target:
		if only_x:   global_position.x = get_node(target).global_position.x
		elif only_y: global_position.y = get_node(target).global_position.y
		else:        global_position   = get_node(target).global_position
		global_position.x = max(global_position.x, x_limit)
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()


func shake():
	var amount = pow(trauma, trauma_power)
	
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)


func _set_only_x(value):
	only_x = value
	if value:
		only_y = false
		
func _set_only_y(value):
	only_y = value
	if value:
		only_x = false
