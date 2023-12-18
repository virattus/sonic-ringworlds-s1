extends BasicState


var VerticalVelocity := 0.0

var HorizVelocity := Vector3.ZERO
var InputVelocity := Vector3.ZERO


const INPUT_VEL_MULTIPLIER = 6.0


func Enter(_msg := {}) -> void:
	HorizVelocity = owner.velocity * Vector3(1.0, 0.0, 1.0)
	if HorizVelocity.length() > 0.0:
		owner.CharMesh.look_at(owner.global_position + HorizVelocity, Vector3.UP)


func Exit() -> void:
	InputVelocity = Vector3.ZERO
	

func Update(_delta: float) -> void:
	VerticalVelocity -= (owner.Gravity * 
		(owner.PARAMETERS.JUMP_BUTTON_HELD_GRAVITY_MODIFIER 
		if owner.Controller.InputJump == CharController.BUTTON_PRESSED else 1.0)) * _delta
	
	#JumpVelocity += (owner.Controller.InputVelocity * 0.1) * Vector3(1, 0, 1)
	#JumpVelocity.y = VerticalVelocity
	
	
	#HorizVelocity (owner.Controller.InputVelocity * _delta)
	InputVelocity = lerp(InputVelocity, owner.Controller.InputVelocity * INPUT_VEL_MULTIPLIER, _delta)
	#print(InputVelocity.length())
	
	owner.Move(HorizVelocity + (Vector3.UP * VerticalVelocity) + InputVelocity)
