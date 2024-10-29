extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CircleChain.set_gradient(Color.red, Color.blue)
	$CircleChain.set_attached_part($BossHead)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("anim_test1"):
		$CircleChain.attached_part.play_biting()
	elif Input.is_action_just_pressed("anim_test2"):
		$CircleChain.attached_part.play_roar()
	
	$CircleChain.follow_target.global_position = get_global_mouse_position()
