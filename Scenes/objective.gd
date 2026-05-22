extends Node3D

func _ready() -> void:
	$Timer.start()


func _on_timer_timeout() -> void:
	$AnimationPlayer.play("Objective")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$"../../../Complete/AnimationPlayer".play("complete")
