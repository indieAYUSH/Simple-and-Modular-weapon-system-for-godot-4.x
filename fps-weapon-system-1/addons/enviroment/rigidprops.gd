extends RigidBody3D
class_name rigidprops

func _ready():
	linear_damp = 0.3

func _apply_impact_force(force , pos ):
	var impulse = -force
	apply_impulse(impulse , pos)
	print(linear_velocity)
	
