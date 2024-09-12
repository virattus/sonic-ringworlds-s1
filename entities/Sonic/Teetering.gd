extends BasicState


var StickReturnedToNeutral := false


const TEETER_RANGE_1 = 0.75
const TEETER_RANGE_2 = 0.25


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Teetering/blend_amount", 1.0)
	owner.AnimTree.set("parameters/TeeteringLevel/blend_amount", -1.0)

	if _msg.has("CollisionNormal"):
		var range = abs(Vector3.UP.dot(_msg["CollisionNormal"]))
		if range > TEETER_RANGE_1:
			owner.AnimTree.set("parameters/TeeteringLevel/blend_amount", -1.0)
		elif range > TEETER_RANGE_2:
			owner.AnimTree.set("parameters/TeeteringLevel/blend_amount", 0.0)
		else:
			owner.AnimTree.set("parameters/TeeteringLevel/blend_amount", 1.0)

	
	owner.GroundCollision = true
	owner.SetVelocity(Vector3.ZERO)



func Exit() -> void:
	owner.AnimTree.set("parameters/Teetering/blend_amount", 0.0)
	StickReturnedToNeutral = false



func Update(_delta: float) -> void:
	owner.Move()
	
	var InputVel = owner.GetInputVector(Vector3.UP)
	
	if InputVel.length() > 0.0:
		if StickReturnedToNeutral:
			ChangeState("Move")
			return
	else:
		StickReturnedToNeutral = true
