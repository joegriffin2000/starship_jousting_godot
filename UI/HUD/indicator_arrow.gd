extends Control
var pointing_target: CollisionObject2D

@onready var arrow = $Sprite

func _ready() -> void:
	SignalBus.quest_completed.connect(disable_indicator_arrow)
	SignalBus.quest_failed.connect(disable_indicator_arrow)
	SignalBus.quest_removed.connect(disable_indicator_arrow)

func enable_indicator_arrow(target: CollisionObject2D):
	if owner.is_local_authority():
		pointing_target = target
		self.visible = true
		self.set_process(true)

func disable_indicator_arrow():
	if owner.is_local_authority():
		pointing_target = null
		self.visible = false
		self.set_process(false)

func _process(_delta: float) -> void:
	if owner.is_local_authority():
		if pointing_target != null:
			var target_position = pointing_target.global_position
			var offset = owner.global_position - target_position
			arrow.position.x = clampf(max(abs((offset).x),abs((offset).y)) - 200,40,500)
			rotation = Vector2.LEFT.angle_to(offset) - owner.rotation
		

	
