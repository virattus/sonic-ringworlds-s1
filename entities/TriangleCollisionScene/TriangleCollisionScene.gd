class_name TriangleCollisionScene
extends Node3D


@export var CollisionSource : CollisionShape3D

class CollTriangle:
	var Positions : PackedVector3Array
	var Normal := Vector3.ZERO


var TriangleArray = []
var SortDir := "X"


func _ready() -> void:
	GenerateCollisionInfo()


func GenerateCollisionInfo() -> void:
	assert(CollisionSource.shape != null)
	assert(CollisionSource.shape is ConcavePolygonShape3D)
	
	var collisionfaces = CollisionSource.shape.get_faces()
	
	var i = 0
	
	while i < collisionfaces.size():
		
		
		
		i += 3


func AddTriangle(mdt: MeshDataTool) -> void:
	pass


func GetCollisionNormal(pos: Vector3, normal: Vector3) -> Vector3:
	
	
	
	return Vector3.ZERO
