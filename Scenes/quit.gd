extends Button

signal quit_pressed

func _on_pressed() -> void:
	quit_pressed.emit()
