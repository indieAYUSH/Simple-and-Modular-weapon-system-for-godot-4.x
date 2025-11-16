extends RigidBody3D

var damage_amount : float
var particles : PackedScene
var impact_force
func _on_body_entered(body: Node) -> void:
	print("ohyeah")
	print(body)
	if body.has_user_signal("damage"):
		print("ohyeah")
		body.emit_signal("damage" , damage_amount)
		queue_free()
	var impact_dir = linear_velocity.normalized()
	var force = impact_dir * impact_force
	var impact_point = global_position
	if body is rigidprops:
		body._apply_impact_force(force, impact_point)
	queue_free()


func _on_timer_timeout():
	queue_free()


func projectile_func(mag:float , dir:Vector3 ) -> void:
	pass
