extends Node2D

const Balloon = preload("res://Dialogues/balloonEND.tscn")

@export var dialogue_res : DialogueResource
@export var dialogue_start: String = "start"


func _ready() -> void:
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	#Balloon.Done.connect(AnimStart)
	balloon.Done.connect(AnimStart)
	balloon.start(dialogue_res,dialogue_start)

func AnimStart() -> void:
	$".".get_node("ExampleBalloon").Done.disconnect(AnimStart)
	$AnimationPlayer.play("EndCutscene")
	#print("Quiche is done")
