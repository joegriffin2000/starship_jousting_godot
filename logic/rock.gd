extends RigidBody2D

@export var max_speed = 10

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if state.linear_velocity.length():
		state.linear_velocity=state.linear_velocity.normalized() * max_speed

func take_damage():
	SignalBus.rock_mined.emit()
	#$GPUParticles2D.global_position = owner.get_node("Ship/Lance").global_position
	#$GPUParticles2D.emitting = true
	ShipData.rocks += 1
	print("rock = ", ShipData.rocks)
