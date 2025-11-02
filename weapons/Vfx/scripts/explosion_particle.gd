extends Node3D

@onready var debris = $Debris
@onready var smoke = $Smoke
@onready var fire = $Fire
@onready var explosion_sound = $ExplosioSound




func _explode() -> void :
	explosion_sound.playing = true
	debris.emitting = true
	fire.emitting = true
	smoke.emitting = true
	await  get_tree().create_timer(2.0) .timeout
	queue_free()
