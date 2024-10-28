extends Position2D


export (PackedScene) var spawn_entity = null
export var cooldown := 0.4
var elapsed_cooldown := 0.0


func _ready():
	$"../WitchVisual/Broom/Torso/WandArm".connect("tween_over", self, "actual_spawn")


func try_spawn(coords: Vector2):
	if GameManager.elapsed > elapsed_cooldown:
		elapsed_cooldown = GameManager.elapsed + cooldown
		$"../WitchVisual".cast_spell_anim(cooldown - 0.1)

func actual_spawn(intensity: float):
	if spawn_entity:
		var entity := spawn_entity.instance() as Projectile
		entity.position = get_parent().position + position
		entity.direction = Vector2.RIGHT
		GameManager.player_projectile_layer.add_child(entity)
