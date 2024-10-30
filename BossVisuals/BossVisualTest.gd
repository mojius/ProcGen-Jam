extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var neck

# Called when the node enters the scene tree for the first time.
func _ready():
	neck = $CircleChain
	$CircleChain.set_gradient(Color(0x00d6d6ff), Color(0x744c1bff))
	$CircleChain.set_attached_part($BossHead)
	$BossBody.set_limb(0, $CircleChain)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("anim_test1"):
		neck.attached_part.play_biting()
	elif Input.is_action_just_pressed("anim_test2"):
		neck.attached_part.play_roar()
	
	neck.follow_target.global_position = get_global_mouse_position()
