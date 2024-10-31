extends AnimatedPart
class_name BossBody

# actual limb parents
var limb_points: Array = []
# references to keep limbs aligned with body
var limb_ref_points: Array = []

onready var body: Node2D = $ShakeTarget/Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	ready_body()

func ready_body():
	for n in body.get_children():
		limb_ref_points.append(n)
		var limb_point = Node2D.new()
		add_child(limb_point)
		limb_points.append(limb_point)
		limb_point.global_position = n.global_position

# LIMB BUILDING

func set_limb(var i: int, var limb: BossComponent):
	if limb.get_parent():
		limb.get_parent().remove_child(limb)
	limb_points[i].add_child(limb)
	limb.position = Vector2.ZERO
	if ("source_dir" in limb and limb_ref_points[i] is LimbPoint):
		limb.source_dir = limb_ref_points[i].source_dir

func get_limb(var i: int):
	return limb_points[i].get_child(0)

func _process(_delta):
	for i in range(limb_points.size()):
		limb_points[i].global_position = limb_ref_points[i].global_position
