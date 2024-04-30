class_name SonicCollision
extends Node

enum COLL_TYPE {
	TOP,
	SIDE,
	BOTTOM,
}


var CollisionType : COLL_TYPE
var CollisionPoint : Vector3
var CollisionNormal : Vector3



func _init(type, point, normal) -> void:
	CollisionType = type
	CollisionPoint = point
	CollisionNormal = normal
