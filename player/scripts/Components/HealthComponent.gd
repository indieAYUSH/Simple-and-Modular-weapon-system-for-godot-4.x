extends Node
class_name HealthComponent

@export var root : CharacterBody3D

@export var UI_component : UpdateBarComponent



func _ready() -> void:
	root.add_user_signal("damage")
	root.add_user_signal("heal")
	root.add_user_signal("recieved_damage")
	root.connect("damage" , _damage)
	root.connect( "heal", _heal)
	root.current_character.current_health = root.current_character.max_health
	root.current_character.current_armor = root.current_character.max_armor



func _damage(amount : float) -> void:
	var remainig_health = amount
	if root.current_character.current_armor > 0 :
		var absorbed = min(root.current_character.current_armor , remainig_health , root.current_character.armor_absorption)
		root.current_character.current_armor -= absorbed
		remainig_health -= absorbed
	root.current_character.current_health -=  remainig_health
	root.current_character.current_health = clamp(root.current_character.current_health , 0.0 , root.current_character.max_health)
	UI_component.update_health_and_armour_bar(root.current_character.current_health , root.current_character.current_armor)
	root.emit_signal("recieved_damage")
	if root.current_character.current_health <= 0 :
		print("deAD")
		die()
	
	

func _heal(amount : float) -> void:
	root.current_character.current_health = clamp(root.current_character.current_health , 0.0 , root.current_character.max_health)
	root.current_character.current_health += amount
	UI_component.update_health_and_armour_bar(root.current_character.current_health , root.current_character.current_armor)

func die():
	print("died")
