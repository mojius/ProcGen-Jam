extends MenuBobbing
class_name MenuEyes

export var a_speed := 2.0 # bobbing animation speed
export var a_magnitude := 7.0 # bobbing animation height
export var a_timing_offset := 0.0 # x offset in sin func

var a_half_mag := 0.0
var a_start_pos := 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	a_half_mag = a_magnitude / 2.0
	a_start_pos = modulate.a


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	modulate.a = (cos((Time.get_unix_time_from_system() * a_speed) + a_timing_offset) * a_magnitude) + a_half_mag + a_start_pos
