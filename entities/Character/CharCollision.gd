class_name CharCollision
extends Node


const NONE = 0
const FLOOR = 1
const WALL = 2
const CEILING = 4


var CollisionType := 0
var CollisionNormal := Vector3.ZERO


func _init(type : int, normal := Vector3.ZERO) -> void:
	CollisionType = type
	CollisionNormal = normal
