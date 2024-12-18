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

export var power_up: PackedScene

enum Scenes { main, selection, gameplay, spell }
var cur_scene = Scenes.main

var scene_instance: Node

var level := 1
var level_power_mult := 0.6

# the actually owned spells
var spells := []
# the actually choosen path
var paths := []
# working space for current options in spell menus
var spell_options := []

# helper functions

func combine_spell(spell1, spell2):
	var new_spell = {"kind": 0, "power": 1.0}
	new_spell["kind"] = (spell1["kind"] + spell2["kind"]) % 7
	new_spell["power"] = max(spell1["power"], spell2["power"]) + rand_range(1, 3)
	return new_spell

func get_power_adj(power):
	if power < 2.0:
		return "common"
	elif power < 4.0:
		return "trained"
	elif power < 6.0:
		return "greater"
	elif power < 8.0:
		return "master"
	else:
		return "legendary"

func get_spell_name(spell):
	var text := ""
	match spell["kind"]:
		0:
			text = "spread-shot"
		1:
			text = "rapid fire"
		2:
			text = "swift strike"
		3:
			text = "strengthen"
		4:
			text = "explosion"
		5:
			text = "focus"
		6:
			text = "asteroid"
	return get_power_adj(spell["power"]) + " " + text

func get_path_name(i) -> String:
	match i:
		0:
			return "A deadly"
		1:
			return "An aggressive"
		2:
			return "A lightning fast"
		3:
			return "A formidable"
		4:
			return "An explosive"
		5:
			return "A dangerous"
		6:
			return "An overwhelming"
	return "A formidable"

# sceneflow

func _ready():
	randomize()
	scene_instance = main_menu.instance() as MainMenu
	add_child(scene_instance)
	scene_instance.connect("on_play", self, "play_transition", ["start_game"])
	cur_scene = Scenes.main

var transition_tween: SceneTreeTween
func play_transition(func_to_call: String):
	AudioManager.audio_continue.play()
	$CanvasLayer/Node2D/Transition.visible = true
	$CanvasLayer/Node2D/Transition.modulate = Color(1, 1, 1, 0)
	transition_tween = create_tween()
	transition_tween.tween_property($CanvasLayer/Node2D/Transition, "modulate", Color.white, 0.4)
	transition_tween.tween_callback(self, func_to_call)
	transition_tween.tween_interval(0.4)
	transition_tween.tween_property($CanvasLayer/Node2D/Transition, "modulate", Color(1, 1, 1, 0), 0.4)
	transition_tween.tween_callback(self, "end_transition")

func end_transition():
	$CanvasLayer/Node2D/Transition.visible = false
	transition_tween.kill()

func start_game():
	scene_instance.queue_free()
	scene_instance = selection_menu.instance() as SelectionMenu
	add_child(scene_instance)
	scene_instance.set_title("PICK YOUR FIRST SPELL")
	
	spell_options.clear()
	var all_spells = range(7)
	all_spells.shuffle()
	for i in range(3):
		spell_options.append({"kind": all_spells[i], "power": 1.0 + rand_range(0.0, min(2.0, level * level_power_mult))})
		
		var new_power_up = power_up.instance() as PowerUp
		add_child(new_power_up)
		new_power_up.set_powerup(spell_options[i]["kind"], spell_options[i]["power"])
		
		scene_instance.set_option(i, new_power_up, get_spell_name(spell_options[i]))
	
	scene_instance.connect("on_option", self, "on_pick_first_spell")
	
func on_pick_first_spell(i: int):
	AudioManager.audio_blip.play()
	spells.append(spell_options[i])
	play_transition("pick_path")

func pick_path():
	scene_instance.queue_free()
	scene_instance = selection_menu.instance() as SelectionMenu
	$CanvasLayer.add_child(scene_instance)
	scene_instance.set_title("WHICH PATH WILL YOU CHOOSE")
	
	var all_spells = range(7)
	all_spells.shuffle()
	for i in range(3):
		spell_options.append({"kind": all_spells[i], "power": 1.0})
		
		var new_power_up = power_up.instance() as PowerUp
		add_child(new_power_up)
		new_power_up.set_powerup(spell_options[i]["kind"], spell_options[i]["power"])
		scene_instance.set_option(i, new_power_up, get_path_name(spell_options[i]["kind"]) + " foe")
		
	scene_instance.connect("on_option", self, "on_pick_path")

func on_pick_path(i: int):
	AudioManager.audio_blip.play()
	var selected_option = spell_options[i]
	spell_options.clear()
	spell_options.append(selected_option)
	paths.append(randi())
	
	play_transition("start_fight")
	

func start_fight():
	scene_instance.queue_free()
	scene_instance = gameplay.instance()
	add_child(scene_instance)
	# add the boss given the current seed
	GameManager.spawn_player()
	scene_instance.make_cave()
	scene_instance.spawn_new_boss(paths[-1], level)
	
	# give initial spells to the player
	for i in spells:
		var powerup = power_up.instance() as PowerUp
		scene_instance.add_child(powerup)
		powerup.set_powerup(i["kind"], i["power"])
		powerup.pickup(GameManager.player.body)
		GameManager.player.powerups.append(powerup)
	
	scene_instance.connect("on_level_end", self, "on_level_end")

func on_level_end():
	level += 1
	play_transition("open_spell_menu")

func open_spell_menu():
	scene_instance.queue_free()
	scene_instance = spell_menu.instance() as SpellMenu
	$CanvasLayer.add_child(scene_instance)
	
	# TODO: add actual spells
	var new_spell = power_up.instance() as PowerUp
	add_child(new_spell)
	new_spell.set_powerup(spell_options[0]["kind"], spell_options[0]["power"]) # spell option set in on_pick_path()
	var new_spell_text = get_spell_name(spell_options[0])
	scene_instance.set_new_spell(new_spell, new_spell_text)
	
	for i in range(3):
		var elem = null
		var text = ""
		if i < spells.size():
			elem = power_up.instance() as PowerUp
			add_child(elem)
			elem.set_powerup(spells[i]["kind"], spells[i]["power"])
			text = get_spell_name(spells[i])
		scene_instance.set_spell(i, elem, text)
	
	scene_instance.connect("on_option", self, "on_spell_combine")
	scene_instance.connect("on_continue", self, "play_transition", ["pick_path"])

# actual spell stats combining done in combine_spell() at the top of the file
func on_spell_combine(i: int):
	AudioManager.audio_blip.play()
	if spell_options.size() == 0:
		return
	
	if i < spells.size():
		var new_spell = combine_spell(spell_options[0], spells[i])
		spells[i] = new_spell
		
		scene_instance.set_new_spell(null, "")
		
		var elem = power_up.instance() as PowerUp
		add_child(elem)
		elem.set_powerup(spells[i]["kind"], spells[i]["power"])
		var text = get_spell_name(spells[i])
		scene_instance.set_spell(i, elem, text)
	else:
		spells.append(spell_options[0])
		i = spells.size() - 1
		
		scene_instance.set_new_spell(null, "")
		
		var elem = power_up.instance() as PowerUp
		add_child(elem)
		elem.set_powerup(spells[i]["kind"], spells[i]["power"])
		var text = get_spell_name(spells[i])
		scene_instance.set_spell(i, elem, text)
	spell_options.clear()
