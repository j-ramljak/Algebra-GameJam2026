extends RayCast3D

func _ready() -> void:
	add_exception(owner)

func _physics_process(delta: float) -> void:
	$VBoxContainer/Label.text = ""
	if is_colliding():
		var detected = get_collider()
		
		if detected is Interactable:
			$VBoxContainer/Label.text = "E - use"
			
			if Input.is_action_just_pressed("interact"):
				detected.interact(owner)
