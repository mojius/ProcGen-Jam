extends Node2D

var intensity := 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("anim_test1"):
		intensity += 0.1
	elif Input.is_action_just_pressed("anim_test2"):
		intensity -= 0.1
	
	$WitchVisual.cast_spell_anim(intensity)
