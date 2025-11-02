extends Control
class_name UpdateBarComponent

@onready var health_bar = %HealthBar
@onready var armour_bar = %ArmourBar
@onready var player: PlayerController = $"../.."




@onready var stamina_bar: ColorRect = $StaminaBar



func update_health_and_armour_bar(health_amount : float , armour_amount : float):
	%HealthBar.value = health_amount
	%ArmourBar.value = armour_amount


func update_stamina_bar(amount : float):
	pass

func update_max_value( max_health : float , max_armour : float) -> void :
	%HealthBar.max_value = max_health
	%ArmourBar.max_value = max_armour
	print(max_armour)
	print(max_health)
