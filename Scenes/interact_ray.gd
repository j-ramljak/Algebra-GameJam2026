extends RayCast3D

func _ready() -> void:
	add_exception(owner)

func _physics_process(delta: float) -> void:
	$VBoxContainer/Label.text = ""
	if is_colliding():
		$VBoxContainer/Label.text = "E - use"
