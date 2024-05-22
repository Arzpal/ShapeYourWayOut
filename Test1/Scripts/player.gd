extends CharacterBody2D

#movement
const SPEED = 1000.0
const MAX_SPEED = 50000.0
var isMoving = false

#rotation
var rotation_dir: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.ZERO
var both_pressed = false
@onready var rotation_delay = $RotationDelay
@export var delay_time = 0.2

#shoot
@export var bullet_scene: PackedScene
@onready var bullet_position = $BulletPosition
@onready var fire = $Fire

#damage
@onready var animation_player = $AnimationPlayer

func _ready():
	rotation_delay.wait_time = delay_time

func _physics_process(delta):
	movement_rotation(delta)
	if Input.is_action_just_pressed("shoot"):
		shoot()

func movement_rotation(delta):
	var direction = Vector2(
		Input.get_axis("m_left", "m_right"),
		Input.get_axis("m_up", "m_down"))
	
	if abs(direction.x) == 1 && abs(direction.y) == 1:
		both_pressed = true
	
	if direction != Vector2.ZERO:
		velocity += last_direction * SPEED * delta
		if !fire.is_playing():
			fire.play("Fire")
	else:
		velocity -= velocity * delta
		fire.play("Idle")
		fire.stop()
	
	velocity = Vector2(clamp(velocity.x, -MAX_SPEED * delta, MAX_SPEED * delta), clamp(velocity.y, -MAX_SPEED * delta, MAX_SPEED * delta))
	
	if !both_pressed && direction != Vector2.ZERO: #if just touching one button
		last_direction = direction.normalized()
	elif both_pressed && direction.x * direction.y == 0 && abs(direction.x) + abs(direction.y) != 0: #if one of them has been released
		if(rotation_delay.is_stopped()):
			rotation_delay.start()
	elif direction != Vector2.ZERO:
		last_direction = direction.normalized()
	
	_rotate_direction()
	move_and_slide()

func _rotate_direction():
	# Use last_direction if the timer is active
	if rotation_delay.is_stopped():
		rotation_dir = last_direction
	
	rotation_degrees = atan2(rotation_dir.x, -rotation_dir.y) * 180 / PI

func _on_rotation_delay_timeout():
	both_pressed = false
	rotation_dir = last_direction

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.spawn_pos = bullet_position.global_position
	bullet.spawn_rot = bullet_position.global_rotation
	bullet_position.add_child(bullet)

func _on_hurt():
	velocity.x /= 2
	velocity.y /= 2
	animation_player.play("Hit")

func _on_death():
	pass # Replace with function body.
