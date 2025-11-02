extends Panel

@onready var label = $Label



func update_ammo(amount:int):
	label.text = str(amount)

func set_ammo(amt:int):
	label.text = str(amt)


#func _on_player_set_weapon_hud(amt):
	#$Label.text = str(amt)


func _on_player_update_weapon_hud(amt):
	$Label.text = str(amt)
