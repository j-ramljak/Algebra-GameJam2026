extends AnimationPlayer
@onready var player: CharacterBody3D = $"../../Player"


func _on_lever_interacted() -> void:
	player.canMove = false
	active = true
	play("Cutscene")
