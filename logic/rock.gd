extends RigidBody2D

@export var max_speed = 10

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if state.linear_velocity.length():
		state.linear_velocity=state.linear_velocity.normalized() * max_speed
