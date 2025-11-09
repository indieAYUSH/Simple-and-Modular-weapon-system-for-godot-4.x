extends Weapon
class_name Gun


@export_category("GunStats")
@export var Damage : float
@export var GunRange : float
@export var spread : Vector2

@export_group("ammostats")
@export var current_ammo : int
@export var magzine : int
@export var reserved_ammo : int
@export var max_ammo : int


@export_group("Animations")
@export var pull_out_anim : String
@export var pull_away_anim : String
@export var shooting_anim : String
@export var reload_anim : String
@export var out_of_ammo_anim : String

@export_group("gun_bool")
@export var autofire : bool
#@export var can_ads : bool 
@export_flags("PROJECTILE" , "HITSCAN") var type

@export_group("required_scenes")
@export var bullet_scne : PackedScene
@export var muzzle_flash_scne : PackedScene

@export_group("ADS_SETTNGS")

@export_group("References")
@export var barrel : Node3D
@export var ShootinVfxManager : ShootingVFXManager

#vars



func _ready():
	#holder = get_parent()
	#weapon_manager = holder.get_parent().get_parent()
	#juice_manager = weapon_manager.weapon_juice_component
	#

	WeaponAnimationPlayer.animation_finished.connect(on_anim_finished)
	if ShootinVfxManager == null:
		ShootinVfxManager = get_node("ShootingVFXManager")
	ShootinVfxManager.load_muzzle_flash(muzzle_flash_scne , barrel.global_position , barrel)
	return super._ready()
func shoot():
	if !WeaponAnimationPlayer.is_playing():
		if current_ammo != 0 :
			WeaponAnimationPlayer.play(shooting_anim)
			ShootinVfxManager.show_muzle_flash()
			current_ammo -= 1
			weapon_manager.PlayerContr.emit_signal("UpdateWeaponHud" , current_ammo)
			load_bullet()
		else:
			reload()

func reload():
	if current_ammo == magzine:
		return
	elif !WeaponAnimationPlayer.is_playing():
		WeaponAnimationPlayer.play(reload_anim)
		weapon_manager.force_stop_ads = true

#Right now it is managed by weapon manager
func _handleADS(delta):
	pass

func on_anim_finished(anim : String) -> void:
	if anim == shooting_anim and autofire and Input.is_action_pressed("shoot"):
		shoot()
	
	if anim == reload_anim:
		ammo_manager(magzine)
		weapon_manager.force_stop_ads = false
	if anim == pull_away_anim:
		weapon_manager.enter_weapon(weapon_manager.weapon_index)


func load_bullet():
	var bullet : Bullet = bullet_scne.instantiate()
	add_child(bullet)
	bullet.global_position = barrel.global_position
	bullet._set_fire_projectile(spread , Damage, GunRange , ShootinVfxManager)

func ammo_manager(amt):
	current_ammo += min(amt , amt - current_ammo , amt - reserved_ammo)

func enter() -> void:
	WeaponAnimationPlayer.play(pull_out_anim)
	weapon_manager.PlayerContr.emit_signal("UpdateWeaponHud" , current_ammo)

func exit() -> void:
	WeaponAnimationPlayer.play(pull_away_anim)
