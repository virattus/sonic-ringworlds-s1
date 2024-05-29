extends Node3D


@export var ScenePath := "res://maps/SonicRRadicalCity/RadicalCity.glb"
@export var UseFreeCam := false

const SONIC_GAME = preload("res://scenes/SonicGame/SonicGame.tscn")
const RING = preload("res://entities/Coin/Coin.tscn")
const BALLOON = preload("res://entities/Balloon/Balloon.tscn")

func _ready() -> void:
	$FileDialog.show()


func LoadScene() -> void:
	LoadMap()
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


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
		i.create_trimesh_collision()
		var collshape = i.find_child("CollisionShape3D")
		if collshape.shape is ConcavePolygonShape3D:
			collshape.shape.backface_collision = true
	
	var ringnodes = scene.find_children("Ring*")
	for i in ringnodes:
		var newRing = RING.instantiate()
		i.add_child(newRing)
	
	var balloonNodes = scene.find_children("Balloon*")
	for i in balloonNodes:
		var newBalloon = BALLOON.instantiate()
		i.add_child(newBalloon)
	
	var sonic_game = SONIC_GAME.instantiate()
	add_child(sonic_game)
	
	var startNode = scene.find_child("SonicStart")
	var startPos = Vector3.ZERO
	if startNode == null:
		print("Unable to find start point")
	else:
		startPos = startNode.global_position
	
	if UseFreeCam:
		$FreeCam.global_position = startPos
	else:
		$FreeCam.queue_free()
		var sonic = sonic_game.find_child("Sonic")
		sonic.global_position = startPos
		sonic.StartingPosition = startPos
	
	
	
	
	return true


func _on_file_dialog_file_selected(path: String) -> void:
	ScenePath = path
	$FileDialog.hide()
	
	LoadScene()


func _on_file_dialog_canceled() -> void:
	get_tree().quit()


func _on_window_close_requested() -> void:
	get_tree().quit()
