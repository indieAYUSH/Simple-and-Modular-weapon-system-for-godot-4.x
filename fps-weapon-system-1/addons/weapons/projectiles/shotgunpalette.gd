extends Bullet

@export_range(1.0 , 20.0 , 0.5) var randomnes : float
@export var spread2D : Path2D

var spray 

func _ready():
	spray = spread2D.get_curve()
	return super._ready()

func _set_fire_projectile(_spread : Vector2 , _damage: float, _range: float, shootingfxmanager: ShootingVFXManager):
	randomize()
	damage = _damage
	bullet_range = _range
	shooting_vfx_manager = shootingfxmanager
	
	for i in spray.get_point_count():
		var spread : Vector2 = spray.get_point_position(i)
		spread.x = spread.x + randf_range(-randomnes , randomnes)
		spread.y = spread.y + randf_range(-randomnes , randomnes)
		print(spread , " d")
		fire_bullet(spread)
