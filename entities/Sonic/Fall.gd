extends BasicState


var CanStick := true
var UpDir := Vector3.ZERO
var JumpVel := Vector3.ZERO


const COLLISION_INDICATOR = preload("res://entities/Collision/Collision.tscn")


func _ready() -> void:
	DebugMenu.AddMonitor(self, "CanStick")
	DebugMenu.AddMonitor(self, "UpDir")
	DebugMenu.AddMonitor(self, "JumpVel")
	


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Air/blend_amount", 0.0)
	
	if _msg.has("UpDir"):
		UpDir = _msg["UpDir"]
	else:
		UpDir = owner.up_direction
	
	if _msg.has("CanStick"):
		CanStick = _msg["CanStick"]
	else:
		CanStick = true
	
	if _msg.has("JumpVel"):
		JumpVel = _msg["JumpVel"]
	else:
		print("Fall: using current velocity")
		JumpVel = owner.velocity


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.CameraFocus.position.y = clamp(owner.CameraFocus.position.y + (owner.velocity.y * 0.18 * _delta), owner.PARAMETERS.AIR_CAM_FOCUS_MIN_HEIGHT, owner.PARAMETERS.AIR_CAM_FOCUS_MAX_HEIGHT)
	
	var collision : SonicCollision = get_parent().CollisionDetection()
	if collision != null:
		if collision.CollisionType == SonicCollision.COLL_TYPE.BOTTOM:
			print("Fall: Hit floor")
			ChangeState("Land")
			return
		elif collision.CollisionType == SonicCollision.COLL_TYPE.SIDE:
			ChangeState("Wipeout")
			return
	
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
				"JumpVel": JumpVel,
			})
			return
		else:
			ChangeState("Ball")
			return
