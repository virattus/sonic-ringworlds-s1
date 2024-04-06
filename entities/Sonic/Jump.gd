extends BasicState



var JumpUpDir := Vector3.ZERO
var JumpPower := 0.0


const COLLISION_INDICATOR = preload("res://entities/Collision/Collision.tscn")

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
	pass


func Update(_delta: float) -> void:
	var vel = owner.velocity
	
	if owner.Controller.InputVelocity.length() > 0.0:
		var InputVel = (owner.Controller.InputVelocity * owner.PARAMETERS.AIR_INPUT_MAGNITUDE)
		InputVel *= 1.0 - clamp(owner.Speed / owner.PARAMETERS.AIR_MAX_SPEED, 0.0, 1.0)
	
		vel += InputVel
	else:
		vel = lerp(vel, Vector3.ZERO, owner.PARAMETERS.RUN_DECEL_RATE * _delta)
	
	vel += JumpUpDir * JumpPower * _delta
	vel.y -= owner.PARAMETERS.GRAVITY * _delta * (0.5 if Input.is_action_pressed("Jump") else 1.0)
	
	
	owner.Move(vel)
	#owner.CharMesh.look_at(owner.global_position + owner.velocity)
	
	
	for i in range(owner.get_slide_collision_count()):
		var collision = owner.get_slide_collision(i)
		var coll = COLLISION_INDICATOR.instantiate()
		owner.get_parent().add_child(coll)
		coll.SetToCollision(collision)
		
		var dot = owner.up_direction.dot(collision.get_normal())
		print(dot)
		if dot > owner.PARAMETERS.LAND_ANGLE_MAX:
			print("Jump: Floor hit")
			owner.FloorNormal = collision.get_normal()
			owner.up_direction = collision.get_normal()
			ChangeState("Land")
			return
		elif dot > owner.PARAMETERS.WIPEOUT_ANGLE_MAX:
			print("Jump: wipeout hit")
			owner.FloorNormal = collision.get_normal()
			owner.up_direction = collision.get_normal()
			ChangeState("Wipeout")
			return
		else:
			print("Jump: Ceiling hit?")
			var groundDot = owner.up_direction.dot(Vector3(0, 1, 0))
			if groundDot < 0.75:
				print("upside down")
				owner.FloorNormal = collision.get_normal()
				owner.up_direction = collision.get_normal()
				ChangeState("Wipeout")
				return
			else:
				print("should be ceiling hit")
				JumpPower = 0.0
	
	JumpPower -= owner.PARAMETERS.JUMP_POWER_DECEL * _delta
	if JumpPower <= 0.0:
		ChangeState("Fall", {
			"UpDir": JumpUpDir.normalized()
		})
		return
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Airdash")
		return
	
