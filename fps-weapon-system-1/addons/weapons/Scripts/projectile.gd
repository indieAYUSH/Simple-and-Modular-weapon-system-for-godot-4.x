extends RigidBody3D

var damage_amount : float
var particles : PackedScene

func _on_body_entered(body: Node) -> void:
	print("ohyeah")
	print(body)
	if body.has_user_signal("damage"):
		print("ohyeah")
		body.emit_signal("damage" , damage_amount)
		queue_free()
	queue_free()


func _on_timer_timeout():
	queue_free()


func projectile_func(mag:float , dir:Vector3 ) -> void:
	pass
