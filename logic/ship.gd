extends CharacterBody2D

@export var speed = 400
@export var rotation_speed = 3

var rotation_direction = 0

func get_input():
	rotation_direction = Input.get_axis("left", "right")
	velocity = transform.y * -Input.get_action_strength("up") * speed

func _physics_process(delta):
	if Input.is_action_pressed("dash"):
		dash()
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()

func dash():
	pass
