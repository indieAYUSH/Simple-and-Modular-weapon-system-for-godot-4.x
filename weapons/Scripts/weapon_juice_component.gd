extends Node3D
class_name WeaponJuiceComponent

var parent : WeaponManager

@export_category("refrences")
@export var player_controller : PlayerController

@export_category("effects")
@export var weapon_tilt : bool
@export  var weapon_bob : bool

@export_category("weapon_tilt")
@export var roll_pitch : float 
@export var roll_side_rot  : float

@export_category("weapon_bob")
@export var frequency  : float
@export var amplitude : float
var bob_phase : float
var bob_intensity : float

@export_category("others")
@export var lerp_speed : float = 15.0

func _ready():
	parent = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	parent.position.x = lerp(parent.position.x , 0.0 , 6.0*delta)
	parent.position.y = lerp(parent.position.y , 0.0 , 6.0*delta)
	parent.rotation.y = lerp(parent.rotation.y , 0.0 , 6.0*delta)
	parent.rotation.x = lerp(parent.rotation.x , 0.0 , 6.0*delta)

	weapon_juice(delta)


func _sway(amount: Vector2) -> void :
	parent.position.x += amount.x * 0.09 * parent.current_weapon.sway_multiplier
	parent.position.y += amount.y * 0.09 * parent.current_weapon.sway_multiplier
	
	parent.rotation.x += deg_to_rad(amount.x * 0.08)  * parent.current_weapon.sway_multiplier
	parent.rotation.y += deg_to_rad (amount.y * 0.05)  * parent.current_weapon.sway_multiplier


func weapon_juice(delta : float ) -> void:
	var angles  : Vector3
	var offset  : Vector3
	
	var velocity = player_controller.velocity.length()
	
	if velocity > 0.01 and weapon_tilt:
		angles.x = lerp(angles.x , (roll_pitch*Input.get_axis("forward","backward"))  , delta*lerp_speed)
		angles.z = lerp(angles.z , -(roll_side_rot*Input.get_axis("left","right"))  , delta*lerp_speed)

	if velocity > 0.01 and player_controller.is_on_floor() and weapon_bob and _can_headbob():
		var speed_factor = clamp(velocity/9.5 , 0.0 , 1.0)
		bob_phase += frequency*speed_factor*delta*velocity
		bob_intensity = amplitude
		var p = position
		p.x =  sin(bob_phase*0.5) * amplitude * parent.current_weapon.bob_multiplier
		p.y = sin(bob_phase)*amplitude * parent.current_weapon.bob_multiplier
		offset = p
	else :
		offset = lerp(offset , Vector3.ZERO , delta*8.0)
		
	
	rotation = angles
	position = offset

	

func _can_headbob() -> bool:
	var state_name = player_controller.player_statemachine.current_state.name
	# Headbob is allowed if the player is NOT sliding or dashing
	return state_name != "SlideState" and state_name != "DashState"
