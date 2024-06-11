extends Control


func _process(delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	draw_arc(Vector2(0, 0), 40, deg_to_rad(0.0), deg_to_rad(360.0), 42, Color.DIM_GRAY, 25.0, true)
	draw_arc(Vector2(0, 0), 40, deg_to_rad(0.0), deg_to_rad((Globals.RingCount / 100.0) * 360.0), 42, Color.YELLOW, 25.0, true)
