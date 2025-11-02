class_name ShootingVFXManager
extends Node3D

var muzzle_flash 
var barrel

func load_muzzle_flash(scene : PackedScene , pos:Vector3 , _barrel:Node3D):
	var muzz = scene.instantiate()
	add_child(muzz)
	muzzle_flash = muzz
	muzz.global_position = pos
	barrel = _barrel

func _spawn_hit_particles(particles : PackedScene , pos:Vector3) -> void :
	if not particles:
		return
	var par = particles.instantiate()
	get_tree().current_scene.add_child(par)
	par.global_position = pos
	par.emitting = true

func show_muzle_flash() -> void :
	muzzle_flash._show_muzzle_flash()

func spawn_bullet_trails(line_direction: Vector3, line_start: Vector3, line_end: Vector3, _range: float) -> void:
	var line_mesh = MeshInstance3D.new()
	var cylinder_mesh = CylinderMesh.new()
	var line_material = ORMMaterial3D.new()
	var line_transform = Transform3D.IDENTITY
	var line_length: float = _range
	
	# Create line mesh for bullet trail
	line_mesh.mesh = cylinder_mesh
	line_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	# FIXED: Position at the actual midpoint between start and end
	line_mesh.position = (line_start + line_end) / 2
	
	line_mesh.material_override = line_material
	
	# Initialize cylinder_mesh
	cylinder_mesh.rings = 1
	cylinder_mesh.radial_segments = 6
	cylinder_mesh.height = line_length
	cylinder_mesh.top_radius = 0.005
	cylinder_mesh.bottom_radius = 0.005
	
	# Initialize line_material
	line_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	line_material.albedo_color = Color.GOLD
	
	# Change the line direction (orient the cylinder)
	line_transform.basis.y = line_direction.normalized()
	
	# Handle edge case when shooting straight up/down
	var reference_vector = Vector3.UP
	if abs(line_direction.dot(Vector3.UP)) > 0.99:
		reference_vector = Vector3.RIGHT
	
	line_transform.basis.x = reference_vector.cross(line_direction).normalized()
	line_transform.basis.z = line_transform.basis.x.cross(line_direction).normalized()
	line_mesh.basis = line_transform.basis
	
	# Add to scene
	get_tree().current_scene.add_child(line_mesh)
	
	# Animate fade out and remove
	var line_tween: Tween = create_tween()
	line_tween.tween_property(line_material, "transparency", BaseMaterial3D.TRANSPARENCY_ALPHA, 0.0)
	line_tween.tween_property(line_material, "albedo_color:a", 0.0, 0.5)
	line_tween.tween_callback(line_mesh.queue_free)
