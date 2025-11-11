extends RigidBody3D
class_name PickupableItem

@export var Name : String
@export var resource : Resource

func _picked_up():
	queue_free()
