class_name BallPathEntrance
extends Area3D


var Active := true

@export var Exit : BallPathEntrance


func _ready() -> void:
	assert(get_parent() is BallPath)


func _on_body_entered(body: Node3D) -> void:
	if !Active:
		return
	
	Exit.Active = false
	body.DisplayBody(false)
	body.DisplayBall(true)
	body.StateM.ChangeState("Inactive")
	get_parent().MovePlayer(body)
