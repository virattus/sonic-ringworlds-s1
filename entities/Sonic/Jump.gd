extends BasicState



var JumpUpDir := Vector3.ZERO
var JumpPower := 0.0

var LeftGround := false


func _ready():
	DebugMenu.AddMonitor(self, "JumpUpDir")
	DebugMenu.AddMonitor(self, "JumpPower")
	DebugMenu.AddMonitor(self, "LeftGround")


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", -1.0)
	
	owner.SndJump.play()
	
	JumpPower = owner.PARAMETERS.JUMP_POWER
	JumpUpDir = owner.up_direction


func Exit() -> void:
	LeftGround = false


func Update(_delta: float) -> void:
	if owner.CheckGroundCollision():
		if LeftGround:
			ChangeState("Land", {
				"UpDir": JumpUpDir.normalized()
			})
			return
	else:
		LeftGround = true
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Airdash")
		return
	
	JumpPower -= owner.PARAMETERS.JUMP_POWER_DECEL * _delta
	if JumpPower <= 0.0:
		ChangeState("Fall", {
			"UpDir": JumpUpDir.normalized()
		})
		return

	
	var vel = owner.velocity
	#vel += owner.Controller.InputVelocity
	vel += JumpUpDir * JumpPower * _delta
	vel.y -= owner.PARAMETERS.GRAVITY * _delta * (0.5 if Input.is_action_pressed("Jump") else 1.0)
	
	
	owner.Move(vel)
	#owner.CharMesh.look_at(owner.global_position + owner.velocity)
	
