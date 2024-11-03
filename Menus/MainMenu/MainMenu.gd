extends Control
class_name MainMenu

signal on_play


func _on_TextureButton_pressed():
	emit_signal("on_play")
