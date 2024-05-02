extends BasicState



func _ready():
	DebugMenu.AddMonitor(self, "JumpVel")
	DebugMenu.AddMonitor(self, "InputVel")
	DebugMenu.AddMonitor(self, "InputSpeed")


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Air/blend_amount", -1.0)
	
	owner.SndJump.play()
	
	owner.CharMesh.AlignToY(owner.FloorNormal)
	
	var JumpVelMod = 1.0 #owner.up_direction.dot(Vector3.UP)
	
	get_parent().AirVel = (owner.up_direction.normalized() * owner.PARAMETERS.JUMP_POWER) + (owner.velocity * JumpVelMod)
	get_parent().AddPlayerInput = true


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	#owner.CharMesh.AlignToY(owner.FloorNormal)
	#owner.CharMesh.look_at(owner.global_position + (owner.velocity * (Vector3.ONE - owner.FloorNormal)))
	
	owner.CameraFocus.position.y = clamp(owner.CameraFocus.position.y + (owner.velocity.y * 0.08 * _delta), owner.PARAMETERS.AIR_CAM_FOCUS_MIN_HEIGHT, owner.PARAMETERS.AIR_CAM_FOCUS_MAX_HEIGHT)
	
	
	
	if Input.is_action_just_pressed("Jump"):
		if Input.is_action_just_pressed("Attack"):
			ChangeSubState("Pose")
			return
		else:
			ChangeSubState("Airdash")
			return
	
	if Input.is_action_just_pressed("Attack"):
		if owner.DashMode:
			ChangeSubState("SpinKick", {
			})
			return
		else:
			ChangeState("Ball")
			return

	if get_parent().AirVel.y <= 0.0:
		ChangeSubState("Fall", {
		})
		return
