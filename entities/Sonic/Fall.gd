extends BasicState


var CanStick := true
var UpDir := Vector3.ZERO


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
	
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", 0.0)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	var vel = owner.velocity
	vel += owner.Controller.InputVelocity
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
		owner.FloorNormal = collision.get_normal()
		owner.up_direction = collision.get_normal()
		if dot > 0.0:
			ChangeState("Land")
			return
		else:
			ChangeState("Land")
			return

	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Airdash")
		return
