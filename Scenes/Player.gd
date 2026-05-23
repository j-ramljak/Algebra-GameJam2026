extends CharacterBody3D

func _enter_tree() -> void:
	pass
	#set_multiplayer_authority(name.to_int())
	#print(get_multiplayer_authority())

var SPEED = 5.0
const SENSITIVITY = 0.005
#const JUMP_VELOCITY = 4.5
const BOBF = 2.5
const BOBA = 0.08
var t_bob = 0.0
var t_bob_g = 0.0
var CamH = Vector3(0,0.697,0)
var GunH = Vector2(1414.0,431.0)

var HP = 3

var canBeHurt = true
@onready var hurt_timer: Timer = $HurtTimer

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var body = $"."
#@onready var sub_cam: Camera3D = %SubCam

@onready var FlashShader: ColorRect = $Head/Camera3D/CanvasLayer/ColorRect

@onready var actionable_finder: Area3D = $ActionableFinder

@onready var hurt: Sprite2D = $CanvasLayer/Hurt

@onready var gun_anim: AnimatedSprite2D = $Pistol_stuff/GunAnim


#@onready var MainMenu = preload("res://Scripts/main_menu.gd")
#var PClass = MainMenu.playerClass
#weapons
#@onready var shotgun: MeshInstance3D = %Shotgun


#@onready var ray_container: Node3D = $Head/Camera3D/RayContainer
@onready var ray_pistol: Node3D = $Head/Camera3D/RayContainer/RayCast3D
@onready var bullet_decal = preload("res://Scenes/bullet_decal.tscn")

@onready var FootLickTimer: Timer = $FootStepTimer



#var shotgunDamage = 1
#var shotgunSpread = 10
@export var canShoot = true
@export var canMove = true


#@onready var MainMenu = get_tree().get_root().get_node("Game/CanvasLayer/Main_Menu")
#var PClass = "none"
#var PClass = MainMenu.playerClass
#@onready var pause_menu = $pause_menu
@onready var pause_menu: Control = $"../pause_menu"
var paused = false
var dead = false
#var gunShow = false
#var torchOut = true

func _ready():
	FlashShader.hide();
	
	if !canShoot:
		$Pistol_stuff/GunAnim.hide()
	
	FootLickTimer.stop()
	
	$CanvasLayer/Hurt.modulate = Color(255.014, 255.014, 255.014, 0.0)
	
	#resume.pressed().connect(resume_pressed)
	#quit.pressed().connect(quit_pressed)
	
	pause_menu.r_pressed.connect(resume_pressed)
	pause_menu.q_pressed.connect(quit_pressed)
	
	#print(get_tree().get_root().get_node("Game/CanvasLayer/Main_Menu"))
	#PClass = MainMenu.playerClass
	$Pistol_stuff/Flash.hide()
	#set_multiplayer_authority(name.to_int())
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#print(name.to_int())
	#print(is_multiplayer_authority())
	#camera.current = is_multiplayer_authority()
	#sub_cam.current = is_multiplayer_authority()
	#randomize()
	
	#for r in ray_container.get_children():
			#r.target_position.x = randf_range(shotgunSpread,-shotgunSpread)
			#r.target_position.y = randf_range(shotgunSpread,-shotgunSpread)
	
	#shotgun.hide()

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and is_multiplayer_authority() and !dead:
		body.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))


func _process(delta: float) -> void:
	pass
	#sub_cam.set_global_transform(camera.get_global_transform())
	#fire_shotgun()

func _physics_process(delta: float) -> void:
	
	if dead: return
	
	var actionables = actionable_finder.get_overlapping_areas()
	if actionables.size() > 0:
		var i=0
		for thing in actionables:
			if thing.is_in_group("Trigger"):
				actionables[i].action()
			i=i+1
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	"""if Input.is_action_just_pressed("Slot1") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if gunShow == false:
			shotgun.show()
			gunShow = true
		elif gunShow == true:
			shotgun.hide()
			gunShow = false"""
	
	"""if Input.is_action_just_pressed("F") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if torchOut == false:
			$Head/OmniLight3D.show()
			torchOut = true
		else:
			$Head/OmniLight3D.hide()
			torchOut = false"""
	
	
	
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("ESC"):
		if paused:
			pause_menu.hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			pause_menu.show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		paused = !paused
	
	if Input.is_action_pressed("Run"):
		SPEED=10.0
		FootLickTimer.wait_time = 0.45
	else:
		SPEED=5.0
		FootLickTimer.wait_time = 0.9
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#if not paused:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		
		
		if canMove:
			var input_dir := Input.get_vector("Left", "Right", "Forward", "Backwards")
			var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			if direction:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
		
		var vel =get_real_velocity().length()
		
		#headbob
		if Input.get_vector("Left", "Right", "Forward", "Backwards") == Vector2.ZERO:
			#camera.transform.origin = lerp(camera.transform.origin, Vector3.ZERO, 0.1)
			camera.transform.origin = lerp(camera.transform.origin, CamH, 0.1)
			$Pistol_stuff/GunAnim.transform.origin = lerp($Pistol_stuff/GunAnim.transform.origin, GunH, 0.1)
			FootLickTimer.stop()
		elif vel > 1:
			if FootLickTimer.is_stopped():
				FootLickTimer.start()
			
			t_bob += delta * velocity.length()
			camera.transform.origin = _headbob(t_bob)
			
			#Gun BOB
			t_bob_g += delta * velocity.length()
			
			
			var pos = Vector2.ZERO
			pos.y = sin(t_bob_g * BOBF) * BOBA*500
			pos = lerp($Pistol_stuff/GunAnim.transform.origin, pos+GunH, 0.1)
			#pos.x = cos(time * BOBF/2) * BOBA
			$Pistol_stuff/GunAnim.transform.origin = pos
			
		
		
		if Input.is_action_just_pressed("Fire"):
			fire_gun()
			#rpc("fire_shotgun")
		
		move_and_slide()
		

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOBF) * BOBA
	pos = lerp(camera.transform.origin, pos+CamH, 0.1)
	#pos.x = cos(time * BOBF/2) * BOBA
	return pos

#@rpc("any_peer", "call_local")
func fire_gun():
	#if Input.is_action_just_pressed("Fire") and PlayerSingletons.playerClass == "Gunslinger":
	if canShoot:
		gun_anim.play("shoot")
		$Pistol_stuff/Gunshot.play()
		canShoot = false
		$Pistol_stuff/Timer.start()
		$Pistol_stuff/Flash_timer.start()
		#FlashShader.show()
		
		 
		#$Pistol_stuff/Flash.show()
		#$Pistol_stuff/Flash2.show()
		ray_pistol.force_raycast_update()
		#ray_pistol.target_position.x = randf_range(shotgunSpread,-shotgunSpread)
		#ray_pistol.target_position.y = randf_range(shotgunSpread,-shotgunSpread)
		#var b = bullet_decal.instantiate()
			
		#r.get_collider().add_child(b)
		#get_tree().get_root().add_child(b)
		"""get_tree().get_root().get_node("Game/Bullet_decals").call_deferred("add_child",b,true)
		#print(b.name)
		var bc = b.get_child(0)
		#bc.global_transform.origin = ray_pistol.get_collision_point()
		bc.position = ray_pistol.get_collision_point()
		if ray_pistol.get_collision_normal() != Vector3.UP:
			bc.look_at(ray_pistol.get_collision_point()+ray_pistol.get_collision_normal(), Vector3.UP)
			bc.transform = bc.transform.rotated_local(Vector3.RIGHT, PI/2.0)
			#rotate(normal, randf_range(0, 2*PI)
		
		
		bc.rotate(ray_pistol.get_collision_normal(),randf_range(0, 2*PI) )"""
		
		var b = bullet_decal.instantiate()
		get_tree().get_root().get_node("Game/SubC/Sub/Bullet_decals").call_deferred("add_child",b,true)
		var bc = b.get_child(0)
		bc.global_transform = Transform3D(Quaternion(Vector3.UP, ray_pistol.get_collision_normal()),ray_pistol.get_collision_point())
		randomize()
		bc.rotate(ray_pistol.get_collision_normal(),randf_range(0, 2*PI) )
		$Pistol_stuff/Gunshot.pitch_scale = randf_range(0.9,1.1)
		var col = $Head/Camera3D/RayContainer/RayCast3D.get_collider()
		if $Head/Camera3D/RayContainer/RayCast3D.get_collider() != null:
			if col.is_in_group("Enemy"):
				col.lose_hp()
		#$Pistol_stuff/AudioStreamPlayer3D.play()
		await get_tree().create_timer(0.25).timeout
		gun_anim.stop()
		gun_anim.frame = 0
		#$Shotgun_stuff/Flash.hide()


func _on_timer_timeout() -> void:
	if canShoot == false:
		$Pistol_stuff/Shell.play()
	canShoot = true

func resume_pressed() -> void:
	pause_menu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	paused = false

func quit_pressed() -> void:
	get_tree().quit()

func _on_flash_timer_timeout() -> void:
	FlashShader.hide()
	#$Pistol_stuff/Flash.hide()
	#$Pistol_stuff/Flash2.hide()


func hit(dir) -> void:
	if canBeHurt:
		hurt.modulate = Color(255.014, 255.014, 255.014, 1.0)
		var tween = get_tree().create_tween()
		tween.tween_property($CanvasLayer/Hurt,"modulate",Color(255, 255, 255, 0.0),0.5)
		velocity += Vector3(dir.x*10.0,0.5,dir.z*10.0)
		HP -= 1
		update_hp()
		$HurtTimer.start()
		canBeHurt=false


func update_hp() -> void:
	if dead: return
	match HP:
		2:
			$Health/CanvasGroup/Third.show()
		1:
			$Health/CanvasGroup/Second.show()
		_:
			dead = true
			canShoot = false
			$PlayerDeath.play()
			$Health/CanvasGroup/First.show()
			$Health/AnimationPlayer.play("Death")
			await get_tree().create_timer(4).timeout
			get_tree().change_scene_to_file("res://Scenes/level_select.tscn")


func _on_hurt_timer_timeout() -> void:
	canBeHurt = true
