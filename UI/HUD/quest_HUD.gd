extends ScaleableLabel

@onready var desc = %QuestText
@onready var progress = %QuestProgress

func _ready() -> void:
	SignalBus.quest_received.connect(set_quest_text)
	SignalBus.quest_progressed.connect(update_quest_text)
	SignalBus.quest_completed.connect(complete_quest_text)
	SignalBus.quest_removed.connect(no_quest_text)

func set_quest_text(quest: Variant) -> void:
	var qD = ShipData.quest.description
	var qP = str("(", ShipData.quest.progress, "/", ShipData.quest.total, " done)")
	desc.set_text(qD)
	progress.set_text(qP)

func update_quest_text() -> void:
	if ShipData.quest != null:
		var qP = str("(", ShipData.quest.progress, "/", ShipData.quest.total, " done)")
		progress.set_text(qP)

func complete_quest_text() -> void:
	desc.set_text("Quest completed!")
	progress.set_text("Return to carrier ship.")

func no_quest_text() -> void:
	desc.set_text("No active quest.")
	progress.set_text("Take a new quest at a carrier ship.")
