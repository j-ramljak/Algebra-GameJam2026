extends CharacterBody3D

var player = null

const SPEED = 6
const ATTACK_RANGE = 2.5

var dead = false

var HP = 1

enum States {attack, idle, chase, die}

var state = States.idle

@export var player_path :NodePath = "../../Player"

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

@onready var attacking = false

var agrro = false

@onready var agrro_range: Area3D = $agrro
@onready var attack_area: Area3D = $AttackArea

@onready var knows = false

@onready var animatedS: AnimatedSprite3D = $Visuals/AnimatedSprite3D

@onready var detect: RayCast3D = $Detection



func _ready() -> void:
	player = get_node(player_path)
	animatedS.play("StandingM")

func _physics_process(delta: float) -> void:
	
	detect.look_at(player.global_position)
	detect.target_position = Vector3.FORWARD*100
	#detect.target_position = player.global_position - detect.global_position
	detect.force_raycast_update()
	
	#print(state)
	behaviours()
	
	move_and_slide()

func behaviours():
	if state == States.idle:
		velocity = Vector3.ZERO
		animatedS.play("StandingM")
	elif state == States.chase:
		if detect.get_collider() != null:
			if detect.get_collider().is_in_group("Player"):
				knows = true
		if knows:
			velocity = Vector3.ZERO
			animatedS.play("WalkingMelee")
			nav_agent.set_target_position(player.global_transform.origin)
			var next_point = nav_agent.get_next_path_position()
			velocity = (next_point - global_transform.origin).normalized() * SPEED
			look_at(Vector3(player.global_position.x,global_position.y,player.global_position.z),Vector3.UP)
		
	elif state == States.attack:
		var dir = global_position.direction_to(player.global_position)
		animatedS.play("Melee")
		velocity = Vector3.ZERO
		if attacking == false:
			player.hit(dir)
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
			$AttackArea/CollisionShape3D.disabled = true
			$agrro/CollisionShape3D.disabled = true
			$CollisionShape3D.disabled = true
			$DeathSFX2.pitch_scale=randf_range(0.75,1.25)
			$DeathSFX2.play()
			var tween = get_tree().create_tween()
			animatedS.play("StandingM")
			#animatedS.hide()
			tween.tween_property(animatedS, "modulate",Color(1.0, 1.0, 1.0, 0.0),0.5)
			#tween.tween_property($Visuals/AnimatedSprite3D,"")
			$Death/GPUParticles3D.emitting = true
			#$Death/GPUParticles3D2.emitting = true
			await get_tree().create_timer(4).timeout
			queue_free()


func _on_timer_timeout() -> void:
	attacking = false

func lose_hp() -> void:
	HP -= 1
	if HP < 1:
		state = States.die


func _on_agrro_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if detect.get_collider() != null:
			if detect.get_collider().is_in_group("Player"):
				knows = true
		
		if knows:
			animatedS.play("WalkingMelee")
			var rand = randi_range(0,5)
			if rand != 6:
				$AudioStreamPlayer3D.pitch_scale=randf_range(0.75,1.25)
				$AudioStreamPlayer3D.play()
		state = States.chase


func _on_agrro_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		knows = false
		state = States.idle


func _on_attack_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		state = States.attack


func _on_attack_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		$Timer.stop()
		attacking = false
		state = States.chase
