extends CharacterBody3D

var player = null
var state_machine

const SPEED = 4.0
const ATTACK_RANGE = 2.5

@export var player_path :NodePath

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

@onready var attacking = true

func _ready() -> void:
	player = get_node(player_path)

func _physics_process(delta: float) -> void:
	
	var areas = $Area3D.get_overlapping_areas()
	for a in areas:
		if a.is_in_group("Player") and attacking == true:
			$Timer.start()
			attacking = false
	
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
