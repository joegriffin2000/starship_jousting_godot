extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().size_changed.connect(update_font_size)

#function to scale font size with screensize height
func update_font_size():
	var m = int(get_viewport_rect().size.y / 25)
	m = m if m <= 50 else 50
	m = m if m >= 30 else 30
	add_theme_font_size_override("font_size",m) 

#Function to update label text with new amount
func update_score(score):
	text = "$"+str(score)

# GET RID OF THIS AND REPLACE WITH SIGNAL vvvvvvvv
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_score(ShipData.credits)
# ----------------------------------------
