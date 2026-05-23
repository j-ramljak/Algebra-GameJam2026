extends Control

@export var menuSprite : Sprite2D

var buttons : Array

func _ready() -> void:
	buttons = get_tree().get_nodes_in_group("menu-button")

func _on_play_button_mouse_entered() -> void:
	AudioManager.playHover()
	menuSprite.frame = 1


func _on_credits_button_mouse_entered() -> void:
	AudioManager.playHover()
	menuSprite.frame = 0

func _on_play_button_pressed() -> void:
	AudioManager.playSelect()
	for button in buttons:
		button.visible = false
	$PlayColor.visible = true
	await(get_tree().create_timer(2).timeout)
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")


func _on_credits_button_pressed() -> void:
	AudioManager.playSelect()
	for button in buttons:
		button.visible = false
	menuSprite.visible = false
	$Credits.visible = true


func _on_quit_button_mouse_entered() -> void:
	AudioManager.playHover()
	menuSprite.frame = 2


func _on_quit_button_pressed() -> void:
	AudioManager.playSelect()
	for button in buttons:
		button.visible = false
	$QuitColor.visible = true
	await(get_tree().create_timer(2).timeout)
	get_tree().quit()
	


func _on_back_button_mouse_entered() -> void:
	AudioManager.playHover()


func _on_back_button_pressed() -> void:
	AudioManager.playSelect()
	for button in buttons:
		button.visible = true
	menuSprite.visible = true
	$Credits.visible = false
