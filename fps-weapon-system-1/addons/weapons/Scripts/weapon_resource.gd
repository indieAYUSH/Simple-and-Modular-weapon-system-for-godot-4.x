extends Resource
class_name WeaponResource

@export_category("Weapon")
@export var weapon_name : String
#@export_category("WeaponStats")
#@export var damage : float

@export_category("Scenes")
@export var weapon_scene : PackedScene
@export var gun_ui_texture : Texture2D

@export_group("weaponsetting")
@export_flags("MELEE" , "GUN") var type
#
#
#@export_group("GunSpecific")
#@export_category("GunScene")
#@export var BulletScene : PackedScene
#@export var muzzle_flash : PackedScene
#
#@export_category("Gunstats")
#@export var current_ammo : int
#@export var mag_capacity : int
#@export var max_bullets : int
#@export var weapon_range : float
#
#
#@export_category("spread_and_recoil")
#@export var spread : Vector2 = Vector2.ZERO
#
#
#
#
#
##Animations
#@export_category("GunAnimations")
#@export var shooting_animation :String
#@export var reload_animation :String
#
#@export_category("sounds")
#@export var shooting_sound : AudioStream


#@export_category("Juice_effect_multiplier")
#@export var bob_multiplier : float
#@export var sway_multiplier : float
#@export var side_rot_multiplier  :float
#@export_range(0.0 ,1.0 , 0.01) var shoot_trauma : float

@export_category("GunAimDownSight")
@export var CanADS : bool
@export var ads_pos : Vector3
@export var ads_zoom : float
@export var ads_bob_multiplier : float
@export var ads_sway_multiplier:float
@export var ads_side_rot_multiplier : float

@export_category("Weapon_Settings")
@export var Autofire : bool

@export_category("Weapon Transforms")
@export var position  : Vector3
@export var rotaion : Vector3



@export_category("deafults")
@export var default_bob_multiplier : float
@export var default_sway_multiplier : float
@export var deafualt_side_rot_multiplier  :float
