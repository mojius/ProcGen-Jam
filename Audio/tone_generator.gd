extends Node


var sample_hz = 22050.0 # Keep the number of samples to mix low, GDScript is not super fast.
var pulse_hz = 440.0
var phase = 0.0

var timer = 0
var max_time = 60

export var amp: float = 1.0

enum WaveType {
	SINE,
	SQUARE,
	SAWTOOTH,
	TRIANGLE
}

export(WaveType) var wave

var notes: Dictionary = {
	"C"	: 261.63,
	"C#": 277.18,
	"Db": 277.18,
	"D"	: 293.66,
	"D#": 311.13,
	"E"	: 329.63,
	"F"	: 349.23,
	"F#": 369.99,
	"Gb": 369.99,
	"G"	: 392.00,
	"G#": 207.65,
	"Ab": 415.30,
	"A"	: 440.00,
	"A#": 466.16,
	"Bb": 466.16,
	"B" : 493.88
}

var major: Array = ["C", "D", "E", "F", "G", "A", "B"]
var blues: Array = ["C", "D#", "F", "F#", "G", "A#"]

var playback: AudioStreamPlayback = null # Actual playback stream, assigned in _ready().


func _process(_delta):
	timer += _delta
	if (timer > 0.5):
		timer = 0
		_refresh_note(major)
	_fill_buffer()


func _fill_buffer():
	var increment = pulse_hz / sample_hz

	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		phase = fmod(phase + increment, 1.0)
		var sample = get_sample(wave)

		
		playback.push_frame(sample) # Audio frames are stereo.
		to_fill -= 1


func get_sample(wave: int):
	var sample: Vector2 = Vector2.ZERO
	if (wave == WaveType.SINE):
		sample = Vector2.ONE * sin(phase * TAU)
	elif (wave == WaveType.SQUARE):
		var sin_sample = sin(phase * TAU)
		sample = Vector2.ONE * sign(sin_sample)	
	elif (wave == WaveType.SAWTOOTH):
		pass
	elif (wave == WaveType.TRIANGLE):
		sample = Vector2.ONE * (2 * PI * asin(sin(PI * phase)))
		
	sample *= amp
	return sample

func _ready():
	randomize()
	$Player.stream.mix_rate = sample_hz # Setting mix rate is only possible before play().
	playback = $Player.get_stream_playback()
	_fill_buffer() # Prefill, do before play() to avoid delay.
	$Player.play()

func _refresh_note(scale: Array):
	
	var new_note = notes.get(scale.pick_random())
	while (new_note == pulse_hz):
		new_note = notes.get(scale.pick_random())
	pulse_hz = new_note
	

