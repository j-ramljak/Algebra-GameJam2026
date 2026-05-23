class_name Interactable
extends StaticBody3D

signal interacted(body)

@export var prompt_msg = "Interact"
@export var prompt_act = "interact"

#func get_prompt():
	#var key_name = ""
	#for action in InputMap.get_action_list(prompt_act):
		#if action is InputEventKey:
			#key_name = OS.get_scancode_string(action.scancode)

func interact(body):
	interacted.emit()
	$AudioStreamPlayer.play()
	$CollisionShape3D.disabled=true
	#emit_signal("interacted", body)
