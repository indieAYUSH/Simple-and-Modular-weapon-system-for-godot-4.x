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

func _ready():
	load_new_weapon(selected_weapoon)
	

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()
	if event.is_action_pressed("reload"):
		reload()

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


func shoot():
	if !WeaponAnimationPlayer.is_playing():
		if current_weapon.current_ammo != 0 :
			WeaponAnimationPlayer.play(current_weapon.shooting_animation)
			shooting_vfx_manager.show_muzle_flash()
			current_weapon.current_ammo -= 1
			PlayerContr.emit_signal("UpdateWeaponHud" , current_weapon.current_ammo)
			load_bullet()
			PlayerContr.CameraJuice_Component._add_shake(current_weapon.shoot_trauma)
			if !WeaponShootingAudioPLayer.playing:
				WeaponShootingAudioPLayer.playing = true
		else:
			reload()


func reload() -> void :
	if current_weapon.current_ammo == current_weapon.mag_capacity:
		return
	if !WeaponAnimationPlayer.is_playing():
		WeaponAnimationPlayer.play(current_weapon.reload_animation)
		current_weapon.current_ammo += min(current_weapon.mag_capacity , current_weapon.mag_capacity - current_weapon.current_ammo)

func load_bullet() -> void:
	var bullet : Bullet = current_weapon.BulletScene.instantiate()
	add_child(bullet)
	bullet.global_position = barrel.global_position
	bullet._set_fire_projectile(current_weapon.spread , current_weapon.damage , current_weapon.weapon_range , shooting_vfx_manager)
