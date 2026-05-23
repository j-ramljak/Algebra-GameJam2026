extends TextureButton
@export var been_pressed = false
@export var num := 1
@export var just_finished = false
@export var finished = false
@export var level_scene:PackedScene = null

func _ready():
	$Label.text = str(num)
	if finished:
		$AnimatedSprite2D.animation = "x"
		$AnimatedSprite2D.frame = 10
		
		been_pressed = true
		disabled = true
	if just_finished:
		$AnimatedSprite2D.play("x")
		been_pressed = true
		disabled = true
	if been_pressed:
		disabled = true
		
func update():
	if finished:
		$AnimatedSprite2D.animation = "x"
		$AnimatedSprite2D.frame = 10
		
		been_pressed = true
		disabled = true
	if just_finished:
		AudioManager.playMarkerSelect()
		$AnimatedSprite2D.play("x")
		been_pressed = true
		disabled = true
	if been_pressed:
		disabled = true
	
func _on_button_up():
	if not been_pressed:
		if level_scene:
			get_tree().change_scene_to_packed(level_scene)
		been_pressed = true
		disabled = true


func _on_mouse_entered():
	if not been_pressed:
		AudioManager.playMarkerSelect()
		$AnimatedSprite2D.play("o")


func _on_mouse_exited():
	if not been_pressed:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("default")
