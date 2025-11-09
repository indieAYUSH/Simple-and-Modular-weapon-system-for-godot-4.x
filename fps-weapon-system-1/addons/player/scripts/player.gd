class_name PlayerController  extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 6

const gravity : float = 11.5

@onready var head = %head
@onready var crouched_collsion_shape = $crouched_collsion_shape
@onready var uncrouched_collision_shape = $uncrouched_collision_shape
@onready var obstacle_checker = %ShapeCast3D
@onready var player_animation = $PlayerAnimation
@onready var player_animation_tree : AnimationTree= $PlayerAnimationTree

@export_category("Component Refrences")
@export var player_statemachine : StateMachine
@export var CameraJuice_Component : CameraJuiceComponent
@export var UiComponent : PlayerUiComponent
@export var WPM : WeaponManager


@export_category("Movement Bools")
@export var can_dash : bool = true

@export var current_character : PlayerChracterStats

@export_category("Lean_Vars")
@export var lean_speed : float = 0.20
enum {LEFT = -1 , CENTER = 0 , RIGHT = 1}
@export var left_lean_collision : ShapeCast3D
@export var right_lean_collision : ShapeCast3D
var lean_tween  

signal  UpdateWeaponHud


var input_dir
@onready var camera_3d = %Camera3D
var can_lean : bool = true
#Signals
signal recieved_damage


func _ready():
	obstacle_checker.add_exception(self)
	left_lean_collision.add_exception(self)
	right_lean_collision.add_exception(self)
	Global.Player = self
	
func _physics_process(delta):
	
	# Add the gravity.
	

	# Handle jump.


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	lean_collision()
	move_and_slide()
	if  !can_lean:
		Lean(CENTER)






func _update_rotation(rot_value : Vector3) -> void :
	transform.basis = Basis.from_euler(rot_value)


func _input(event):
	
	if Input.is_action_just_released("lean_left") or  Input.is_action_just_released("lean_right"):
		if (!Input.is_action_pressed("lean_left") or !Input.is_action_pressed("lean_right")):
			Lean(CENTER)
	if Input.is_action_just_pressed("lean_left") and can_lean:
		Lean(LEFT)
	if Input.is_action_just_pressed("lean_right") and can_lean:
		Lean(RIGHT)

func update_movement(_speed : float , _acceleration : float , Deacceleration :float ):
	input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x , direction.x * _speed , _acceleration)
		velocity.z = lerp(velocity.z , direction.z * _speed , _acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0,  Deacceleration)
		velocity.z = move_toward(velocity.z, 0,  Deacceleration)



func update_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta


func crouch():
	#head.position.y =  lerp(head.position.y ,  crouch_depth , lerp_speed *delta)
	crouched_collsion_shape.disabled = false
	uncrouched_collision_shape.disabled = true
	player_animation.play("crouch")

func uncrouch():
	#head.position.y =  lerp(head.position.y , 0.6 + crouch_depth , lerp_speed *delta)
	crouched_collsion_shape.disabled = true
	uncrouched_collision_shape.disabled = false
	player_animation.play("uncrouch")

func dash(direction: Vector3, speed: float) -> void:
	if direction.length() == 0:
		return
	var _direction = direction.normalized()
	_direction.y = 0  
	velocity = _direction * speed  

func Lean(blend_amount):

	if lean_tween:
		lean_tween.kill()
	lean_tween = get_tree().create_tween()
	lean_tween.tween_property(player_animation_tree,"parameters/lean_blend/blend_amount" , blend_amount , lean_speed)

func lean_collision():
	player_animation_tree["parameters/lean_left_collison/blend_amount"] = lerp(
		float(player_animation_tree["parameters/lean_left_collison/blend_amount"]) , float(left_lean_collision.is_colliding()) , lean_speed
	)
	player_animation_tree["parameters/lesn_r_col/blend_amount"] = lerp(
		float(player_animation_tree["parameters/lesn_r_col/blend_amount"]) , float(right_lean_collision.is_colliding()) , lean_speed
	)
