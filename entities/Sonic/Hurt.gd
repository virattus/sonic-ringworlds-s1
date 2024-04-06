extends BasicState


var SetInvincible := false
var LeftGround := false

const RING = preload("res://entities/RingBounce/RingBounce.tscn")


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Hurt/blend_amount", 1.0)
	owner.AnimTree.set("parameters/OSHurt/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	owner.up_direction = Vector3(0, 1, 0)
	owner.FloorNormal = Vector3(0, 1, 0)
	owner.velocity = Vector3(0, owner.PARAMETERS.HURT_INITIAL_UP_SPEED, 0)
	if _msg.has("BounceDirection"):
		owner.velocity = _msg["BounceDirection"] + owner.velocity
	
	owner.CharMesh.look_at(owner.global_position - (owner.velocity * Vector3(1, 0, 1)).normalized())
	
	if owner.is_on_floor():
		LeftGround = false
	else:
		LeftGround = true
	
	if _msg.has("Bonk") and _msg["Bonk"]:
		owner.SndBonk.play()
	
	if _msg.has("DropRings") and _msg["DropRings"]:
		for i in range(20 if Globals.RingCount > 20 else Globals.RingCount):
			var newRing = RING.instantiate()
			owner.get_parent().add_child(newRing)
			newRing.global_position = owner.global_position
		
		Globals.RingCount = 0
		owner.SndRingDrop.play()
		
		owner.Invincible = true
		owner.set_collision_layer_value(2, false)
		SetInvincible = true


func Exit() -> void:
	owner.AnimTree.set("parameters/Hurt/blend_amount", 0.0)
	owner.AnimTree.set("parameters/OSHurt/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	
	owner.Flicker = true
	
	if SetInvincible:
		owner.TimerInvincibility.start(owner.PARAMETERS.HURT_INVINCIBILITY_TIME)
		owner.set_collision_layer_value(2, true)
		SetInvincible = false


func Update(_delta: float) -> void:
	owner.velocity.y -= owner.PARAMETERS.GRAVITY * _delta
	
	owner.Move(owner.velocity)
	
	if owner.is_on_floor():
		if LeftGround:
			ChangeState("Idle")
			return
	else:
		LeftGround = true
