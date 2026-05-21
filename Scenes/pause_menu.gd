extends Control

#@onready var main = $"../../Player"
#@onready var mainMenu = $CanvasLayer/Node2D


signal r_pressed
signal q_pressed

func _on_resume_pressed() -> void:
	r_pressed.emit()


func _on_quit_pressed() -> void:
	q_pressed.emit()
