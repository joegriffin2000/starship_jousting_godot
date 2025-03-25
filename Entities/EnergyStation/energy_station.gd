extends StaticBody2D

func _on_charging_area_entered(body):
	if body.has_method("energy_station_eligible") and body.is_local_authority():
		# If correct Quest type, tell Quest to unpause timer
		if ShipData.quest != null:
			if ShipData.quest.faction == "SEU" and ShipData.quest.type == 2:
				SignalBus.start_charging_battery.emit()

func _on_charging_area_exited(body):
	if body.has_method("energy_station_eligible") and body.is_local_authority():
		# If correct Quest type, tell Quest to pause timer
		if ShipData.quest != null:
			if ShipData.quest.faction == "SEU" and ShipData.quest.type == 2:
				SignalBus.stop_charging_battery.emit()
