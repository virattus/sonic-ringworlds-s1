extends BasicState



var JumpVel := Vector3.ZERO
var InputVel := Vector3.ZERO
var InputSpeed := 0.0



const COLLISION_INDICATOR = preload("res://entities/Collision/Collision.tscn")

func _ready():
	DebugMenu.AddMonitor(self, "JumpVel")
	DebugMenu.AddMonitor(self, "InputVel")
	DebugMenu.AddMonitor(self, "InputSpeed")


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", -1.0)
	
	owner.SndJump.play()
	
	owner.CharMesh.AlignToY(owner.FloorNormal)
	
	JumpVel = owner.velocity + (owner.up_direction.normalized() * owner.PARAMETERS.JUMP_POWER)
	InputVel = Vector3.ZERO
	InputSpeed = owner.velocity.length()


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
	#owner.CharMesh.AlignToY(owner.FloorNormal)
	#owner.CharMesh.look_at(owner.global_position + (owner.velocity * (Vector3.ONE - owner.FloorNormal)))
	
	owner.CameraFocus.position.y = clamp(owner.CameraFocus.position.y + (owner.velocity.y * 0.08 * _delta), owner.PARAMETERS.AIR_CAM_FOCUS_MIN_HEIGHT, owner.PARAMETERS.AIR_CAM_FOCUS_MAX_HEIGHT)
	
	
	for i in range(owner.get_slide_collision_count()):
		var collision = owner.get_slide_collision(i)
		var coll = COLLISION_INDICATOR.instantiate()
		owner.get_parent().add_child(coll)
		coll.SetToCollision(collision)
		
		var dot = owner.up_direction.dot(collision.get_normal())
		if dot > owner.PARAMETERS.LAND_ANGLE_MIN:
			print("Jump: Floor hit")
			owner.FloorNormal = collision.get_normal()
			owner.up_direction = collision.get_normal()
			ChangeState("Land")
			return
		elif dot > owner.PARAMETERS.LAND_WIPEOUT_MIN:
			print("Jump: Side hit")
			
		else: #Hit ceiling
			var groundDot = owner.up_direction.dot(Vector3.UP)
			if groundDot < 0.75:
				print("Jump: landed upside down")
				owner.FloorNormal = collision.get_normal()
				owner.up_direction = collision.get_normal()
				ChangeState("Wipeout")
				return
			else:
				print("Jump: hit ceiling? GroundDot was ", groundDot)
				ChangeState("Fall", {
					"JumpVel": JumpVel,
					"InputVel": InputVel,
					"InputSpeed": InputSpeed,
				})
				return
	
	if Input.is_action_just_pressed("Jump"):
		if Input.is_action_just_pressed("Attack"):
			ChangeState("Pose")
			return
		else:
			ChangeState("Airdash")
			return
	
	if Input.is_action_just_pressed("Attack"):
		ChangeState("Ball")
		return

	if JumpVel.y <= 0.0:
		ChangeState("Fall", {
			"JumpVel": JumpVel,
			"InputVel": InputVel,
			"InputSpeed": InputSpeed,
		})
		return
