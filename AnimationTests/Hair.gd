extends Line2D
class_name Hair

export var clockwise := true # whether the hair will bend to the left or right
export var flex := 1.0 # how much the hair will deform when moving

var resting_diffs := []
var deform_dirs := []

# Called when the node enters the scene tree for the first time.
func _ready():
	var prev_point = null
	for point in points:
		if prev_point != null:
			var diff = point - prev_point
			resting_diffs.append(diff)
			var deform_dir = Vector2(diff.y if clockwise else -diff.y, -diff.x if clockwise else diff.x)
			deform_dirs.append(deform_dir)
		else:
			resting_diffs.append(Vector2.ZERO)
			deform_dirs.append(Vector2.ZERO)
		prev_point = point
	prev_pos = global_position

var prev_pos: Vector2 = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var diff = global_position - prev_pos
	
	for i in range(points.size()):
		if i == 0: continue
		
		var mag = clamp(deform_dirs[i].dot(diff), -flex, flex)
		
		points[i] = points[i - 1] + resting_diffs[i] - (deform_dirs[i] * mag)
	
	prev_pos = global_position
