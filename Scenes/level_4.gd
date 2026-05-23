extends Node3D

@onready var enemies: Node3D = $SubC/Sub/Enemies
@export var PENT=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("kids: ", enemies.get_child_count(), "; GotKey: ",GotKey)
	if enemies.get_child_count() < 1 and PENT:
		$SubC/Sub/Complete/AnimationPlayer.play("complete")
