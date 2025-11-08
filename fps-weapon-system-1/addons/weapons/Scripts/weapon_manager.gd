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
@export var weapons_stack : Array[WeaponResource]
@export var selected_weapoon : String = "AKM"

var current_weapon  : WeaponResource = null
enum {NULL , HITSCAN , PROJECTILE}
var barrel
var defaulth_pov : float

#ADS vars
var force_stop_ads : bool = false
var ads_progress : float = 0.0

func _ready():
	load_new_weapon(selected_weapoon)
	#defaulth_pov = PlayerContr.camera_3d.pov

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()
	if event.is_action_pressed("reload"):
		reload()


func _process(delta):
	handle_ads(delta)

func load_new_weapon(weapon_namae : String) -> void :
	for i in weapons_stack:
		if i.weapon_name == weapon_namae :
			current_weapon = i
	
	var weapon_scene = current_weapon.weapon_scene.instantiate()
	weapon_holder.position = current_weapon.position
	weapon_holder.rotation = Vector3(deg_to_rad(current_weapon.rotaion.x),deg_to_rad(current_weapon.rotaion.y),deg_to_rad(current_weapon.rotaion.z))
	
	weapon_holder.add_child(weapon_scene)
	WeaponAnimationPlayer = weapon_scene.get_node("AnimationPlayer")
	WeaponShootingAudioPLayer = weapon_scene.get_node("SHOOTsfx")
	barrel = weapon_scene.get_node("barrel_pos")
	PlayerContr.emit_signal("UpdateWeaponHud" , current_weapon.current_ammo)
	WeaponAnimationPlayer.animation_finished.connect(WeaponAnimationFinished)
	shooting_vfx_manager.load_muzzle_flash(current_weapon.muzzle_flash , barrel.global_position , barrel)
	
	
	

func WeaponAnimationFinished(anim_name:String) -> void:
	if anim_name == current_weapon.shooting_animation and current_weapon.Autofire and Input.is_action_pressed("shoot"):
		shoot()
	if anim_name == current_weapon.reload_animation:
		manage_ammo(current_weapon.mag_capacity)
		force_stop_ads = false

func shoot():
	if !WeaponAnimationPlayer.is_playing():
		if current_weapon.current_ammo != 0 :
			WeaponAnimationPlayer.play(current_weapon.shooting_animation)
			shooting_vfx_manager.show_muzle_flash()
			current_weapon.current_ammo -= 1
			PlayerContr.emit_signal("UpdateWeaponHud" , current_weapon.current_ammo)
			load_bullet()
			PlayerContr.CameraJuice_Component._add_shake(current_weapon.shoot_trauma)

		else:
			reload()


func reload() -> void :
	if current_weapon.current_ammo == current_weapon.mag_capacity:
		return
	if !WeaponAnimationPlayer.is_playing():
		WeaponAnimationPlayer.play(current_weapon.reload_animation)
		force_stop_ads = true
		

func manage_ammo(add_amt : float):
	current_weapon.current_ammo += min(add_amt , add_amt - current_weapon.current_ammo)
	PlayerContr.emit_signal("UpdateWeaponHud" , current_weapon.current_ammo)

func load_bullet() -> void:
	var bullet : Bullet = current_weapon.BulletScene.instantiate()
	add_child(bullet)
	bullet.global_position = barrel.global_position
	bullet._set_fire_projectile(current_weapon.spread , current_weapon.damage , current_weapon.weapon_range , shooting_vfx_manager)



func handle_ads(delta):
	if !current_weapon.CanADS and !current_weapon:
		return
	
	if force_stop_ads:
		# Force reset ADS before stopping
		weapon_holder.position = lerp(weapon_holder.position, current_weapon.position, 10.0*delta)
		PlayerContr.UiComponent.unhide_crosshair()
		current_weapon.bob_multiplier = current_weapon.default_bob_multiplier
		current_weapon.sway_multiplier = current_weapon.default_sway_multiplier
		return  # Exit after resetting
	
	if Input.is_action_pressed("ADS"):
		weapon_holder.position = lerp(weapon_holder.position , current_weapon.ads_pos , 10.0*delta)
		PlayerContr.UiComponent.hide_crosshair()
		current_weapon.bob_multiplier = current_weapon.ads_bob_multiplier
		current_weapon.sway_multiplier = current_weapon.ads_sway_multiplier
		current_weapon.side_rot_multiplier = current_weapon.ads_side_rot_multiplier
		#PlayerContr.camera_3d.pov = lerp(PlayerContr.camera_3d.pov , defaulth_pov-current_weapon.ads_zoom , 0.20)
	else :
		weapon_holder.position = lerp(weapon_holder.position , current_weapon.position , 10.0*delta)
		PlayerContr.UiComponent.unhide_crosshair()
		current_weapon.bob_multiplier = current_weapon.default_bob_multiplier
		current_weapon.sway_multiplier = current_weapon.default_sway_multiplier
