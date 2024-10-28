extends Line2D


export var max_angle := 30.0
export var max_arm_angle := 120.0
export var max_wand_angle := 150.0
export var speed := 1.0

var original_rot := 0.0
var original_arm_rot := 0.0
var arm_len := 0.0
var original_wand_rot := 0.0

signal tween_over

# Called when the node enters the scene tree for the first time.
func _ready():
	original_rot = rotation_degrees
	var diff: Vector2 = points[2] - points[1]
	original_arm_rot = diff.angle()
	arm_len = diff.length()
	original_wand_rot = $Wand.rotation_degrees

var is_tweening := false

var arm_rot := 0.0 setget _set_arm_rot , _get_arm_rot

func _set_arm_rot(rot):
	points[2] = points[1] + (Vector2.RIGHT.rotated(rot) * arm_len)
	$Wand.position = points[2]

func _get_arm_rot():
	var diff: Vector2 = points[2] - points[1]
	return diff.angle()

func cast_spell(intensity: float):
	if is_tweening:
		return
	is_tweening = true
	
	var tween1 = get_tree().create_tween()
	tween1.tween_property(self, "rotation_degrees", -max_angle * intensity, speed * intensity).set_trans(Tween.TRANS_QUINT)
	tween1.tween_property(self, "rotation_degrees", original_rot, speed * intensity * 0.3).set_trans(Tween.TRANS_QUINT)
	tween1.tween_callback(self, "end_tween", [intensity])
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "arm_rot", deg2rad(-max_arm_angle) * intensity, speed * intensity).set_trans(Tween.TRANS_CUBIC)
	tween2.tween_property(self, "arm_rot", original_arm_rot, speed * intensity * 0.3).set_trans(Tween.TRANS_CUBIC)
	
	var tween3 = get_tree().create_tween()
	tween3.tween_property($Wand, "rotation_degrees", -max_wand_angle * intensity, speed * intensity).set_trans(Tween.TRANS_CUBIC)
	tween3.tween_property($Wand, "rotation_degrees", original_wand_rot, speed * intensity * 0.3).set_trans(Tween.TRANS_CUBIC)

func end_tween(intensity):
	is_tweening = false
	emit_signal("tween_over", intensity)
