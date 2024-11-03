extends Control
class_name MenuBobbing

export var speed := 2.0 # bobbing animation speed
export var magnitude := 7.0 # bobbing animation height
export var timing_offset := 0.0 # x offset in sin func

var half_mag := 0.0
var start_pos := 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	half_mag = magnitude / 2.0
	start_pos = rect_position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rect_position.y = (cos((Time.get_unix_time_from_system() * speed) + timing_offset) * magnitude) + half_mag + start_pos
