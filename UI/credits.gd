extends "scaleable.gd"

#Function to update label text with new amount
func update_score(score):
	text = "$"+str(score)

# TODO: Replace this with a signal instead of using _process
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_score(ShipData.credits)
# ----------------------------------------
