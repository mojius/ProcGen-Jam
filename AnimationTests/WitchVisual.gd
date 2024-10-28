extends Node2D
class_name WitchVisual

func _ready():
	$Broom/Torso/WandArm.connect("tween_over", self, "emit_wand_particles")

func cast_spell_anim(intensity: float):
	$WandParticles.emitting = false
	$Broom/Torso/WandArm.cast_spell(intensity)

func emit_wand_particles(intensity):
	$WandParticles.lifetime = intensity
	$WandParticles.emitting = true
