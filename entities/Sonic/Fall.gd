extends BasicState


var UpDir := Vector3.ZERO


const COLLISION_INDICATOR = preload("res://entities/Collision/Collision.tscn")


func _ready() -> void:
	DebugMenu.AddMonitor(self, "UpDir")
	


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Air/blend_amount", 0.0)
	
	if _msg.has("UpDir"):
		UpDir = _msg["UpDir"]
	else:
		UpDir = owner.up_direction


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.CameraFocus.position.y = clamp(owner.CameraFocus.position.y + (owner.velocity.y * 0.18 * _delta), owner.PARAMETERS.AIR_CAM_FOCUS_MIN_HEIGHT, owner.PARAMETERS.AIR_CAM_FOCUS_MAX_HEIGHT)
	
	var collision : SonicCollision = get_parent().CollisionDetection(owner.PARAMETERS.LAND_FLOOR_DOT_MIN, owner.PARAMETERS.LAND_WALL_DOT_MIN)
	if collision != null:
		if collision.CollisionType == SonicCollision.COLL_TYPE.BOTTOM:
			if owner.up_direction.y < 0.0:
				owner.FloorNormal = collision.CollisionNormal
				ChangeState("Wipeout")
				return
			else:
				ChangeState("Land")
				return
		elif collision.CollisionType == SonicCollision.COLL_TYPE.SIDE:
			owner.FloorNormal = collision.CollisionNormal
			ChangeState("Wipeout")
			return
		elif collision.CollisionType == SonicCollision.COLL_TYPE.TOP:
			if owner.up_direction.y < 0.0:
				owner.FloorNormal = collision.CollisionNormal
				ChangeState("Wipeout")
				return
			else:
				get_parent().AirVel.y = 0.0
	
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
				"JumpVel": get_parent().AirVel,
			})
			return
		else:
			ChangeState("Ball")
			return
