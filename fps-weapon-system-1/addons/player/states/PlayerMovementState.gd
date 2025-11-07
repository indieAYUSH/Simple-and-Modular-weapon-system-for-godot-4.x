class_name PlayerMovementState extends State

@export var Player : PlayerController
var PlayerAnimation : AnimationPlayer
var PlayerAnimationTree : AnimationTree
func _ready():
	await owner.ready
	Player = owner as PlayerController
	PlayerAnimation = Player.get_node("PlayerAnimation") as AnimationPlayer
	PlayerAnimationTree = Player.get_node("PlayerAnimationTree" ) as AnimationTree
