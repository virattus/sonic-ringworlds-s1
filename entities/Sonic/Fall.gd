extends BasicState


var CanStick := true
var UpDir := Vector3.ZERO
var InitialVel := Vector3.ZERO
var InputVel := Vector3.ZERO


const COLLISION_INDICATOR = preload("res://entities/Collision/Collision.tscn")

func Enter(_msg := {}) -> void:
	if _msg.has("UpDir"):
		UpDir = _msg["UpDir"]
	else:
		UpDir = owner.up_direction
	
	if _msg.has("CanStick"):
		CanStick = _msg["CanStick"]
	else:
		CanStick = true
	
	if _msg.has("InputVel"):
		InputVel = _msg["InputVel"]
	else:
		InputVel = Vector3.ZERO
	
	if _msg.has("InitialVel"):
		InitialVel = _msg["InitialVel"]
	else:
		InitialVel = owner.velocity
	
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", 0.0)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	InitialVel.y -= owner.PARAMETERS.GRAVITY * _delta * (0.5 if Input.is_action_pressed("Jump") else 1.0)

	InputVel += owner.Controller.InputVelocity * _delta
	if InputVel.length() > 1.0:
		InputVel = InputVel.normalized()
	
	owner.Move(InitialVel + InputVel)
	#owner.CharMesh.look_at(owner.global_position + owner.velocity)
	
	
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
		ChangeState("Airdash")
		return
