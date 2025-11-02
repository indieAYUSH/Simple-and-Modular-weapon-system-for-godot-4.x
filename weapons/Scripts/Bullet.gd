extends Node3D
class_name Bullet

# Define as enum for single selection
@export_enum("Hitscan", "RigidBodyProjectiles") var type : int = 0

@export_category("WeaponStats")
@export var expiry_time : float
@export var bullet_range  : float

#RigidBodyProjectile
@export_category("Rigid_Body_Projectiles")
@export var rigid_projectile_scene : PackedScene
@export var projectile_velocity : float 
@export var upward_velocity : float

@export_category("weapon_visual_effects")
@export var hit_particles : PackedScene

#Reference
var shooting_vfx_manager : ShootingVFXManager
var damage : float

# Define constants for type matching
const HITSCAN = 0
const PROJECTILE = 1

func _ready():
	get_tree().create_timer(expiry_time) . timeout.connect(_on_expiry_time_out)

func _set_fire_projectile(_spread : Vector2 , _damage: float, _range: float, shootingfxmanager: ShootingVFXManager):
	bullet_range  = _range
	damage = _damage  
	shooting_vfx_manager = shootingfxmanager
	fire_bullet(_spread)


func fire_bullet(_spread  : Vector2)-> void :
	var cam_collision = get_camera_collision(_spread)  
	
	match type:
		HITSCAN:
			hitscan_collision(cam_collision)
		PROJECTILE:
			shoot_projectile(cam_collision)
		_:
			pass  # Default case

func get_camera_collision(_spread:Vector2) -> Vector3:
	var spread = _spread
	
	var viewport = get_viewport().size
	var camera = get_viewport().get_camera_3d()
	
	var Ray_origin = camera.project_ray_origin(viewport/2)
	var Ray_end = camera.project_ray_normal(viewport/2) * bullet_range  + Ray_origin + Vector3(spread.x , spread.y , 0)
	var new_intersection = PhysicsRayQueryParameters3D.create(Ray_origin , Ray_end)
	var intersection = get_world_3d().direct_space_state.intersect_ray(new_intersection)
	if not intersection.is_empty():
		var coll_point = intersection.position
		return coll_point
	else:
		return Ray_end
	
func hitscan_collision(collison_point):
	var barrel_position = global_transform.origin
	var barrel_cast_direction = (collison_point - barrel_position).normalized()
	
	var ray_end = collison_point + barrel_cast_direction * 2
	var new_intersection = PhysicsRayQueryParameters3D.create(barrel_position, ray_end)
	var Bullet_collision = get_world_3d().direct_space_state.intersect_ray(new_intersection)
	
	if Bullet_collision:
		var collider = Bullet_collision["collider"]
		var actual_hit_point = Bullet_collision.position
		shooting_vfx_manager.spawn_bullet_trails(barrel_cast_direction, barrel_position, actual_hit_point, barrel_position.distance_to(actual_hit_point))
		shooting_vfx_manager._spawn_hit_particles(hit_particles, actual_hit_point)
		hitscan_damage(collider)
	else:
		var max_range_point = barrel_position + barrel_cast_direction * 400.0
		shooting_vfx_manager.spawn_bullet_trails(barrel_cast_direction, barrel_position, max_range_point, 400.0)

func hitscan_damage(collider):
	if collider.has_user_signal("damage"):
		collider.emit_signal("damage" , damage)

func shoot_projectile(collision_point):
	var barrel_pos : Vector3 = global_transform.origin
	var dir = (collision_point-barrel_pos).normalized()
	var projectile  = rigid_projectile_scene.instantiate()
	projectile.damage_amount = damage
	
	get_tree().current_scene.add_child(projectile)
	projectile.linear_velocity = projectile_velocity*dir
	projectile.linear_velocity.y += upward_velocity
	projectile.global_transform.origin = barrel_pos



func _on_expiry_time_out()->void:
	queue_free()
