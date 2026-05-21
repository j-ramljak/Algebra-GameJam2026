extends Button

signal resume_pressed

func _on_pressed() -> void:
	resume_pressed.emit()
