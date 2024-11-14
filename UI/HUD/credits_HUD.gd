extends ScaleableLabel

func _ready():
	SignalBus.credits_updated.connect(update_credits)

#Function to update label text with new amount
func update_credits():
	text = "$"+str(ShipData.credits)
