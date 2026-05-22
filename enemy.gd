extends CharacterBody3D

var player = null

const SPEED = 4.0
const ATTACK_RANGE = 2.5

var dead = false

var HP = 3

@export var player_path :NodePath

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

@onready var attacking = true

var agrro = false

@onready var agrro_range: Area3D = $agrro
@onready var lose_agrro_range: Area3D = $lose_agrro




func _ready() -> void:
	player = get_node(player_path)

func _physics_process(delta: float) -> void:
	if !dead:
	
		#if agrro:
			#$Sprite3D.modulate = Color(0.853, 0.0, 0.507, 1.0)
		#else:
			#$Sprite3D.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
		var areas = $Area3D.get_overlapping_areas()
		for a in areas:
			if a.is_in_group("Player") and attacking == true:
				_target_in_range()
				$Timer.start()
				attacking = false
		
		if agrro:
			velocity = Vector3.ZERO
			nav_agent.set_target_position(player.global_transform.origin)
			var next_point = nav_agent.get_next_path_position()
			velocity = (next_point - global_transform.origin).normalized() * SPEED
			
			look_at(Vector3(player.global_position.x,global_position.y,player.global_position.z),Vector3.UP)
		
		move_and_slide()


func _target_in_range():
	if global_position.distance_to(player.global_position) < ATTACK_RANGE +1.0:
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir)
		attacking = true


func _on_timer_timeout() -> void:
	var areas = $Area3D.get_overlapping_areas()
	for a in areas:
		if a.is_in_group("Player"):
			_target_in_range()


func _on_agrro_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		agrro = true
		var rand = randi_range(0,8)
		if rand == 1:
			$AudioStreamPlayer3D.pitch_scale=randf_range(0.8,1.2)
			$AudioStreamPlayer3D.play()


func _on_lose_agrro_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		velocity = Vector3.ZERO
		agrro = false

func lose_hp() -> void:
	HP -= 1
	if HP < 1:
		var tween = get_tree().create_tween()
		$Visuals/MeshInstance3D.hide()
		$Visuals/Sprite3D.hide()
		dead = true
		
