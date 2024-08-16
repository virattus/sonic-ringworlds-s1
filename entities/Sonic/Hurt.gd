extends "res://entities/Sonic/MoveAir.gd"


var SetInvincible := false
var LeftGround := false

const HURT_INITIAL_UP_SPEED = 5.0

const RING = preload("res://entities/RingBounce/RingBounce.tscn")



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Hurt/blend_amount", 1.0)
	owner.AnimTree.set("parameters/OSHurt/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	owner.velocity = Vector3(0, HURT_INITIAL_UP_SPEED, 0)
	if _msg.has("BounceDirection"):
		owner.velocity = _msg["BounceDirection"] + owner.velocity
	
	owner.UpdateUpDir(Vector3(0, 1, 0), 1.0)
	owner.CharMesh.look_at(owner.global_position - (owner.velocity * Vector3(1, 0, 1)).normalized())
	
	if owner.GroundCollision:
		LeftGround = false
	else:
		LeftGround = true
	
	if _msg.has("Bonk") and _msg["Bonk"]:
		owner.SndBonk.play()
	
	if _msg.has("DropRings") and _msg["DropRings"]:
		var DroppedRings = owner.PARAMETERS.HURT_DROPPED_RING_COUNT
		if Globals.RingCount - owner.PARAMETERS.HURT_DROPPED_RING_COUNT < 0:
			DroppedRings = Globals.RingCount
		
		for i in range(DroppedRings):
			var newRing = RING.instantiate()
			owner.get_parent().add_child(newRing)
			newRing.global_position = owner.global_position
			newRing.SetVelocity(owner.DroppedRingSpeed)
		
		Globals.RingCount -= DroppedRings
		owner.SndRingDrop.play()
		
		owner.Invincible = true
		owner.set_collision_layer_value(2, false)
		SetInvincible = true
		
		owner.DroppedRingSpeed += owner.PARAMETERS.HURT_DROPPED_RING_SPEED


func Exit() -> void:
	owner.AnimTree.set("parameters/Hurt/blend_amount", 0.0)
	owner.AnimTree.set("parameters/OSHurt/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	
	owner.Flicker = true
	
	if SetInvincible:
		owner.TimerInvincibility.start(owner.PARAMETERS.HURT_INVINCIBILITY_TIME)
		owner.set_collision_layer_value(2, true)
		SetInvincible = false


func Update(_delta: float) -> void:
	owner.Move()
	
	var collision : SonicCollision = owner.GetCollision()
	if CheckGroundCollision(collision):
		if LeftGround:
			ChangeState("Land", {
				"Flicker": 1.0,
			})
			return
		else:
			LeftGround = true
		
	var newVel : Vector3 = owner.velocity
	
	newVel = owner.ApplyGravity(newVel, _delta)
	
	owner.SetVelocity(newVel)
