extends AnimationPlayer
@onready var player: CharacterBody3D = $"../../Player"


func _on_lever_interacted() -> void:
	player.canMove = false
	player.velocity = Vector3.ZERO
	active = true
	play("Cutscene")
