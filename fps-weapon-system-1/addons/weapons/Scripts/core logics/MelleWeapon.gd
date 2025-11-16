extends Weapon
class_name melee

@export_group("Animations")
@export var pull_out_anim : String
@export var pull_away_anim : String
@export var attack_anim : String

@export var damage : float

func enter() -> void:
	print("entered")
	WeaponAnimationPlayer.play(pull_out_anim)

func _ready():
	#holder = get_parent()
	#weapon_manager = holder.get_parent().get_parent()
	#juice_manager = weapon_manager.weapon_juice_component
	WeaponAnimationPlayer.animation_finished.connect(on_animation_finished)
	return super._ready()


func exit() -> void:
	WeaponAnimationPlayer.play(pull_away_anim)

func attack() ->void:
	WeaponAnimationPlayer.play(attack_anim)

func on_animation_finished(anim : String):
	if anim == pull_away_anim:
		weapon_manager.enter_weapon(weapon_manager.weapon_index)
