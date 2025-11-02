
extends Node3D


func shoot_rot():
	print("shooting")
	$Gun/Barrel.rotation.z += deg_to_rad(90.0)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "SHOOT":
		shoot_rot()
