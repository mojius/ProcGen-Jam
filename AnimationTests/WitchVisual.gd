extends Node2D
class_name WitchVisual

func _ready():
	$Broom/Torso/WandArm.connect("tween_over", self, "emit_wand_particles")

func cast_spell_anim(intensity: float):
	$WandParticles.emitting = false
	$Broom/Torso/WandArm.cast_spell(intensity)

func emit_wand_particles(intensity):
	$WandParticles.lifetime = min(0.2, intensity)
	$WandParticles.emitting = true

func spawn():
	$Broom/Torso.show()
	$Broom/BackLeg.show()
	$Broom/FrontLeg.show()
	$Broom/AnimatedSprite.hide()
	$Broom/AnimatedSprite.playing = false

	
func die():
	$Broom/Torso.hide()
	$Broom/BackLeg.hide()
	$Broom/FrontLeg.hide()
	$Broom/AnimatedSprite.frame = 0
	$Broom/AnimatedSprite.show()
	$Broom/AnimatedSprite.play("default")
	
