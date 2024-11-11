extends RichTextLabel

func _ready() -> void:
	SignalBus.quest_received.connect(update_quest_text)

func update_quest_text(quest: Variant) -> void:
	text = quest.description

func update_progress(quest: Variant) -> void:
	pass
