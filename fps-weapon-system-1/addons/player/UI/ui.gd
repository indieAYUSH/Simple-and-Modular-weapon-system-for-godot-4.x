extends Control
class_name PlayerUiComponent

@onready var ui_crosshair = $UICrosshair
@onready var weapon_hud = $WeaponHud
@onready var texture_rect = $weaponhud/HBoxContainer/slot1/TextureRect
@onready var ammo_counter_holder = $weaponhud/HBoxContainer/slot1/ammo_counter_holder
@onready var texture_rect_slot_1 = $weaponhud/HBoxContainer/slot2/TextureRect
@onready var ammo_counter_holder_slot_2 = $weaponhud/HBoxContainer/slot2/ammo_counter_holder
@onready var texture_rect_slot_3 = $weaponhud/HBoxContainer/slot3/TextureRect
@onready var ammo_counter_holder_slot_3 = $weaponhud/HBoxContainer/slot3/ammo_counter_holder


func _ready():
	await owner.ready 
	Global.Player.WPM.update_ammo.connect(_update_ammo)
	Global.Player.WPM.update_weapon.connect(_update_weapon)

func hide_crosshair():
	ui_crosshair.visible = false

func unhide_crosshair():
	ui_crosshair.visible = true

func _update_weapon(weapon_name : String , tex : Texture2D):
	pass

func _update_ammo(curr_ammo : int , reserved_ammo : int):
	pass
