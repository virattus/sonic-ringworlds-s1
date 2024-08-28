extends Node2D



func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		NewGame()
	elif event is InputEventKey:
		assert(event is not InputEventMouseMotion)
		NewGame()
		

func NewGame() -> void:
	get_tree().change_scene_to_file("res://scenes/MovementTesting/MovementTesting.tscn")
