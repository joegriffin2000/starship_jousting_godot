extends RichTextLabel

func _ready() -> void:
	SignalBus.quest_received.connect(change_text)

func change_text(new_text):
	text = new_text
