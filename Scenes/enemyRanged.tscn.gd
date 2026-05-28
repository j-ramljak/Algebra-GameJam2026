extends CharacterBody3D

var player = null

const SPEED = 4.0
const ATTACK_RANGE = 2.5
const TURN_SPEED = 4.0

@onready var animS: AnimatedSprite3D = $Visuals/AnimatedSprite3D

@onready var dead = false

@export var player_path :NodePath = "../../Player"

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

@onready var attacking = false

@onready var CanShoot = true

enum States {attack, idle, chase, die}

var state = States.idle

@onready var agrro_range: Area3D = $agrro
@onready var lose_agrro_range: Area3D = $lose_agrro

@onready var eyes: Node3D = $Eyes

var HP = 1

@onready var detect: RayCast3D = $Detection

@onready var knows = false

func _ready() -> void:
	player = get_node(player_path)
	animS.play("Idle")

var sees_player = false

var in_aggro = false
var in_chase = false

func _physics_process(delta: float) -> void:
	$RayCast3D.force_raycast_update()
	
	#detect.target_position = player.global_position - detect.global_position
	detect.look_at(player.global_position)
	detect.target_position = Vector3.FORWARD*100
	detect.force_raycast_update()
	
	eyes.look_at(Vector3(player.global_position.x,global_position.y,player.global_position.z),Vector3.UP)
	rotate_y(deg_to_rad(eyes.rotation.y*TURN_SPEED))
	
	sees_player = false
	
	if detect.is_colliding():
		if detect.get_collider().is_in_group("Player"):
			sees_player = true
		else:
			sees_player = false
			#knows = true
	
	if sees_player:
		knows = true
	
	
	if in_aggro and sees_player:
		state = States.attack
	elif in_chase and knows:
		state = States.chase
	elif in_chase:
		state = States.idle
	
	behaviours()
	
	move_and_slide()


func behaviours():
	if state == States.idle:
		velocity = Vector3.ZERO
		animS.play("Idle")
	elif state == States.chase:
		if knows:
			animS.play("Walk")
			nav_agent.set_target_position(player.global_transform.origin)
			var next_point = nav_agent.get_next_path_position()
			velocity = (next_point - global_transform.origin).normalized() * SPEED
			look_at(Vector3(player.global_position.x,global_position.y,player.global_position.z),Vector3.UP)
		else:
			velocity = Vector3.ZERO
			animS.play("Idle")
		
	elif state == States.attack:
		var dir = global_position.direction_to(player.global_position)
		velocity = Vector3.ZERO
		if sees_player and not attacking:
			animS.play("Aim")
			$Timer.start()
			attacking = true
			
	elif state == States.die:
		if not dead:
			dead = true
			#$CollisionShape3D.disabled = true
			#$Area3D/CollisionShape3D.disabled = true
			#$agrro/CollisionShape3D.disabled = true
			#$lose_agrro/CollisionShape3D.disabled = true
			$Timer.stop()
			attacking = false
			$agrro/CollisionShape3D.disabled = true
			$chase/CollisionShape3D.disabled = true
			$CollisionShape3D.disabled = true
			$DeathSFX2.pitch_scale=randf_range(0.75,1.25)
			$DeathSFX2.play()
			var tween = get_tree().create_tween()
			animS.play("Idle")
			#animatedS.hide()
			tween.tween_property(animS, "modulate",Color(1.0, 1.0, 1.0, 0.0),0.5)
			#tween.tween_property($Visuals/AnimatedSprite3D,"")
			$Death/GPUParticles3D.emitting = true
			#$Death/GPUParticles3D2.emitting = true
			await get_tree().create_timer(4).timeout
			queue_free()

func _on_timer_timeout() -> void:
	
	if $RayCast3D.get_collider() != null:
		if $RayCast3D.get_collider().is_in_group("Player"):
			var dir = Vector3.ZERO
			player.hit(dir)
	$Visuals/AudioStreamPlayer3D.play()
	animS.play("Shoot")
	CanShoot = true


func lose_hp() -> void:
	HP -= 1
	if HP < 1:
		state = States.die


func _on_agrro_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		in_aggro = true
		#if sees_player:
			#state = States.attack


func _on_agrro_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		in_aggro = false
		$Timer.stop()
		attacking = false
		state = States.chase
		#$Timer.stop()
		#attacking = false
		#state = States.chase


func _on_chase_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		in_chase = true
		#if detect.get_collider() != null:
			#if detect.get_collider().is_in_group("Player"):
				#knows = true
		#if sees_player:
			#var rand = randi_range(0,5)
			#if rand != 6:
				#$AudioStreamPlayer3D.pitch_scale=randf_range(0.75,1.25)
				#$AudioStreamPlayer3D.play()
			#state = States.chase


func _on_chase_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		in_chase = false
		state = States.idle
