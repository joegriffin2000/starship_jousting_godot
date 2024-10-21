extends Area2D

signal took_damage()

func _on_body_entered(body: Node2D) -> void:
	took_damage.emit()
