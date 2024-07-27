extends BasicState


var VerticalVelocity := 0.0


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Death/blend_amount", 1.0)
	
	owner.SndDeath.play()
	VerticalVelocity = owner.PARAMETERS.DEATH_INITIAL_VERTICAL_VELOCITY
	owner.DashModeDrain = false
	
	owner.HealthEmpty.emit()
	

func Exit() -> void:
	owner.AnimTree.set("parameters/Death/blend_amount", 0.0)
	owner.SndDeath.play()


func Update(_delta: float) -> void:
	var cam = get_viewport().get_camera_3d()
	
	owner.CharMesh.look_at(cam.global_transform.origin)
	
	VerticalVelocity -= owner.PARAMETERS.GRAVITY * _delta
	
	owner.CharMesh.global_position.y += VerticalVelocity * _delta
