class_name CameraJuiceComponent extends Node3D

@export_category("Reffrences")
@export var camera : Camera3D
@onready var screen_shake = %screen_shake


@export_category("Camera Effects")
@export var Camera_tilt: bool
@export var Head_bob : bool
@export  var camer_fov_changes : bool
@export var camera_shake : bool


@export var Player : PlayerController
@export var lerp_speed : float = 15.0

@export_category("TILT VARS")
@export var roll_pitch : float = 0.031
@export var roll_side_rot : float  = 0.049
@export var max_speed : float = 9.0

@export_category("Headbob Vars")
@export var bob_pitch : float = 0.05
@export var bob_roll : float = 0.025
@export var bob_up :float = 0.0005
@export var bob_frequncy : float = 7.0
@export var offset_x_frequency : float

@export_category("camera_shake_vars")
@export var noise_texture : NoiseTexture2D
@export var trauma : float
@export var noise_speed : float = 50.0
@export var fade_out_speed : float = 4.0
@export var time : float
@export var max_offset : float = 10.0
@export var max_rotaion : float = 1.0



var _step_timer : float = 0.0

@export_category("FOV Vars")
var target_fov : float
@export var base_fov :float = 75.0

var rot_pivot_amount : float = 0.0
var rot_pivot_x_rot_amount : float = 0.0


func _ready():
	target_fov = base_fov

func _process(delta):
	camera_effects_manager(delta)


func camera_effects_manager(delta:float) -> void:
	var angles  = Vector3.ZERO
	var offsets = Vector3.ZERO
	
	var velocity = Player.velocity.length()
	
	
	#=======================CAMERA TILT things =================================================#
	if Player.velocity.length() > 0.01 and Camera_tilt:
		var speed_factor = clamp(velocity / max_speed, 0.0, 1.0)
		angles.x = lerp(rotation.x , (roll_pitch* Input.get_axis("forward","backward"))*speed_factor , delta*lerp_speed)
		angles.z = lerp(rotation.z , -(roll_side_rot*Input.get_axis("left","right"))*speed_factor , lerp_speed*delta )
	
	
	#Headbob Things ===============================================================
	
	var speed = Vector2(Player.velocity.x , Player.velocity.z).length()
	if speed > 0.1 and Player.is_on_floor()  :
		_step_timer += delta*(speed/bob_frequncy)
		_step_timer = fmod(_step_timer , 1.0)
	else:
		_step_timer = 0.0
	var bob_sin = sin(_step_timer* 2.0 * PI) *0.5
	
	if Head_bob and _can_headbob():
		var pitch_delta = bob_sin * deg_to_rad(bob_pitch) * speed
		angles.x -= pitch_delta
		
		var roll_delta = bob_sin*deg_to_rad(bob_roll) * speed
		angles.z -= roll_delta
		
		var up_delta = bob_sin * speed * bob_up
		offsets.y += up_delta
		#var side_delta = bob_sin * speed * offset_x_frequency * 0.5
		#offsets.x += side_delta 
		

	if camera_shake:
		time += delta
		trauma = max(trauma - delta * fade_out_speed, 0.0)
	
	if trauma > 0 and noise_texture:
		var noise = noise_texture.noise
		var amount = trauma * trauma
		
		# Direct shake (no smoothing)
		#screen_shake.position.x = noise.get_noise_1d(time * noise_speed) * max_offset * amount *2.0
		#screen_shake.position.y = noise.get_noise_1d(time * noise_speed + 100.0) * max_offset * amount * 2.0
		screen_shake.rotation.z = noise.get_noise_1d(time * noise_speed + 0.0) * deg_to_rad(max_rotaion) * amount *100.5
		
	else:
		screen_shake.position = Vector3.ZERO
		screen_shake.rotation.z = 0.0
	
	rotation = angles
	position = offsets
	
	camera.fov = lerp(camera.fov , target_fov , lerp_speed*delta)
	


func fov_manager(amount:float) -> void:
	target_fov = base_fov + amount

func rot_pivot_manager(amount:float) -> void:
	rot_pivot_amount = amount

func _can_headbob() -> bool:
	var state_name = Player.player_statemachine.current_state.name
	# Headbob is allowed if the player is NOT sliding or dashing
	return state_name != "SlideState" and state_name != "DashState"

func damage_anim() ->void:
	Player.player_animation.play("damage")

func _add_shake(_intensity : float) -> void :
	trauma = min(trauma+_intensity , 1.0)
