extends TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.show_quest_timer.connect(show_timer_bar)
	SignalBus.quest_completed.connect(hide_timer_bar)
	SignalBus.quest_failed.connect(hide_timer_bar)
	
func show_timer_bar():
	self.visible = true
	
	if ShipData.quest.faction == "GOAT" and ShipData.quest.type == 1:
		var timeLimit = ShipData.quest.questTimer.get_wait_time()
		self.max_value = timeLimit
		self.value = timeLimit
		
	elif ShipData.quest.faction == "SEU" and ShipData.quest.type == 2:
		self.max_value = 10
		self.value = 0

func hide_timer_bar():
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ShipData.quest != null and ShipData.quest.questTimer != null: # We have a quest that needs a timer
		if ShipData.quest.faction == "GOAT" and ShipData.quest.type == 1:
			self.value = ShipData.quest.getTimeLeft()
		elif ShipData.quest.faction == "SEU" and ShipData.quest.type == 2:
			if ShipData.quest.isTimerStopped():
				self.value = 0
			else:
				self.value = 10 - ShipData.quest.getTimeLeft()
		
		if self.value > self.max_value * 0.75: # Greater than 75%
			self.tint_progress = Color.hex(0x98f24fff)
		elif self.value > self.max_value * 0.5: # 50-75%
			self.tint_progress = Color.hex(0xf2e24fff)
		elif self.value > self.max_value * 0.25: # 25-50%
			self.tint_progress = Color.hex(0xf2904fff)
		elif self.value < self.max_value * 0.25: # Less than 25%
			self.tint_progress = Color.hex(0xe03e3eff)
