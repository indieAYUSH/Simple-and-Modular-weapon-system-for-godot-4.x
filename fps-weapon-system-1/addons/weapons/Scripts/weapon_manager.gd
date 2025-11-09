extends Node3D
class_name WeaponManager


#	NodeReferenc
@export_category("Refrences")
@export var WeaponAnimationPlayer : AnimationPlayer
@export var weapon_juice_component : WeaponJuiceComponent
@export var shooting_vfx_manager : ShootingVFXManager
@export var PlayerContr : PlayerController
@export var WeaponShootingAudioPLayer : AudioStreamPlayer
var debug_draw_enabled := true
@onready var weapon_holder = $WeaponJuice/weapon_holder

@export_category("Vars")
@export var weapon_resources : Array[WeaponResource]
@export var selected_weapoon : String = ""
@export var load_out : Array[String]
@export var melee_weapon : String
 
var weapon_index : int = 0
var weapon_stack : Array
var weapon_list  = {}
var current_weapon  : WeaponResource = null
var cw_node 
#multiplies

var bob_multiplier : float
var sway_multiplier : float
var side_rot_multiplier  :float

enum {NULL , MELEE , GUN}
var barrel
var defaulth_pov : float

#ADS vars
var force_stop_ads : bool = false
var ads_progress : float = 0.0

func _ready():
	Intialize()
	#defaulth_pov = PlayerContr.camera_3d.pov

func _input(event):
	if event.is_action_pressed("shoot"):
		use_weapon()
	
	if event.is_action_pressed("slot1"):
		exit_weapon()
		change_wapon(0)
	if event.is_action_pressed("slot2"):
		exit_weapon()
		change_wapon(1)
	#if event.is_action_pressed("slot3"):
		#weapon_index = 2


func _process(delta):
	handle_ads(delta)


func Intialize():
	for weapon in weapon_resources:
		weapon_list[weapon.weapon_name] = weapon
	for i in load_out:
		weapon_stack.push_back(weapon_list[i])
	selected_weapoon = load_out[weapon_index]
	load_weapon(weapon_stack)

func load_weapon(weapons_rs) -> void :
	for i in weapons_rs:
		var w = i.weapon_scene.instantiate()
		weapon_holder.add_child(w)
	enter_weapon(weapon_index)


func use_weapon():
	if current_weapon == null:
		return

	match current_weapon.type:
		NULL:
			pass
		GUN:
			cw_node.shoot()
		MELEE:
			cw_node.attack()



#
#
func handle_ads(delta):
	if !current_weapon:
		return
	
	if force_stop_ads:
		# Force reset ADS before stopping
		weapon_holder.position = lerp(weapon_holder.position, current_weapon.position, 10.0*delta)
		PlayerContr.UiComponent.unhide_crosshair()
		bob_multiplier = current_weapon.default_bob_multiplier
		sway_multiplier = current_weapon.default_sway_multiplier
		return  # Exit after resetting
	
	if Input.is_action_pressed("ADS")and current_weapon.CanADS :
		weapon_holder.position = lerp(weapon_holder.position , current_weapon.ads_pos , 10.0*delta)
		PlayerContr.UiComponent.hide_crosshair()
		bob_multiplier = current_weapon.ads_bob_multiplier
		sway_multiplier = current_weapon.ads_sway_multiplier
		side_rot_multiplier = current_weapon.ads_side_rot_multiplier
		#PlayerContr.camera_3d.pov = lerp(PlayerContr.camera_3d.pov , defaulth_pov-current_weapon.ads_zoom , 0.20)
	else :
		weapon_holder.position = lerp(weapon_holder.position , current_weapon.position , 10.0*delta)
		PlayerContr.UiComponent.unhide_crosshair()
		bob_multiplier = current_weapon.default_bob_multiplier
		sway_multiplier = current_weapon.default_sway_multiplier

func exit_weapon():
	current_weapon = null
	if cw_node:
		cw_node.exit()
	

func change_wapon(wp_index:int):
	if wp_index == weapon_index:
		return
	if current_weapon:
		current_weapon = null
	if cw_node != null:
		cw_node = null
	weapon_index = wp_index
	exit_weapon()

func enter_weapon(weapon_index : int):
	current_weapon = weapon_stack[weapon_index]
	print(current_weapon)
	weapon_holder.position = current_weapon.position
	weapon_holder.rotation = Vector3(deg_to_rad(current_weapon.rotaion.x),deg_to_rad(current_weapon.rotaion.y),deg_to_rad(current_weapon.rotaion.z))
	cw_node = weapon_holder.get_node(current_weapon.weapon_name)
	if cw_node:
		cw_node.enter()
