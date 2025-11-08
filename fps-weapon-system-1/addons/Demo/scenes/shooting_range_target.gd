extends CharacterBody3D

var health : float = 80.0
@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer

func _ready():
	add_user_signal("damage")
	connect("damage" , damage)

func damage(amount):
	health -= amount
	if health < 0:
		animation_player.play("death")
		timer.start()

func _on_timer_timeout():
	health = 90.0
	animation_player.play("respawn")
