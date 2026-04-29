extends Node2D

@export var cell_size := Vector2(170.0, 92.0)
@export var row_skew := Vector2(64.0, -28.0)
@export var line_color := Color(0.24, 0.88, 0.95, 0.56)
@export var fill_color := Color(0.06, 0.13, 0.15, 0.30)
@export var border_color := Color(0.77, 0.64, 0.38, 0.52)


func _draw() -> void:
	for row in 3:
		for column in 3:
			var origin := Vector2(column * cell_size.x, row * cell_size.y) + row * row_skew
			var points := PackedVector2Array([
				origin,
				origin + Vector2(cell_size.x, 0.0),
				origin + Vector2(cell_size.x, cell_size.y),
				origin + Vector2(0.0, cell_size.y)
			])
			var loop_points := points
			loop_points.append(points[0])
			draw_colored_polygon(points, fill_color)
			draw_polyline(loop_points, line_color, 3.0, true)

	var outer := PackedVector2Array([
		Vector2.ZERO,
		Vector2(cell_size.x * 3.0, 0.0),
		Vector2(cell_size.x * 3.0, cell_size.y * 3.0) + row_skew * 2.0,
		Vector2(0.0, cell_size.y * 3.0) + row_skew * 2.0,
		Vector2.ZERO
	])
	draw_polyline(outer, border_color, 7.0, true)
