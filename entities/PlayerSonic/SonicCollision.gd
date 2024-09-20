class_name SonicCollision
extends Node


enum {
	NONE,
	FLOOR,
	WALL,
	CEILING,
}


var CollisionType = NONE
var CollisionNormal := Vector3.ZERO


func _init(type, normal := Vector3.ZERO) -> void:
	CollisionType = type
	CollisionNormal = normal
