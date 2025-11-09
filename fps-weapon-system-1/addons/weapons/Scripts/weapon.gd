extends Node3D
class_name Weapon

@export_group("References")
@export var WeaponAnimationPlayer : AnimationPlayer
@export var WeaponAnimationTree : AnimationTree


var weapon_manager : WeaponManager
var holder
var juice_manager 

func _ready():
	holder = get_parent()
	weapon_manager = holder.get_parent().get_parent()
	juice_manager = weapon_manager.weapon_juice_component
	
func enter() -> void:
	pass


func exit() -> void:
	pass
