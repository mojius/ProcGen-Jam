extends Position2D
class_name Spawner

export (PackedScene) var spawn_entity = null
export var active_loop := true
export var cooldown := 0.4

export (Resource) var projectile_resource = ProjectileResource.new()
export var rotate_direction_angle = false

onready var homing_controller := preload("res://prefabs/ProjectileHomingController.tscn") as PackedScene

var elapsed_cooldown := 0.0

var witch_node = null

func _ready():
	if has_node("../WitchVisual/Broom/Torso/WandArm"):
		witch_node = $"../WitchVisual/Broom/Torso/WandArm"
		witch_node.connect("tween_over", self, "actual_spawn")
		
func _process(delta):
	if active_loop:
		try_spawn(global_position)


func try_spawn(coords: Vector2):
	if GameManager.elapsed > elapsed_cooldown:
		elapsed_cooldown = GameManager.elapsed + cooldown
		if witch_node:
			$"../WitchVisual".cast_spell_anim(cooldown - 0.1)
		else:
			actual_spawn(cooldown - 0.1, coords)

func actual_spawn(intensity: float, coords=null):
	if spawn_entity:
		var projectiles = projectile_resource.num_projectiles + projectile_resource.added_projectiles
		var spread_angle = projectile_resource.spread_angle * projectile_resource.added_spread_angle
		var size = projectile_resource.size + projectile_resource.added_size
		
		var tween: SceneTreeTween = null
		if projectile_resource.spread_delay > 0.0:
			tween = create_tween()
		for i in projectiles:
			var entity := spawn_entity.instance() as Projectile
			if coords==null:
				entity.position = get_parent().position + position
			else:
				entity.position = coords
			if spread_angle > 0.0:
				var angle = PI * spread_angle / projectiles
				angle = angle * (projectiles-1) / -2.0 + angle * i
				entity.direction = Vector2(cos(angle), sin(angle))
			else:
				entity.direction = Vector2.RIGHT
			if rotate_direction_angle:
				entity.direction = entity.direction.rotated(PI)
			if projectile_resource.spread_delay > 0.0:
				tween.tween_callback(GameManager.player_projectile_layer, "add_child", [entity]).set_delay(projectile_resource.spread_delay * cooldown / projectiles)
			else:
				GameManager.player_projectile_layer.add_child(entity)
			if projectile_resource:
				entity.projectile_resource = projectile_resource
				if projectile_resource.size > 1.0:
					entity.scale *= size
				if projectile_resource.homing:
					var homing = homing_controller.instance() as HomingController
					homing.homing_target = GameManager.player.get_node("Player")
					entity.add_child(homing)
		if projectile_resource.spread_delay > 0.0:
			tween.play()
