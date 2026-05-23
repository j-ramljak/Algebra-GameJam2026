extends Node3D

func end() -> void:
	#Global.last_level_pased += 1
	get_tree().change_scene_to_file("res://Scenes/EndCutscene.tscn")
