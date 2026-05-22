extends Area3D

const Balloon = preload("res://Dialogues/balloon.tscn")

@export var dialogue_res : DialogueResource
@export var dialogue_start: String = "start"

func action() -> void:
	#DialogueManager.show_dialogue_balloon(dialogue_res, dialogue_start)
	#DialogueManager.show_example_dialogue_balloon(dialogue_res, dialogue_start)
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_res,dialogue_start)
	$CollisionShape3D.disabled = true
