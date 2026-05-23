extends AnimationPlayer

@onready var player: CharacterBody3D = $"../.."


func _on_animation_started(anim_name: StringName) -> void:
	player.canMove = false
	player.canShoot = false
	player.velocity = Vector3.ZERO
