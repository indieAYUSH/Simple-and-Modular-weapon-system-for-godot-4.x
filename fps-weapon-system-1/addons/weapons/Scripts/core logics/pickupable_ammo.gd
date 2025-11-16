extends Area3D
class_name PickupAbleAmmo

@export var ammo_type : String
@export var ammo_amount : int

var parent

func _ready():
	if parent == null:
		parent = get_parent()
	if parent.has_user_signal("interacted"):
		print("yess")
		parent.connect("interacted" , add_ammo)

func add_ammo():
	Global.Player.WPM.ammunation_manager.ammo_refil(ammo_amount , ammo_type)
