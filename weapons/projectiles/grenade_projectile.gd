extends RigidBody3D

var damage_amount
var damagedone : bool = false
var exploded : bool = false
@export var explosionvfx : PackedScene
@onready var explosion_area = $explosion_area

func _ready():
	linear_damp = 1.3
	angular_damp = 2.0

func _on_explosion_timer_timeout():
	print("Explosion triggered")
	var exp = explosionvfx.instantiate()
	exp.global_position = global_position
	get_tree().current_scene.add_child(exp)
	exp._explode()
	exploded = true
	
	if explosion_area:
		var bodies = explosion_area.get_overlapping_bodies()
		print(bodies)
		
		for body in  bodies:
			_apply_damage(body)
	await get_tree().create_timer(0.3).timeout
	queue_free()



func _apply_damage(body) -> void:
	if body.has_signal("damage"):
		print("dealing damage")
		body.emit_signal("damage", damage_amount)
		damagedone = true
