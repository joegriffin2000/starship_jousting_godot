class_name Scaleable
extends Label

# Re-scale content when window size changes
func _ready() -> void:
	get_viewport().size_changed.connect(update_font_size)

# Scale font size of label with screen height
func update_font_size(min = 35, max = 50):
	var m = int(get_viewport_rect().size.y / 25)
	m = m if m <= max else max
	m = m if m >= min else min
	add_theme_font_size_override("font_size", m)
	print("Resized")
