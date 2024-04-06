extends Node3D



func SetToCollision(_collision: KinematicCollision3D) -> void:
	$CollisionPoint.global_position = _collision.get_position()
	$CollisionNormal.global_position = _collision.get_position() + (_collision.get_normal() * 0.5)
	#$CollisionNormal.look_at(_collision.get_normal())
	#print(_collision.get_normal())


func _on_timer_timeout():
	queue_free()
