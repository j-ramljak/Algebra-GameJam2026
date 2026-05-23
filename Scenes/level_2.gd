extends Node3D

@onready var enemies: Node3D = $SubC/Sub/Enemies

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enemies.get_child_count() < 1:
		$SubC/Sub/Complete/AnimationPlayer.play("complete")
