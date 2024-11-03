extends Node2D
class_name Cave


export var length := 2048  # needs to be larger than the window width
export var min_height := 400
export var max_height := 600
export var min_spacing := 20
export var max_spacing := 200
export var max_change := 50
export var polygon_margin := 300

var center_line = []


func make_cave(start_heights):
	var length_position := 0
	var points_top = [Vector2(0, start_heights[0])]
	var points_bottom = [Vector2(0, start_heights[1])]
	var change = start_heights[2]
	var min_top := 0
	var max_bottom := 0
	var top = start_heights[0]
	var bottom = start_heights[1]
	center_line.append(Vector2(length_position, (top+bottom)/2.0))
	while length_position < length:
		length_position += rand_range(min_spacing, max_spacing)
		length_position = clamp(length_position, 0, length)
		if top < min_top:
			min_top = top
		change += rand_range(0.0, max_change) - max_change/2.0
		change = clamp(change, -max_change, max_change)
		top += change
		points_top.append(Vector2(length_position, top))
		bottom = top + rand_range(min_height, max_height)
		if bottom > max_bottom:
			max_bottom = bottom
		points_bottom.append(Vector2(length_position, bottom))
		center_line.append(Vector2(length_position, (top+bottom)/2.0))
			
	var polygon_top = Polygon2D.new()
	var polygon_bottom = Polygon2D.new()
	polygon_top.texture = preload("res://sprites/bg/stone.png")
	polygon_bottom.texture = preload("res://sprites/bg/stone.png")
	add_child(polygon_top)
	add_child(polygon_bottom)
	var line_top = Line2D.new()
	var line_bottom = Line2D.new()
	line_top.texture = preload("res://sprites/bg/grass.png")
	line_bottom.texture = preload("res://sprites/bg/grass.png")
	line_top.width = 16
	line_top.default_color = Color.white
	line_bottom.width = 16
	line_bottom.default_color = Color.white
	line_top.texture_mode = Line2D.LINE_TEXTURE_TILE
	line_bottom.texture_mode = Line2D.LINE_TEXTURE_TILE
	add_child(line_top)
	add_child(line_bottom)
	
	var line_center = Line2D.new()
	add_child(line_center)
	line_center.hide()
	line_center.points = PoolVector2Array(center_line)
	

	line_top.points = PoolVector2Array(points_top)
	line_bottom.points = PoolVector2Array(points_bottom)
	
	points_top.append(Vector2(length, min_top-polygon_margin))
	points_top.append(Vector2(0, min_top-polygon_margin))
	points_bottom.append(Vector2(length, max_bottom+polygon_margin))
	points_bottom.append(Vector2(0, max_bottom+polygon_margin))
	
	polygon_top.polygon = points_top
	polygon_bottom.polygon = points_bottom
	
	var body_top = StaticBody2D.new()
	add_child(body_top)
	var collider_top = CollisionPolygon2D.new()
	body_top.add_child(collider_top)
	collider_top.polygon = points_top


	var body_bottom = StaticBody2D.new()
	add_child(body_bottom)
	var collider_bottom = CollisionPolygon2D.new()
	body_bottom.add_child(collider_bottom)
	collider_bottom.polygon = points_bottom	
	
	return [top, bottom, change]

