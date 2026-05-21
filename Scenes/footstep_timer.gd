extends Timer

@onready var player: AudioStreamPlayer3D = $AudioStreamPlayer3D


func _ready() -> void:
	pass

func _on_timeout() -> void:
	player.play()
