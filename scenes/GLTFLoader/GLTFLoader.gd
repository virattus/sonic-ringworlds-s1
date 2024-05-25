extends Node3D


@export var ScenePath := "res://maps/SonicRRadicalCity/RadicalCity.glb"
@export var UseFreeCam := false

const SONIC_GAME = preload("res://scenes/SonicGame/SonicGame.tscn")

func _ready() -> void:
	pass


func LoadScene() -> void:
	LoadMap()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func LoadMap() -> bool:
	if !FileAccess.file_exists(ScenePath):
		print("Attempting to load map that doesn't exist")
		return false
	
	var gltf = GLTFDocument.new()
	var gltfState = GLTFState.new()
	
	if gltf.append_from_file(ScenePath, gltfState) != OK:
		print("Failed to load gltf: %s", ScenePath)
		return false
	
	var scene = gltf.generate_scene(gltfState)
	if scene == null:
		print("Unable to load scene: %s", ScenePath)
		return false
		
	
	add_child(scene)
	
	var collnodes = scene.find_children("*-col")
	for i in collnodes:
		print(i.name)
		i.create_convex_collision(false, false)
		var collshape = i.find_child("CollisionShape3D")
		if collshape.shape is ConcavePolygonShape3D:
			collshape.shape.backface_collision = true
		else:
			print("this should never appear")
		
	
	var sonic_game = SONIC_GAME.instantiate()
	add_child(sonic_game)
	
	var startNode = scene.find_child("SonicStart")
	if startNode == null:
		print("Unable to find start point")
	else:
		if UseFreeCam:
			$FreeCam.global_position = startNode.global_position
		else:
			$FreeCam.queue_free()
			var sonic = sonic_game.find_child("Sonic")
			sonic.global_position = startNode.global_position
	
	
	
	
	return true


func _on_file_dialog_file_selected(path: String) -> void:
	ScenePath = path
	$FileDialog.queue_free()
	
	LoadScene()


func _on_file_dialog_canceled() -> void:
	get_tree().quit()


func _on_window_close_requested() -> void:
	get_tree().quit()
