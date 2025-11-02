extends HealthComponent
class_name PlayerHealthComponent

@export var Update_Bars : UpdateBarComponent


func _ready() -> void:
	Update_Bars.update_max_value(root.current_character.max_health,root.current_character.max_armor)
	root.connect("damage" , on_damage)

func on_damage() -> void :
	Update_Bars.update_health_and_armour_bar(root.current_character.current_health , root.current_character.current_armor)
