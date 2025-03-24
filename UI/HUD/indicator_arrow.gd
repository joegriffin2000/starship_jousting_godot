extends Control
var pointing_target: CollisionObject2D

@onready var arrow = $Sprite

func _ready() -> void:
	set_process(false)
	SignalBus.quest_completed.connect(disable)

func _process(delta: float) -> void:
	if pointing_target != null:
		var target_position = pointing_target.global_position
		var offset = owner.global_position - target_position
		arrow.position.x = clampf(max(abs((offset).x),abs((offset).y)) - 200,40,500)
		rotation = Vector2.LEFT.angle_to(offset) - owner.rotation
		
func disable():
	set_process(false)
	visible = false
	pointing_target = null

func enable(target: CollisionObject2D):
	pointing_target = target
	set_process(true)
	visible = true
	
