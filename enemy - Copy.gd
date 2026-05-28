extends CharacterBody3D

var player = null

const SPEED = 6
const ATTACK_RANGE = 2.5

var dead = false

var HP = 1

@export var player_path :NodePath = "../../Player"

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

@onready var attacking = true

var agrro = false

@onready var agrro_range: Area3D = $agrro
@onready var lose_agrro_range: Area3D = $lose_agrro


@onready var animatedS: AnimatedSprite3D = $Visuals/AnimatedSprite3D

@onready var detect: RayCast3D = $Detection



func _ready() -> void:
	player = get_node(player_path)
	animatedS.play("StandingM")

func _physics_process(delta: float) -> void:
	if !dead:
		
		detect.target_position = player.global_position - detect.global_position
		detect.force_raycast_update()
		CheckForPlayer($agrro) #wrong area but works lmaoooo
	
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
	if !dead:
		if global_position.distance_to(player.global_position) < ATTACK_RANGE +1.0:
			var dir = global_position.direction_to(player.global_position)
			animatedS.play("Melee")
			velocity = Vector3.ZERO
			player.hit(dir)
			attacking = true


func _on_timer_timeout() -> void:
	var areas = $Area3D.get_overlapping_areas()
	for a in areas:
		if a.is_in_group("Player"):
			_target_in_range()


func _on_agrro_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		CheckForPlayer(area)

func CheckForPlayer(area: Area3D) -> void:
	for col in $agrro.get_overlapping_areas():
		if detect.get_collider() != null and col.is_in_group("Player") and agrro == false:
			if detect.get_collider().is_in_group("Player"):
				agrro = true
				animatedS.play("WalkingMelee")
				var rand = randi_range(0,8)
				if rand == 1:
					$AudioStreamPlayer3D.pitch_scale=randf_range(0.8,1.2)
					$AudioStreamPlayer3D.play()

func _on_lose_agrro_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		velocity = Vector3.ZERO
		agrro = false
		animatedS.play("StandingM")

func lose_hp() -> void:
	HP -= 1
	if HP < 1:
		$CollisionShape3D.disabled = true
		$Area3D/CollisionShape3D.disabled = true
		$agrro/CollisionShape3D.disabled = true
		$lose_agrro/CollisionShape3D.disabled = true
		$DeathSound.play()
		var tween = get_tree().create_tween()
		$Visuals/MeshInstance3D.hide()
		$Visuals/Sprite3D.hide()
		animatedS.hide()
		animatedS.play("StandingM")
		#tween.tween_property($Visuals/AnimatedSprite3D,"")
		dead = true
		$Death/GPUParticles3D.emitting = true
		$Death/GPUParticles3D2.emitting = true
		await get_tree().create_timer(4).timeout
		queue_free()
		


func _on_area_3d_area_exited(area: Area3D) -> void:
	animatedS.play("WalkingMelee")
