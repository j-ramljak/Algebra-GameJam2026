extends CharacterBody3D

var player = null
var state_machine

const SPEED = 4.0
const ATTACK_RANGE = 2.5
const TURN_SPEED = 2.0

@export var player_path :NodePath

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

@onready var attacking = false

@onready var CanShoot = true

var agrro = false
var chasing = false

@onready var agrro_range: Area3D = $agrro
@onready var lose_agrro_range: Area3D = $lose_agrro

@onready var eyes: Node3D = $Eyes



func _ready() -> void:
	player = get_node(player_path)

func _physics_process(delta: float) -> void:
	
	if (not chasing) and (agrro):
		attacking = true
	else: attacking = false
	
	if agrro:
		$Sprite3D.modulate = Color(0.853, 0.0, 0.507, 1.0)
	elif chasing:
		$Sprite3D.modulate = Color(0.0, 0.82, 0.35, 1.0)
	else:
		$Sprite3D.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	
	$RayCast3D.force_raycast_update()
	
	
	if (agrro) and (not chasing):
		#attacking = true
		velocity = Vector3.ZERO
		#nav_agent.set_target_position(player.global_transform.origin)
		#var next_point = nav_agent.get_next_path_position()
		#velocity = (next_point - global_transform.origin).normalized() * SPEED
		
		eyes.look_at(Vector3(player.global_position.x,global_position.y,player.global_position.z),Vector3.UP)
		rotate_y(deg_to_rad(eyes.rotation.y*TURN_SPEED))
	else:
		pass
		#attacking = false
	
	if (chasing) and (not agrro):
		#attacking = false
		velocity = Vector3.ZERO
		nav_agent.set_target_position(player.global_transform.origin)
		var next_point = nav_agent.get_next_path_position()
		velocity = (next_point - global_transform.origin).normalized() * SPEED
		look_at(Vector3(player.global_position.x,global_position.y,player.global_position.z),Vector3.UP)
	
	if (attacking == true) and (CanShoot == true):
		CanShoot = false
		$Timer.start()
		
	
	
	
	print("chasing: ", chasing, "; agrro: ", agrro, "; attacking: ",attacking, "; CanShoot: ", CanShoot)
	
	move_and_slide()


func _target_in_range():
	#if global_position.distance_to(player.global_position) < ATTACK_RANGE +1.0:
	var dir = Vector3(0,0,0)
	#print($RayCast3D.get_collider())
	if $RayCast3D.get_collider() != null:
		if $RayCast3D.get_collider().is_in_group("Player"):
			player.hit(dir)
	#attacking = true


func _on_timer_timeout() -> void:
	if attacking and agrro and not chasing:
		_target_in_range()
	CanShoot = true

func _on_agrro_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		agrro = true
		chasing = false
		#attacking = true


func _on_lose_agrro_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		velocity = Vector3.ZERO
		agrro = false
		chasing = false
		#attacking = false


func _on_chase_area_exited(area: Area3D) -> void:
	chasing = true
	agrro = false
	#attacking = false
