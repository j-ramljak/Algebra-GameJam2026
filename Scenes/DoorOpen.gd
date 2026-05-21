extends AnimatableBody3D

func _on_lever_interacted() -> void:
	#print("hihi")
	#$"../Lever".get_node("CollisionShape3D").
	var tween = get_tree().create_tween()
	tween.tween_property($".","position",position+Vector3(0,5,0),1.0)
