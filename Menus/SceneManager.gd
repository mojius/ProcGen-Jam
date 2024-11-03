extends Node
class_name SceneManager

# why god
const STATICS := {"instance": null}

func _init():
	STATICS["instance"] = self

export var main_menu: PackedScene
export var selection_menu: PackedScene
export var gameplay: PackedScene
export var spell_menu: PackedScene

enum Scenes { main, selection, gameplay, spell }
var cur_scene = Scenes.main

var scene_instance: Node

func _ready():
	scene_instance = main_menu.instance() as MainMenu
	add_child(scene_instance)
	scene_instance.connect("on_play", self, "play_transition", ["start_game"])
	cur_scene = Scenes.main

var transition_tween: SceneTreeTween
func play_transition(func_to_call: String):
	$Node2D/Transition.visible = true
	$Node2D/Transition.modulate = Color(1, 1, 1, 0)
	transition_tween = create_tween()
	transition_tween.tween_property($Node2D/Transition, "modulate", Color.white, 0.4)
	transition_tween.tween_callback(self, func_to_call)
	transition_tween.tween_interval(0.4)
	transition_tween.tween_property($Node2D/Transition, "modulate", Color(1, 1, 1, 0), 0.4)
	transition_tween.tween_callback(self, "end_transition")

func end_transition():
	$Node2D/Transition.visible = false
	transition_tween.kill()

func start_game():
	scene_instance.queue_free()
	scene_instance = selection_menu.instance() as SelectionMenu
	add_child(scene_instance)
	scene_instance.set_title("PICK YOUR FIRST SPELL")
	
	# TODO: add actual spells
	for i in range(3):
		scene_instance.set_option(i, Node2D.new(), "Spell info...")
	
	scene_instance.connect("on_option", self, "on_pick_first_spell")
	
func on_pick_first_spell(i: int):
	# TODO: set spell
	print(i)
	play_transition("pick_path")

func pick_path():
	scene_instance.queue_free()
	scene_instance = selection_menu.instance() as SelectionMenu
	add_child(scene_instance)
	scene_instance.set_title("WHICH PATH WILL YOU CHOOSE")
	
	# TODO: add actual seeds
	for i in range(3):
		scene_instance.set_option(i, Node2D.new(), "Seed info...")
	
	scene_instance.connect("on_option", self, "on_pick_path")

func on_pick_path(i: int):
	# TODO: set seed
	print(i)
	play_transition("start_fight")
	

func start_fight():
	scene_instance.queue_free()
	scene_instance = gameplay.instance()
	add_child(scene_instance)
	
	# TODO: set up level
	
	scene_instance.connect("on_level_end", self, "on_level_end")

func on_level_end():
	play_transition("open_spell_menu")

func open_spell_menu():
	scene_instance.queue_free()
	scene_instance = spell_menu.instance() as SpellMenu
	add_child(scene_instance)
	
	# TODO: add actual spells
	scene_instance.set_new_spell(Node2D.new(), "Spell info...")
	for i in range(3):
		scene_instance.set_spell(i, Node2D.new(), "Spell info...")
	
	scene_instance.connect("on_option", self, "on_spell_combine")
	scene_instance.connect("on_continue", self, "play_transition", ["pick_path"])

func on_spell_combine(i: int):
	print("selected spell: " + String(i))
