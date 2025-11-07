extends RigidBody3D
class_name rigidprops

func _apply_impact_force(force_magnituded , pos ):
	var impulse = (position - pos).normalized()
	print(impulse)
	print(pos)
	print(transform.origin)
	apply_impulse(force_magnituded*impulse , pos)
	
