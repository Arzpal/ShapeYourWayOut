extends Area2D

const SPEED = 1000.0

var spawn_pos: Vector2
var spawn_rot: float

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = spawn_pos
	global_rotation = spawn_rot
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_local_y(-SPEED * delta)
	pass
