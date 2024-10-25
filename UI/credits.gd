extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().size_changed.connect(update_font_size)

func update_font_size():
	var screen_size = get_viewport_rect().size
	var m = int(screen_size.x * screen_size.y) / 10000
	add_theme_font_size_override("font_size",int(m)*.20)

func update_score(score):
	text = "$"+str(score)

# GET RID OF THIS AND REPLACE WITH SIGNAL vvvvvvvv
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_score(ShipData.credits)
# ----------------------------------------
