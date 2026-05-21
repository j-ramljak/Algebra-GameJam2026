extends Control

#@onready var main = $"../../Player"
#@onready var mainMenu = $CanvasLayer/Node2D
@onready var pause_menu = $"."
var paused = false
#@onready var Scene = "res://Scenes/Main_Menu.tscn"

#@onready var player = get_node("res://Scenes/Player.tscn")
#@onready var player = get_node("../Node2D/{Globals.PlayerId}")

func _physics_process(delta: float) -> void:
	if paused == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("ESC"):
		PauseMenu()

func _on_resume_pressed() -> void:
	PauseMenu()


func _on_quit_pressed() -> void:
	#mainMenu.exit_game()
	#$"../Player".exit_game(name.to_int())
	#player.exit_game(name.to_int())
	#Scene.exit_game(name.to_int())
	get_tree().quit()

func PauseMenu():
	if paused:
		pause_menu.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		pause_menu.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	paused = !paused
