extends Control
var pointing_target: CollisionObject2D

@onready var arrow = $Sprite

func _ready() -> void:
	#self.set_process(false)
	SignalBus.show_indicator_arrow.connect(enable_indicator_arrow)
	SignalBus.quest_completed.connect(disable_indicator_arrow)
	SignalBus.quest_failed.connect(disable_indicator_arrow)
	SignalBus.quest_removed.connect(disable_indicator_arrow)

func enable_indicator_arrow(target: CollisionObject2D):
	pointing_target = target
	#self.set_process(true)
	self.visible = true

func disable_indicator_arrow():
	#self.set_process(false)
	pointing_target = null
	self.visible = false

func _process(_delta: float) -> void:
	if pointing_target != null:
		var target_position = pointing_target.global_position
		var offset = owner.global_position - target_position
		arrow.position.x = clampf(max(abs((offset).x),abs((offset).y)) - 200,40,500)
		rotation = Vector2.LEFT.angle_to(offset) - owner.rotation
		

	
