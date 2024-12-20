extends Control
class_name SelectionMenu

func set_option(i: int, n, s: String):
	if i == 0:
		$Option1/TextureRect/Label.text = s
		if n:
			if n.get_parent():
				n.get_parent().remove_child(n)
			$Option1/Control.add_child(n)
			n.position = Vector2.ZERO
			n.scale = Vector2.ONE * 3
	
	elif i == 1:
		$Option2/TextureRect/Label.text = s
		if n:
			if n.get_parent():
				n.get_parent().remove_child(n)
			$Option2/Control.add_child(n)
			n.position = Vector2.ZERO
			n.scale = Vector2.ONE * 3
	
	elif i == 2:
		$Option3/TextureRect/Label.text = s
		if n:
			if n.get_parent():
				n.get_parent().remove_child(n)
			$Option3/Control.add_child(n)
			n.position = Vector2.ZERO
			n.scale = Vector2.ONE * 3

func set_title(s: String):
	$Label.text = s

signal on_option

func _on_Option1_pressed():
	emit_signal("on_option", 0)


func _on_Option2_pressed():
	emit_signal("on_option", 1)


func _on_Option3_pressed():
	emit_signal("on_option", 2)
