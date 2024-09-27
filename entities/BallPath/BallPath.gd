class_name BallPath
extends Path3D


var PlayerNode : Player

var Active := false


const PATH_SPEED = 15.0


func _ready() -> void:
	pass



func _physics_process(delta: float) -> void:
	if !Active:
		return
	
	if $PathFollow3D.progress_ratio >= 1.0:
		Active = false
		PlayerNode.DisplayBody(true)
		PlayerNode.DisplayBall(false)
		PlayerNode.SetVelocity(Vector3.ZERO)
		PlayerNode.StateM.ChangeState("Fall")
		PlayerNode = null
		return
	
	$PathFollow3D.progress += PATH_SPEED * delta
	PlayerNode.global_position = $PathFollow3D.global_position


func MovePlayer(playerNode: Player) -> void:
	PlayerNode = playerNode
	Active = true
