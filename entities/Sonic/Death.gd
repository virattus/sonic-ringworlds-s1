extends BasicState


var VerticalVelocity := 0.0

var Gravity := 0.0

const DEATH_INITIAL_VERTICAL_VELOCITY = 5.0


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Death/blend_amount", 1.0)
	
	VerticalVelocity = DEATH_INITIAL_VERTICAL_VELOCITY
	if _msg.has("InitialVerticalVel"):
		VerticalVelocity = _msg["InitialVerticalVelocity"]

	Gravity = owner.PARAMETERS.GRAVITY
	if _msg.has("Gravity"):
		Gravity = _msg["Gravity"]
	
	owner.SndDeath.play()
	owner.DashModeDrain = false
	
	owner.ActivateHitbox(false)
	owner.ActivateHurtbox(false)
	
	owner.HealthEmpty.emit()
	

func Exit() -> void:
	owner.AnimTree.set("parameters/Death/blend_amount", 0.0)
	owner.SndDeath.play()


func Update(_delta: float) -> void:
	var cam = get_viewport().get_camera_3d()
	
	owner.CharMesh.look_at(cam.global_transform.origin)
	
	VerticalVelocity -= Gravity * _delta
	
	owner.CharMesh.global_position.y += VerticalVelocity * _delta
