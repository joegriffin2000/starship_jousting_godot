extends TextureButton
class_name AbilityButton

@onready var time_label = $Counter/Value

func _ready():
	SignalBus.dash.connect(dash_start)
	time_label.hide()
	$Sweep.value = 0
	$Sweep.texture_progress = texture_normal
	set_process(false)
	
func _process(_delta):
	time_label.text = "%3.1f" % $Sweep/Timer.time_left
	$Sweep.value = int(($Sweep/Timer.time_left / ShipData.dash_cd) * 100)
	
func _on_AbilityButton_pressed():
	dash_start(ShipData.dash_cd)
	
func dash_start(cd):
	$Sweep/Timer.wait_time = cd
	disabled = true
	set_process(true)
	$Sweep/Timer.start()
	time_label.show()

func _on_Timer_timeout():
	#print("ability ready")
	$Sweep.value = 0
	disabled = false
	time_label.hide()
	set_process(false)
