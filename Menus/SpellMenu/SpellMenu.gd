extends Control
class_name SpellMenu

var new_spell = null

func set_new_spell(n, s: String):
	$Option4/TextureRect/Label.text = s
	if new_spell:
		new_spell.queue_free()
	if n:
		if n.get_parent():
			n.get_parent().remove_child(n)
		$Option4/Control.add_child(n)
		n.position = Vector2.ZERO
		n.scale = Vector2.ONE * 3
		new_spell = n

var spell1 = null
var spell2 = null
var spell3 = null

func set_spell(i: int, n, s: String):
	if i == 0:
		$Option1/TextureRect/Label.text = s
		if spell1:
			spell1.queue_free()
		if n:
			if n.get_parent():
				n.get_parent().remove_child(n)
			$Option1/Control.add_child(n)
			n.position = Vector2.ZERO
			n.scale = Vector2.ONE * 3
			spell1 = n
	
	elif i == 1:
		$Option2/TextureRect/Label.text = s
		if spell2:
			spell2.queue_free()
		if n:
			if n.get_parent():
				n.get_parent().remove_child(n)
			$Option2/Control.add_child(n)
			n.position = Vector2.ZERO
			n.scale = Vector2.ONE * 3
			spell2 = n
	
	elif i == 2:
		$Option3/TextureRect/Label.text = s
		if spell3:
			spell3.queue_free()
		if n:
			if n.get_parent():
				n.get_parent().remove_child(n)
			$Option3/Control.add_child(n)
			n.position = Vector2.ZERO
			n.scale = Vector2.ONE * 3
			spell3 = n

func set_title(s: String):
	$Label.text = s

signal on_option
signal on_continue

func _on_Option1_pressed():
	emit_signal("on_option", 0)


func _on_Option2_pressed():
	emit_signal("on_option", 1)


func _on_Option3_pressed():
	emit_signal("on_option", 2)


func _on_TextureButton_pressed():
	emit_signal("on_continue")
