extends BasicState


var CanStick := true
var UpDir := Vector3.ZERO
var JumpVel := Vector3.ZERO
var InputVel := Vector3.ZERO
var InputSpeed := 0.0


const COLLISION_INDICATOR = preload("res://entities/Collision/Collision.tscn")


func _ready() -> void:
	DebugMenu.AddMonitor(self, "CanStick")
	DebugMenu.AddMonitor(self, "UpDir")
	DebugMenu.AddMonitor(self, "JumpVel")
	DebugMenu.AddMonitor(self, "InputVel")
	DebugMenu.AddMonitor(self, "InputSpeed")
	


func Enter(_msg := {}) -> void:
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

	if _msg.has("InputVel"):
		InputVel = _msg["InputVel"]
	else:
		InputVel = Vector3.ZERO
	
	if _msg.has("InputSpeed"):
		InputSpeed = _msg["InputSpeed"]
	else:
		InputSpeed = 0.0
	
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", 0.0)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	JumpVel.y -= owner.PARAMETERS.GRAVITY * _delta * (0.5 if Input.is_action_pressed("Jump") else 1.0)

	InputVel += owner.Controller.InputVelocity * _delta
	if InputVel.length() > owner.PARAMETERS.JUMP_INPUT_VEL_MAX:
		InputVel = InputVel.normalized() * owner.PARAMETERS.JUMP_INPUT_VEL_MAX
	
	var vel = JumpVel + (InputVel * InputSpeed)
	if vel.length() > owner.PARAMETERS.AIR_MAX_SPEED:
		vel.move_toward(vel.normalized() * owner.PARAMETERS.AIR_MAX_SPEED, _delta)
	
	owner.Move(vel)
	#owner.CharMesh.look_at(owner.global_position + (owner.velocity * (Vector3.ONE - owner.FloorNormal)))
	
	owner.CameraFocus.position.y = clamp(owner.CameraFocus.position.y + (owner.velocity.y * 0.18 * _delta), owner.PARAMETERS.AIR_CAM_FOCUS_MIN_HEIGHT, owner.PARAMETERS.AIR_CAM_FOCUS_MAX_HEIGHT)
	
	for i in range(owner.get_slide_collision_count()):
		var collision = owner.get_slide_collision(i)
		var coll = COLLISION_INDICATOR.instantiate()
		owner.get_parent().add_child(coll)
		coll.SetToCollision(collision)
		
		var dot = owner.up_direction.dot(collision.get_normal())
		if dot > owner.PARAMETERS.LAND_ANGLE_MIN:
			print("Fall: Floor hit")
			owner.FloorNormal = collision.get_normal()
			owner.up_direction = collision.get_normal()
			ChangeState("Land")
			return
		elif dot > owner.PARAMETERS.LAND_WIPEOUT_MIN:
			var groundDot = owner.up_direction.dot(Vector3.UP)
			if groundDot > owner.PARAMETERS.LAND_WALL_MIN:
				print("Fall: Side hit grounddot: ", groundDot)
			else:
				print("Fall: wipeout hit")
				owner.FloorNormal = collision.get_normal()
				owner.up_direction = collision.get_normal()
				ChangeState("Wipeout")
				return
		else: #Hit ceiling
			var groundDot = owner.up_direction.dot(Vector3.UP)
			if groundDot < 0.75:
				print("Fall: landed upside down")
				owner.FloorNormal = collision.get_normal()
				owner.up_direction = collision.get_normal()
				ChangeState("Wipeout")
				return
			else:
				print("Fall: hit ceiling? GroundDot was ", groundDot)
	
	if Input.is_action_just_pressed("Jump"):
		if Input.is_action_just_pressed("Attack"):
			ChangeState("Pose")
			return
		else:
			ChangeState("Airdash")
			return
		
	if Input.is_action_just_pressed("Attack"):
		if owner.DashMode:
			ChangeState("SpinKick", {
				"JumpVel": JumpVel,
				"InputVel": InputVel,
				"InputSpeed": InputSpeed,
			})
			return
		else:
			ChangeState("Ball")
			return
