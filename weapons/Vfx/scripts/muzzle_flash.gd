extends Node3D

@onready var flash = $flash


func _show_muzzle_flash() ->void:
	flash.emitting = true
	$light.visible = true
	await get_tree().create_timer(flash.lifetime) .timeout
	$light.visible = false
